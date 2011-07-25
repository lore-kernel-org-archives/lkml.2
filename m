Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1GYPJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:09:43 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42795 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1GYPJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:09:38 -0400
Date: Mon, 25 Jul 2011 08:09:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: NeilBrown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Andi Kleen <andi@firstfloor.org>,
        Matt Mackall <mpm@selenic.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110725150931.GD2327@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1311271641.14555.114.camel@calx>
 <m2pql2c0qz.fsf@firstfloor.org>
 <20110722163335.2df4f6ca@notabene.brown>
 <1311363269.14555.261.camel@calx>
 <20110722205922.GS8006@one.firstfloor.org>
 <1311369102.14555.268.camel@calx>
 <20110722214732.GW8006@one.firstfloor.org>
 <20110722221039.GB10749@fieldses.org>
 <20110722223158.GC10749@fieldses.org>
 <20110723085915.308ddc02@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723085915.308ddc02@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 08:59:15AM +1000, NeilBrown wrote:
> On Fri, 22 Jul 2011 18:31:58 -0400 "J. Bruce Fields" <bfields@fieldses.org>
> wrote:
> 
> > On Fri, Jul 22, 2011 at 06:10:39PM -0400, bfields wrote:
> > > On Fri, Jul 22, 2011 at 11:47:32PM +0200, Andi Kleen wrote:
> > > > On Fri, Jul 22, 2011 at 04:11:42PM -0500, Matt Mackall wrote:
> > > > > On Fri, 2011-07-22 at 22:59 +0200, Andi Kleen wrote:
> > > > > > > Indeed. Only usefully exists on ext4 and requires extra system calls.
> > > > > > 
> > > > > > Not sure what you mean?  It's in stat(2), just like the timestamps.
> > > > > 
> > > > > I don't see anything that looks like a version or generation number in
> > > > > either the man pages, the asm-generic/stat.h, or glibc's asm/stat.h.
> > > > > Pointer?
> > > > 
> > > > Hmm you're right. I thought it was in there, but apparently not.
> > > > I think it should be added there though. We still have some unused 
> > > > fields.
> > > 
> > > But last I checked I thought it was only ext4 that actually incremented
> > > the i_version on IO, and even then only when given a (non-default) mount
> > > option.
> > > 
> > > My notes on what needs to be done there:
> > > 
> > > 	- collect data to determine whether turning on i_version causes
> > > 	  any significant performance regressions.
> > > 		- Last I talked to him, Ted Tso recommended running
> > > 		  Bonnie on a local disk, since it does a lot of little
> > > 		  writes, which is somewhat of a worst case, as it will
> > > 		  generate extra metadata updates for each write.
> > > 		  Compare total wall-clock time, number of iops, and
> > > 		  number of bytes (using some kind of block tracing).
> > > 	- If there aren't any problems, turn it on by default, and we're
> > > 	  done.
> > 
> > (Well,and talk the other filesystem implementors into doing it.)
> > 
> 
> But does anyone apart from NFSv4 actually *want* i_version as opposed to the
> more-generally-useful precise timestamps?
> 
> If not, we probably should tell NFSv4 to use timestamps and focus on making
> them work well.
> ??
> 
> The timestamp used doesn't need to update ever nanosecond.  I think if it
> were just updated on every userspace->kernel transition  (or effective
> equivalents inside kernel threads) that would be enough capture all
> causality.  I wonder how that would be achieved..  I wonder if RCU machinery
> could help - doesn't it keep track of when threads schedule ... or something?

RCU does track thread scheduling, but currently only pays attention to
it if there is an RCU grace period in progress.  It would be easy to
make it track more precisely, though, if that would help something.

That said, I suspect that Peter Zijlstra would be extremely unhappy with
any proposed change that (say) acquired a global lock on every thread
schedule.  And I don't believe that he would be all that happy even with a
change that added a non-global lock acquisition to each context switch...

							Thanx, Paul

							Thanx, Paul
