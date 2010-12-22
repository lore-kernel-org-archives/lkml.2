Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0LVWoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:44:19 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:39684 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751850Ab0LVWoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:44:17 -0500
Date: Wed, 22 Dec 2010 23:44:16 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101222224416.GE30941@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 11:27:20AM -0500, Jeff Moyer wrote:
> Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
> 
> > Unquoted text below is from either me or from my friend. 
> >
> >
> > Someone suggested we try an older kernel as if kernel 2.6.32 would not
> > have this problem. We do NOT think it suddenly started with a certain
> > kernel version. I was just hoping to have you kernel-guys help with
> > prodding the kernel into revealing which component was screwing things
> > up....
> [...]
> > ata3.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
> 
> This is an "Advanced format" drive, which, in this case, means it
> internally has a 4KB sector size and exports a 512byte logical sector
> size.  If your partitions are misaligned, this can cause performance
> problems.

This would mean that for a misalgned write, the drive would have to
read-modify-write every super-sector. 

In my performance calculations, 10ms average seek (should be around
7), 4ms average rotational latency for a total of 14ms. This would
degrade for read-modify-write to 10+4+8 = 22ms. Still 10 times better
than what we observe: service times on the order of 200-300ms. 

 > md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
> >       39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
> > [UUU]
> 
> A 512KB raid5 chunk with 4KB I/Os?  That is a recipe for inefficiency.
> Again, blktrace data would be helpful.

Where did you get the 4kb IOs from? You mean from the iostat -x
output?  The system/filesystem decided to do those small IOs. With the
throughput we're getting on the filesystem, it better not try to write
larger chuncks...

I have benchmarked my own "high bandwidth" raid arrays. I benchmarked
them with 128k, 256, 512 and 1024k blocksize. I got the best
throughput (for my benchmark: dd if=/dev/md0 of=/dev/null bs=1024k)
with 512k blocksize. (and yes that IS a valid benchmark for my
usage of the array.)

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
