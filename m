Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab2EPMaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:30:15 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:52278 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab2EPMaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:30:05 -0400
Message-Id: <4FB3B9E4020000A100009C72@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 16 May 2012 14:29:56 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Q: enterprise-readiness of MD-RAID (md: kicking non-fresh
 dm-14 from array!)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm using disk mirroring with HP-UX and LVM in an enterprise environment for about 20 years. Not loo long ago I started to use disk mirroring with Linux and MD-RAID.

Unfortunately I found a lot of bugs (e.g. mdadm being unable to setup the correct bitmaps) and inefficiencies. Recently I found out that some of our RAID1 are not mirrored any more, and even during boot the kernel does not even try to resynchronize them.

The message reads to me like "I found out that one of the disks has obsolete data on it; let's throw it out from the RAID". Naturally my expectations were that the kernel would resynchronize the stale disk blocks.

<6>[   15.248125] md: md0 stopped. 
<6>[   15.249075] md: bind<dm-14> 
<6>[   15.249290] md: bind<dm-16> 
<4>[   15.249409] md: kicking non-fresh dm-14 from array! 
<6>[   15.249525] md: unbind<dm-14> 
<6>[   15.293560] md: export_rdev(dm-14) 
<6>[   15.296317] md: raid1 personality registered for level 1 
<6>[   15.296814] raid1: raid set md0 active with 1 out of 2 mirrors 
<6>[   15.325348] md0: bitmap initialized from disk: read 8/8 pages, set 97446 bits 
<6>[   15.325461] created bitmap (126 pages) for device md0 
<6>[   15.325781] md0: detected capacity change from 0 to 537944588288 

On another occasion we had the case that after a hard reset (from cluster) one of our biggest RAIDs (several hundred GB) was resynchronized fully, even though it had a bitmap. After a little reading I got the impression that MD-RAID1 always copies disk0 to disk1 if there are mismatches. My expectation was that the more recent disk would be copied to the outdated disk. Note that even if writes to both disks are issued to the queues simultaneously, it's not clear (especially with SAN storage and after a reset situation) which of the disks got the write done first.

My latest experience was with SLES11 SP1 which may not have the latest code bits.

If anybody wants to share his/her wisdom on that (the enterpris-readyness of MD-RAID, please reply to the CC: also as I'm not subscribed to the kernel list.

BTW: I had made some performance comparisons between our SAN storage ("hardware") and MD-RAID ("software") regarding RAID levels:

hardware seq. read:  RAID0=100%, RAID1=67%, RAID5=71%, RAID6=72%
hardware seq. write: RAID0=100%, RAID1=67%, RAID5=64%, RAID6=42%

software seq. read:  RAID0=100%, RAID1=44%, RAID5=36%, RAID6=not done
software seq. write: RAID0=100%, RAID1=48%, RAID5=19%, RAID6=not done

Note: I was using two independent SAN storage units for the RAID1 tests; for the higher levels I had to reuse one of those SAN storage units.

Measuring LVM overhead I found a penalty of 27% when reading, but a 48% boot for writing. I never quite understood ;-)
Comparing I/O schedulers "cfq" with "noop", I found that the latter improved throughput from about 10% to 25%.

Now if you combine "cfq", MD-RAID5 and LVM, you'll see that Linux is very effective when taking your performance away ;-)
DISCLAIMER: This was not meant to be a representative performance test, just a test to fulfill my personal information needs.

Thank you,
Ulrich


