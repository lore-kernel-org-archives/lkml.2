Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1GVW7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:59:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab1GVW73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:59:29 -0400
Date: Sat, 23 Jul 2011 08:59:15 +1000
From: NeilBrown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110723085915.308ddc02@notabene.brown>
In-Reply-To: <20110722223158.GC10749@fieldses.org>
References: <1311271641.14555.114.camel@calx>
	<m2pql2c0qz.fsf@firstfloor.org>
	<20110722163335.2df4f6ca@notabene.brown>
	<1311363269.14555.261.camel@calx>
	<20110722205922.GS8006@one.firstfloor.org>
	<1311369102.14555.268.camel@calx>
	<20110722214732.GW8006@one.firstfloor.org>
	<20110722221039.GB10749@fieldses.org>
	<20110722223158.GC10749@fieldses.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 18:31:58 -0400 "J. Bruce Fields" <bfields@fieldses.org>
wrote:

> On Fri, Jul 22, 2011 at 06:10:39PM -0400, bfields wrote:
> > On Fri, Jul 22, 2011 at 11:47:32PM +0200, Andi Kleen wrote:
> > > On Fri, Jul 22, 2011 at 04:11:42PM -0500, Matt Mackall wrote:
> > > > On Fri, 2011-07-22 at 22:59 +0200, Andi Kleen wrote:
> > > > > > Indeed. Only usefully exists on ext4 and requires extra system calls.
> > > > > 
> > > > > Not sure what you mean?  It's in stat(2), just like the timestamps.
> > > > 
> > > > I don't see anything that looks like a version or generation number in
> > > > either the man pages, the asm-generic/stat.h, or glibc's asm/stat.h.
> > > > Pointer?
> > > 
> > > Hmm you're right. I thought it was in there, but apparently not.
> > > I think it should be added there though. We still have some unused 
> > > fields.
> > 
> > But last I checked I thought it was only ext4 that actually incremented
> > the i_version on IO, and even then only when given a (non-default) mount
> > option.
> > 
> > My notes on what needs to be done there:
> > 
> > 	- collect data to determine whether turning on i_version causes
> > 	  any significant performance regressions.
> > 		- Last I talked to him, Ted Tso recommended running
> > 		  Bonnie on a local disk, since it does a lot of little
> > 		  writes, which is somewhat of a worst case, as it will
> > 		  generate extra metadata updates for each write.
> > 		  Compare total wall-clock time, number of iops, and
> > 		  number of bytes (using some kind of block tracing).
> > 	- If there aren't any problems, turn it on by default, and we're
> > 	  done.
> 
> (Well,and talk the other filesystem implementors into doing it.)
> 

But does anyone apart from NFSv4 actually *want* i_version as opposed to the
more-generally-useful precise timestamps?

If not, we probably should tell NFSv4 to use timestamps and focus on making
them work well.
??

The timestamp used doesn't need to update ever nanosecond.  I think if it
were just updated on every userspace->kernel transition  (or effective
equivalents inside kernel threads) that would be enough capture all
causality.  I wonder how that would be achieved..  I wonder if RCU machinery
could help - doesn't it keep track of when threads schedule ... or something?

NeilBrown
