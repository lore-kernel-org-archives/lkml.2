Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab1GVWKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:10:45 -0400
Received: from fieldses.org ([174.143.236.118]:48481 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1GVWKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:10:44 -0400
Date: Fri, 22 Jul 2011 18:10:39 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, NeilBrown <neilb@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110722221039.GB10749@fieldses.org>
References: <1311271641.14555.114.camel@calx>
 <m2pql2c0qz.fsf@firstfloor.org>
 <20110722163335.2df4f6ca@notabene.brown>
 <1311363269.14555.261.camel@calx>
 <20110722205922.GS8006@one.firstfloor.org>
 <1311369102.14555.268.camel@calx>
 <20110722214732.GW8006@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722214732.GW8006@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 11:47:32PM +0200, Andi Kleen wrote:
> On Fri, Jul 22, 2011 at 04:11:42PM -0500, Matt Mackall wrote:
> > On Fri, 2011-07-22 at 22:59 +0200, Andi Kleen wrote:
> > > > Indeed. Only usefully exists on ext4 and requires extra system calls.
> > > 
> > > Not sure what you mean?  It's in stat(2), just like the timestamps.
> > 
> > I don't see anything that looks like a version or generation number in
> > either the man pages, the asm-generic/stat.h, or glibc's asm/stat.h.
> > Pointer?
> 
> Hmm you're right. I thought it was in there, but apparently not.
> I think it should be added there though. We still have some unused 
> fields.

But last I checked I thought it was only ext4 that actually incremented
the i_version on IO, and even then only when given a (non-default) mount
option.

My notes on what needs to be done there:

	- collect data to determine whether turning on i_version causes
	  any significant performance regressions.
		- Last I talked to him, Ted Tso recommended running
		  Bonnie on a local disk, since it does a lot of little
		  writes, which is somewhat of a worst case, as it will
		  generate extra metadata updates for each write.
		  Compare total wall-clock time, number of iops, and
		  number of bytes (using some kind of block tracing).
	- If there aren't any problems, turn it on by default, and we're
	  done.  If there are unfixable problems, consider something
	  more complicated (like turning on i_version automatically when
	  someone asks for it).
	- We need to check that i_version is also doing something
	  sensible on directory as well as on file inodes.
	- We also need to think about what it does after reboots.  (E.g.
	  what is an nfs server to do if clients see the i_version go
	  backwards (and hence possible repeat old values) after a
	  reboot?)
	- Double-check the order that data updates and i_version updates
	  are done in.  (Ideal would be if they were atomic, but for
	  nfsd's purposes at least it should be adequate if the
	  i_version comes after, and no later than the next commit.)

--b.
