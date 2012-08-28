Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2H1Ah3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 20:37:29 -0400
Received: from relay00.pair.com ([209.68.5.9]:1642 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755104Ab2H1Ah0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 20:37:26 -0400
X-pair-Authenticated: 108.45.119.98
Message-ID: <503C1133.7000506@flaterco.com>
Date: Mon, 27 Aug 2012 20:30:43 -0400
From: David Flater <vger@flaterco.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alsa Devel <alsa-devel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sound: fix emu8000 DRAM sized 512 KiB too small
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] sound: fix emu8000 DRAM sized 512 KiB too small

Applicable to 3.5.3 mainline.

In emu8000.c, size_dram determines the amount of memory on the sound card by
doing write/readback tests starting at 512 KiB and incrementing by 512 KiB.
On success, detected_size is updated to the successful address and testing
continues.  On failure, the loop is immediately exited.  The resulting
detected_size is 512 KiB too small except in two special cases:

1. If there is no memory, the initial 0 value of detected_size is used, which
   is correct.
2. If the address space wraps around, detected_size is updated before the
   bailout, so the result is correct.

The patch corrects all cases and was tested with an AWE64 Gold.  Before:
  EMU8000 [0x620]: 3584 Kb on-board memory detected
  asfxload 4GMGSMT.SF2 (4174814 B) fails.
After:
  EMU8000 [0x620]: 4096 Kb on-board memory detected
  asfxload 4GMGSMT.SF2 succeeds.

C.f. Bug 46451 https://bugzilla.kernel.org/show_bug.cgi?id=46451

Signed-off-by: David Flater <dave@flaterco.com>
---

Note:  I am having newbie problems with git, so I am unable to determine
easily whether this was a regression or a primordial bug.
git clone http://pub/scm/linux/kernel/git/torvalds/linux.git gitkernel
Cloning into gitkernel...
warning: remote HEAD refers to nonexistent ref, unable to checkout.

--- linux-3.5.2/sound/isa/sb/emu8000.c~	2012-08-15 10:55:25.000000000 -0400
+++ linux-3.5.2/sound/isa/sb/emu8000.c	2012-08-25 20:22:00.482446406 -0400
@@ -417,9 +417,6 @@ size_dram(struct snd_emu8000 *emu)
 		EMU8000_SMLD_READ(emu); /* discard stale data  */
 		if (EMU8000_SMLD_READ(emu) != UNIQUE_ID2)
 			break; /* no memory at this address */
-
-		detected_size = size;
-
 		snd_emu8000_read_wait(emu);
 
 		/*
@@ -432,6 +429,9 @@ size_dram(struct snd_emu8000 *emu)
 		if (EMU8000_SMLD_READ(emu) != UNIQUE_ID1)
 			break; /* we must have wrapped around */
 		snd_emu8000_read_wait(emu);
+
+		/* Otherwise, it's valid memory. */
+		detected_size = size + 512 * 1024;
 	}
 
 	/* wait until FULL bit in SMAxW register is false */
