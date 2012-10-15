Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2JOXNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:13:10 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35605 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab2JOXNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:13:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQmAL2XfFB5LH33/2dsb2JhbABFuh+EbQKBBIEJgiABAQQBOhwjBQsIAw4KLhQlAyETh34Fq2OQUBSLRYFng3ZgA5VrkDGDAQ
Date: Tue, 16 Oct 2012 10:13:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Juliusz Chroboczek <jch@pps.jussieu.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Write is not atomic?
Message-ID: <20121015231302.GF2739@dastard>
References: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 11:36:15PM +0200, Juliusz Chroboczek wrote:
> Hi,
> 
> The Linux manual page for write(2) says:
> 
>     The adjustment of the file offset and the write operation are
>     performed as an atomic step.

That's wrong. The file offset update is not synchronised at all with
the write, and for a shared fd the update will race.


> This is apparently an extension to POSIX, which says
> 
>     This volume of IEEE Std 1003.1-2001 does not specify behavior of
>     concurrent writes to a file from multiple processes. Applications
>     should use some form of concurrency control.

This is how Linux behaves.

> The following fragment of code
> 
>     int fd;
>     fd = open("exemple", O_CREAT | O_WRONLY | O_TRUNC, 0666);
>     fork();
>     write(fd, "Ouille", 6);
>     close(fd);
> 
> produces "OuilleOuille", as expected, on ext4 on two machines running
> Linux 3.2 AMD64.  However, over XFS on an old Pentium III at 500 MHz
> running 2.6.32, it produces just "Ouille" roughly once in three times.

ext4, on 3.6:

$ for i in `seq 0 10000`; do ./a.out ; cat /mnt/scratch/foo ; echo ; done | sort |uniq -c
     39 Ouille
   9962 OuilleOuille
$

XFS, on the same kernel, hardware and block device:

$ for i in `seq 0 10000`; do ./a.out ; cat /mnt/scratch/foo ; echo ; done | sort |uniq -c
     40 Ouille
   9961 OuilleOuille
$

So both filesystems behave according to the POSIX definition of
concurrent writes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
