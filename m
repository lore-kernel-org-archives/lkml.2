Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab1GWCgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 22:36:00 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:41310 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1GWCfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 22:35:52 -0400
X-Greylist: delayed 1443 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 22:35:51 EDT
Subject: Re: Nanosecond fs timestamp support: sad
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Matt Mackall <mpm@selenic.com>, NeilBrown <neilb@suse.de>,
        Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jul 2011 22:10:38 -0400
In-Reply-To: <20110723013809.GA12174@fieldses.org>
References: <m2pql2c0qz.fsf@firstfloor.org>
	 <20110722163335.2df4f6ca@notabene.brown> <1311363269.14555.261.camel@calx>
	 <20110722205922.GS8006@one.firstfloor.org>
	 <1311369102.14555.268.camel@calx>
	 <20110722214732.GW8006@one.firstfloor.org>
	 <20110722221039.GB10749@fieldses.org> <20110722223158.GC10749@fieldses.org>
	 <20110723085915.308ddc02@notabene.brown> <1311379661.20898.23.camel@calx>
	 <20110723013809.GA12174@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311387104.13553.89.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 1470 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: FCC1DEB8B4B844D693F199FE4EA21BA026067A22
X-UiO-SPAM-Test: remote_host: 98.250.108.142 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 56 max/h 2 blacklist 0 greylist 0 ratelimit 0
X-UiOonly: 984A36D0D1560557FAF23D31D53655C5DB117718
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 21:38 -0400, J. Bruce Fields wrote: 
> On Fri, Jul 22, 2011 at 07:07:41PM -0500, Matt Mackall wrote:
> > On Sat, 2011-07-23 at 08:59 +1000, NeilBrown wrote:
> > > On Fri, 22 Jul 2011 18:31:58 -0400 "J. Bruce Fields" <bfields@fieldses.org>
> > > wrote:
> > > 
> > > > On Fri, Jul 22, 2011 at 06:10:39PM -0400, bfields wrote:
> > > > > On Fri, Jul 22, 2011 at 11:47:32PM +0200, Andi Kleen wrote:
> > > > > > On Fri, Jul 22, 2011 at 04:11:42PM -0500, Matt Mackall wrote:
> > > > > > > On Fri, 2011-07-22 at 22:59 +0200, Andi Kleen wrote:
> > > > > > > > > Indeed. Only usefully exists on ext4 and requires extra system calls.
> > > > > > > > 
> > > > > > > > Not sure what you mean?  It's in stat(2), just like the timestamps.
> > > > > > > 
> > > > > > > I don't see anything that looks like a version or generation number in
> > > > > > > either the man pages, the asm-generic/stat.h, or glibc's asm/stat.h.
> > > > > > > Pointer?
> > > > > > 
> > > > > > Hmm you're right. I thought it was in there, but apparently not.
> > > > > > I think it should be added there though. We still have some unused 
> > > > > > fields.
> > > > > 
> > > > > But last I checked I thought it was only ext4 that actually incremented
> > > > > the i_version on IO, and even then only when given a (non-default) mount
> > > > > option.
> > > > > 
> > > > > My notes on what needs to be done there:
> > > > > 
> > > > > 	- collect data to determine whether turning on i_version causes
> > > > > 	  any significant performance regressions.
> > > > > 		- Last I talked to him, Ted Tso recommended running
> > > > > 		  Bonnie on a local disk, since it does a lot of little
> > > > > 		  writes, which is somewhat of a worst case, as it will
> > > > > 		  generate extra metadata updates for each write.
> > > > > 		  Compare total wall-clock time, number of iops, and
> > > > > 		  number of bytes (using some kind of block tracing).
> > > > > 	- If there aren't any problems, turn it on by default, and we're
> > > > > 	  done.
> > > > 
> > > > (Well,and talk the other filesystem implementors into doing it.)
> > > > 
> > > 
> > > But does anyone apart from NFSv4 actually *want* i_version as opposed to the
> > > more-generally-useful precise timestamps?
> > 
> > In theory, a microsecond timestamp (ie gtod) may already not be good
> > enough for all applications. But i_version also doesn't allow comparing
> > across files.
> > 
> > > If not, we probably should tell NFSv4 to use timestamps and focus on making
> > > them work well.
> > > ??
> > > 
> > > The timestamp used doesn't need to update ever nanosecond.  I think if it
> > > were just updated on every userspace->kernel transition  (or effective
> > > equivalents inside kernel threads) that would be enough capture all
> > > causality.  I wonder how that would be achieved..  I wonder if RCU machinery
> > > could help - doesn't it keep track of when threads schedule ... or something?
> > 
> > Sort of.
> > 
> > Some observations:
> > 
> > - we only need to go to higher resolution when two events happen in the
> > same time quantum
> > - this applies at both the level of seconds and jiffies
> > - if the only file touched in a given quantum gets touched ago, we don't
> > need to update its timestamp if stat wasn't also called on it in this
> > quantum
> > - we never need to use a higher resolution than the global
> > min(s_time_gran)
> 
> Right, so there was a rough algorithm hashed out somewhere around here:
> 
> 	http://thread.gmane.org/gmane.linux.kernel/1022866/focus=1024624
> 
> that depended on those observations.
> 
> NFS presents a worst-case as the standard NFSv3 read and write
> operations include timestamps in the result.  So every single IO comes
> with a stat.  So either you have a clock good enough to give a distinct
> timestamp for all of those, or you fall back on a global counter that
> ends up serializing all IO.  I think.  I admit I'm not sure I understand
> your proposal below.

...or you admit that NFSv3 is no longer able to keep up with modern
processing speeds and storage, and you ditch it in favour of NFSv4.

Time-stamps are _not_ the optimal way to label changes in a clustered
environment (or even a multi-cpu/multi-core environment): aside from the
various issues involving absolute time vs. wall clock time, you also
have to deal with clock synchronisation across those nodes/cpus/cores at
the < microsecond resolution level. Have fun doing that...

   Trond

