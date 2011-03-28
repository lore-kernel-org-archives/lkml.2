Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1C1Uua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:50:30 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32932 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab1C1Uu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:50:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkEACnzkE15LK5JgWdsb2JhbAClQRUBARYmJcUkDYVcBJJ1
Date: Tue, 29 Mar 2011 07:50:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.38.1: CPU#0 stuck for 67s! / xfs_ail_splice
Message-ID: <20110328205024.GB3008@dastard>
References: <alpine.DEB.2.02.1103260927500.21571@p34.internal.lan>
 <20110327232543.GU26611@dastard>
 <alpine.DEB.2.02.1103280406300.25113@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1103280406300.25113@p34.internal.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 04:10:11AM -0400, Justin Piszcz wrote:
> 
> 
> On Mon, 28 Mar 2011, Dave Chinner wrote:
> 
> >On Sat, Mar 26, 2011 at 09:29:36AM -0400, Justin Piszcz wrote:
> >>Hi,
> >>
> >>When I rm -rf a directory of a few hundred thousand
> >>files/directories on XFS under 2.6.38.1, I see the following, is
> >>this normal?
> >
> >No. What is you filesystem config (xfs_info) and your mount options?
> >Is it repeatable? I? the system otherwise stalled or is it still
> >operating normally? Does it recover and work normally after such a
> >stall?
> 
> Hi Dave, default mkfs.xfs options:
> 
> >What is you filesystem config (xfs_info) and your mount options?
> 
> # xfs_info /dev/sda1
> meta-data=/dev/sda1              isize=256    agcount=44, agsize=268435455 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=11718704640, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

A 44TB filesystem with a 2GB log, right?

> /dev/sda1 on /r1 type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144,delaylog,inode64)
> 
> >Is it repeatable?
> I've not tried to repeat it as is spews messages over all of my consoles but
> it has happened more than once.

OK.

> >the system otherwise stalled or is it still operating normally?
> The console/xterm/ssh etc that is performing the removal does lockup but
> you are able to access the machine via a separate ssh connection.
> 
> >Does it recover and work normally after such a stall?
> Yes, eventually, I believe I started seeing this problem when I added
> 'delaylog' option to the mount options..

OK, that is what I suspected.

What it sounds like is that there is a checkpoint completing with an
out-of-order log sequence number so the items in the checkpoint are
not being inserted at the end of the AIL and that is where the CPU
usage is coming from. Without delaylog, a single transaction being
inserted out-of-order is unnoticeable as it's only a few items. A
delaylog checkpoint can be tens of thousands of items which is where
the CPU usage would come from.

I'll have to reproduce this locally to confirm this theory (and test
the fix).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
