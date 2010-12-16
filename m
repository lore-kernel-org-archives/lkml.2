Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0LPDhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 22:37:39 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:43847 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401Ab0LPDhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 22:37:36 -0500
Date: Thu, 16 Dec 2010 14:37:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jon Nelson <jnelson@jamponi.net>, Mike Snitzer <snitzer@redhat.com>,
        Matt <jackdachef@gmail.com>, Milan Broz <mbroz@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Message-ID: <20101216033718.GM9925@dastard>
References: <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com>
 <1291747731-sup-3099@think>
 <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com>
 <1291751698-sup-9297@think>
 <AANLkTin79GzUbfuZNKyTtqcyoUSO9AJimO77_ZOvqggH@mail.gmail.com>
 <1291754340-sup-1631@think>
 <AANLkTim8uCmFK=LjkMmq_1O0KE3AiN_7g41AO0woxMv7@mail.gmail.com>
 <1291755258-sup-8760@think>
 <AANLkTi=OC9Z68U-j8s6vfU-_-6tkg5W7aUz9HEupidX9@mail.gmail.com>
 <1291810586-sup-8211@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291810586-sup-8211@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 07:20:24AM -0500, Chris Mason wrote:
> Excerpts from Jon Nelson's message of 2010-12-07 22:29:26 -0500:
> > On Tue, Dec 7, 2010 at 3:02 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > > Excerpts from Jon Nelson's message of 2010-12-07 15:48:58 -0500:
> > >> On Tue, Dec 7, 2010 at 2:41 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > >> > Excerpts from Jon Nelson's message of 2010-12-07 15:25:47 -0500:
> > >> >> On Tue, Dec 7, 2010 at 2:02 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > >> >> > Excerpts from Jon Nelson's message of 2010-12-07 14:34:40 -0500:
> > >> >> >> On Tue, Dec 7, 2010 at 12:52 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > >> >> >> >> postgresql errors. Typically, header corruption but from the limited
> > >> >> >> >> visibility I've had into this via strace, what I see is zeroed pages
> > >> >> >> >> where there shouldn't be.
> > >> >> >> >
> > >> >> >> > This sounds a lot like a bug higher up than dm-crypt.  Zeros tend to
> > >> >> >> > come from some piece of code explicitly filling a page with zeros, and
> > >> >> >> > that often happens in the corner cases for O_DIRECT and a few other
> > >> >> >> > places in the filesystem.
> > >> >> >> >
> > >> >> >> > Have you tried triggering this with a regular block device?
> > >> >> >>
> > >> >> >> I just tried the whole set of tests, but with /dev/sdb directly (as
> > >> >> >> ext4) without any crypt-y bits.
> > >> >> >> It takes more iterations but out of 6 tests I had one failure: same
> > >> >> >> type of thing, 'invalid page header in block ....'.
> > >> >> >>
> > >> >> >> I can't guarantee that it is a full-page of zeroes, just what I saw
> > >> >> >> from the (limited) stracing I did.
> > >> >> >
> > >> >> > Fantastic. Now for our usual suspects:
> > 
> > Maybe not so fantastic. I kept testing and had no more failures. At
> > all. After 40+ iterations I gave up.
> > I went back to trying ext4 on a LUKS volume. The 'hit' ratio went to
> > something like 1 in 3, or better.
> > 
> > I will continue to do testing with and without LUKS. I did /not/
> > reboot between tests, but I do start with a fresh postgres database.
> > 
> 
> Once we trigger once without dm-crypt, dm-crypt is off the hook.  Just
> to verify, when you say without luks, you mean without any crypto bits
> in use at all on the filesystems postgres uses?
> 
> Usually the trick to reproducing filesystem corruptions is adding memory
> pressure.  The corruption is probably a bad interaction between reads
> and writes, and we need to make sure the reads actually happen.
> 
> http://oss.oracle.com/~mason/pin_ram.c
> 
> gcc -Wall -o pin_ram pin_ram.c
> 
> pin_ram -m 80%-of-your-ram-in-mb

Implemented in xfstests about 10 years ago:

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=blob;f=src/usemem.c;h=b8794a6b209cebf8dbf312a8ef131e2e54b18d29;hb=HEAD

:P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
