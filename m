Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0LYMON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 07:14:13 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:50242 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751295Ab0LYMOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 07:14:10 -0500
Date: Sat, 25 Dec 2010 13:14:07 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Rogier Wolff <R.E.Wolff@BitWizard.nl>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101225121407.GA2116@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <m3aajvz5na.fsf@intrepid.localdomain> <4D14BB36.1030304@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D14BB36.1030304@msgid.tls.msk.ru>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 06:24:38PM +0300, Michael Tokarev wrote:
> 24.12.2010 16:01, Krzysztof Halasa wrote:
> > Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
> > 
> >> ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> >> scsi 5:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Y 80.0 PQ: 0 ANSI: 5
> >> sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931
> >> GiB)
> > 
> > WD10EARS are "green" drives, 5400 rpm. They aren't designed exactly for
> > speed. Never used them, though.
> 
> Oh..  The famous EARS drives.  I missed this info in the
> start of the thread.
> 
> Now, after this info, the whole thread is quite moot.

No it is not. 

We're seeing a performance issue, about 10 fold beyond what is to be
expected of unaligned accesses.
 
> The thing is, for these WD*EARS drivers, it is _vital_ to get
> proper alignment of all partitions and operations.  They've
> 4Kb sectors physically but report 512bytes sectors to the OS.
> It is _essential_ to ensure all partitions are aligned to the
> 4Kb sectors.  Be it LVM, raid-something, etc - each filesystem
> must start at a 4kb boundary at least, or else you'll see
> _dramatic_ write speed problems.

Out of four partitions on the drive, two are aligned, two are not. 

The two that are not are the boot partition (/boot) which never gets
written to. The other one is the swap partition. (the machine has
enough ram to function perfectly without swap. We only noticed a
missing "mkswap" on the swap partition after it had been running
without swap for weeks, while we were diagnosing the performance
problems. So, apart from the fact that this was "lucky" to come out
this way, it /is/ correctly configured.

> So.. check the whole storage stack and ensure proper alignment
> everywhere.  In particular, check that your partitions are not
> aligned to 63 sectors (512b), or starts at N+1 sector - the
> most problematic mode for these drives.

The important (used ones) ARE correctly aligned. (I surely hope that
RAID5 doesn't grab the first 1k and alings everything else to (4n +
1)k ...)

> No, this is about TLER.  The "desktop" drives like this will try
> re-read data in case of error, and if that does not work the
> raid code will most likely declare the drive's dead and kick
> it off the array.  Drives which are supposed to work in RAID
> config has configurable timeouts/retries, so that the RAID
> code will be able to take care of read errors.

That's WDs story. Under Linux the driver will timeout after some
thirty seconds, reset the drive and retry a few times (again
triggering the long retries sequence, but not letting it finish), and
finally report an error. When an error is reported Linux-raid will
kick the drive out of the array and work in degraded mode from then
on.

If you'd use a RAID drive that DOES report error quickly, you'll be on
your way maybe 113 seconds quicker, but still with a degraded array.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
