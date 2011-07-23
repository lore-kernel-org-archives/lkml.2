Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab1GWBiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 21:38:22 -0400
Received: from fieldses.org ([174.143.236.118]:57576 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1GWBiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 21:38:15 -0400
Date: Fri, 22 Jul 2011 21:38:10 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Matt Mackall <mpm@selenic.com>
Cc: NeilBrown <neilb@suse.de>, Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110723013809.GA12174@fieldses.org>
References: <m2pql2c0qz.fsf@firstfloor.org>
 <20110722163335.2df4f6ca@notabene.brown>
 <1311363269.14555.261.camel@calx>
 <20110722205922.GS8006@one.firstfloor.org>
 <1311369102.14555.268.camel@calx>
 <20110722214732.GW8006@one.firstfloor.org>
 <20110722221039.GB10749@fieldses.org>
 <20110722223158.GC10749@fieldses.org>
 <20110723085915.308ddc02@notabene.brown>
 <1311379661.20898.23.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311379661.20898.23.camel@calx>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 07:07:41PM -0500, Matt Mackall wrote:
> On Sat, 2011-07-23 at 08:59 +1000, NeilBrown wrote:
> > On Fri, 22 Jul 2011 18:31:58 -0400 "J. Bruce Fields" <bfields@fieldses.org>
> > wrote:
> > 
> > > On Fri, Jul 22, 2011 at 06:10:39PM -0400, bfields wrote:
> > > > On Fri, Jul 22, 2011 at 11:47:32PM +0200, Andi Kleen wrote:
> > > > > On Fri, Jul 22, 2011 at 04:11:42PM -0500, Matt Mackall wrote:
> > > > > > On Fri, 2011-07-22 at 22:59 +0200, Andi Kleen wrote:
> > > > > > > > Indeed. Only usefully exists on ext4 and requires extra system calls.
> > > > > > > 
> > > > > > > Not sure what you mean?  It's in stat(2), just like the timestamps.
> > > > > > 
> > > > > > I don't see anything that looks like a version or generation number in
> > > > > > either the man pages, the asm-generic/stat.h, or glibc's asm/stat.h.
> > > > > > Pointer?
> > > > > 
> > > > > Hmm you're right. I thought it was in there, but apparently not.
> > > > > I think it should be added there though. We still have some unused 
> > > > > fields.
> > > > 
> > > > But last I checked I thought it was only ext4 that actually incremented
> > > > the i_version on IO, and even then only when given a (non-default) mount
> > > > option.
> > > > 
> > > > My notes on what needs to be done there:
> > > > 
> > > > 	- collect data to determine whether turning on i_version causes
> > > > 	  any significant performance regressions.
> > > > 		- Last I talked to him, Ted Tso recommended running
> > > > 		  Bonnie on a local disk, since it does a lot of little
> > > > 		  writes, which is somewhat of a worst case, as it will
> > > > 		  generate extra metadata updates for each write.
> > > > 		  Compare total wall-clock time, number of iops, and
> > > > 		  number of bytes (using some kind of block tracing).
> > > > 	- If there aren't any problems, turn it on by default, and we're
> > > > 	  done.
> > > 
> > > (Well,and talk the other filesystem implementors into doing it.)
> > > 
> > 
> > But does anyone apart from NFSv4 actually *want* i_version as opposed to the
> > more-generally-useful precise timestamps?
> 
> In theory, a microsecond timestamp (ie gtod) may already not be good
> enough for all applications. But i_version also doesn't allow comparing
> across files.
> 
> > If not, we probably should tell NFSv4 to use timestamps and focus on making
> > them work well.
> > ??
> > 
> > The timestamp used doesn't need to update ever nanosecond.  I think if it
> > were just updated on every userspace->kernel transition  (or effective
> > equivalents inside kernel threads) that would be enough capture all
> > causality.  I wonder how that would be achieved..  I wonder if RCU machinery
> > could help - doesn't it keep track of when threads schedule ... or something?
> 
> Sort of.
> 
> Some observations:
> 
> - we only need to go to higher resolution when two events happen in the
> same time quantum
> - this applies at both the level of seconds and jiffies
> - if the only file touched in a given quantum gets touched ago, we don't
> need to update its timestamp if stat wasn't also called on it in this
> quantum
> - we never need to use a higher resolution than the global
> min(s_time_gran)

Right, so there was a rough algorithm hashed out somewhere around here:

	http://thread.gmane.org/gmane.linux.kernel/1022866/focus=1024624

that depended on those observations.

NFS presents a worst-case as the standard NFSv3 read and write
operations include timestamps in the result.  So every single IO comes
with a stat.  So either you have a clock good enough to give a distinct
timestamp for all of those, or you fall back on a global counter that
ends up serializing all IO.  I think.  I admit I'm not sure I understand
your proposal below.

--b.

> 
> 
> For instance, if a machine is idle, except for writing to a single file
> once a second, 1s resolution suffices.
> 
> If a machine is idle, except for writing to the same file 1000 times per
> second, and no one is watching it, 1s still suffices (inode is dirtied
> once per second).
> 
> Any time two files are touched in the same second, the second one (and
> later files) needs jiffies resolution. Similarly, any time two files are
> touched in the same jiffy, the second one should use gtod().
> 
> The global status bits needed to track this could be managed fairly
> efficiently with cmpxchg.
> 
> (Arguably, we should supply > 1s resolution whether they're strictly
> needed or not on filesystems with nanosecond support, so that people
> casually inspecting timestamps don't wonder where their nanoseconds
> went.)
> 
> -- 
> Mathematics is the supreme nostalgia of our time.
> 
> 
