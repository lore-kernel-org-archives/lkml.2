Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1C3PGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:06:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57012 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1C3PGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:06:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
Date: Wed, 30 Mar 2011 17:06:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Lukas Czerner <lczerner@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de> <AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
In-Reply-To: <AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301706.36214.arnd@arndb.de>
X-Provags-ID: V02:K0:nON3kGPGYBZIoz1E2XukGTVBy+xBwcMbyZdxNN5pTjR
 /hjRsyF9WRA7fKflOE2qNrKY7iB64p244tmYFU3ghm71Vpgbs+
 mwPkmHfP6to2jy+mCy2eeh878k+4m6H3CFtF3+oHNitwoIEPoc
 j0pKrxL8MR6+quMUBvXVCHirpEjNgHcFChxGt8YW9bd9J7uPLl
 7apxtcTfEyc9VpO/ML6Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Kyungmin Park wrote:
> On Wed, Mar 30, 2011 at 11:20 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > If you just pass the minimum length, the file system could end up
> >> > erasing a 4 MB section that spans two half erase blocks, or it
> >> > could span a few clusters of the following erase block, both of
> >> > which is not desirable from a performance point of view.
> >>
> >> Does those cards export such information correctly ?
> >
> > Most of the time, they export the erase block size correctly, but
> > sometimes they lie. In fact, all of the cards I've seen report
> > 4 MB erase blocks, but some cards in fact use 1.5 MB, 2 MB or 8 MB
> > instead. I'm sure we will see 3 MB, 6 MB, 12 MB and 16 MB soon.
> >
> > SD cards do not export the page size, but most of them today use
> > 16 KB. See my list at
> >
> > https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey
> 
> Thank you for your effort. but think it the original purpose of
> batched discard feature.
> Do you want to run the batched discard for SD card. I mean usually in
> our environment SD card is optional.
> and my goal is used for eMMC. and you know, eMMC and SD card internal
> algorithm is different.

I've done only a few measurements on eMMC, but for all I know, they
use the same fundamental principles, just with a slightly different
command set and physical interface. A number of manufacturers advertise
controller chips that can be integrated on either MMC or SD packages,
presumably using a different firmware.

> The goal of SD card is performance but eMMC is different. it should
> consider the reliability also. e.g., Sudden Power Off Recovery.

I would have guessed the opposite, that sudden power off is much
more important on SD cards that can simply be removed while writing.

In practice, I would expect very little effort getting put into
reliability on either of the two.

Note that there was a patch on the mmc mailing list very recently
to support the reliable write mode of eMMC.

Also, when you want reliablility, you probably shouldn't use the
FAT file system, since it lacks transactional writes. If you target
eMMC media, there is usually no advantage in using FAT because the
data does not get accessed by other operating systems.

> > Good SSDs can deal with remapping 4k blocks, while cheap ones
> > (SD cards, USB sticks, or low-end ATA SSDs) can only do operations
> > on full blocks.
> It really depends on devices. To increase the performance we have to
> increase the channel and the way unit at internally.
> Most NAND devices are similar there's no way except increase the
> interleaving unit. and it affects the price.
> 
> That's reason I like the batched discard. it's not easy to guess the
> erase block at system level. so it's helpful scan the unused blocks
> and try to trim at once.

I'm absolutely in favor of batched discard, I just think we should
apply some stricter rules to what blocks can get batched.

> Please remember that the discard is just hint. If we write the flash
> sequentially then we maybe don't need to trim it.

With the current trends in NAND technology, the number of erase cycles
keep going down, so I'd assume that we increasingly rely on discard
in order to keep the wear levelling working, at least for the media
that only do dynamic wear levelling. When you have a drive that supports
static wear levelling, discard becomes more a performance optimization
than a reliability requirement.

	Arnd
