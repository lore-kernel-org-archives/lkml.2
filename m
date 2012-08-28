Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab2H1CZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 22:25:25 -0400
Received: from relay03.pair.com ([209.68.5.17]:4564 "HELO relay03.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751312Ab2H1CZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 22:25:24 -0400
X-pair-Authenticated: 108.45.119.98
Message-ID: <503C2C11.8020202@flaterco.com>
Date: Mon, 27 Aug 2012 22:25:21 -0400
From: David Flater <vger@flaterco.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alsa Devel <alsa-devel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] sound: fix emu8000 DRAM sized 512 KiB too small
References: <503C1133.7000506@flaterco.com>
In-Reply-To: <503C1133.7000506@flaterco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:  Fixed result still wrong in the case of 512 KiB DRAM.  Oops.

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

I do not have a card with 512 KiB to test with, but by forcibly enabling the
added conditional I verified on the AWE64 Gold that it detects 512 KiB
(successfully reading from the first memory location) and does not hang the
card.

C.f. Bug 46451 https://bugzilla.kernel.org/show_bug.cgi?id=46451

Signed-off-by: David Flater <dave@flaterco.com>
---

--- linux-3.5.3-nameless/sound/isa/sb/emu8000.c.orig	2012-08-25 22:32:13.000000000 -0400
+++ linux-3.5.3-nameless/sound/isa/sb/emu8000.c	2012-08-27 22:06:15.729510037 -0400
@@ -417,9 +417,6 @@ size_dram(struct snd_emu8000 *emu)
 		EMU8000_SMLD_READ(emu); /* discard stale data  */
 		if (EMU8000_SMLD_READ(emu) != UNIQUE_ID2)
 			break; /* no memory at this address */
-
-		detected_size = size;
-
 		snd_emu8000_read_wait(emu);
 
 		/*
@@ -432,6 +429,18 @@ size_dram(struct snd_emu8000 *emu)
 		if (EMU8000_SMLD_READ(emu) != UNIQUE_ID1)
 			break; /* we must have wrapped around */
 		snd_emu8000_read_wait(emu);
+
+		/* Otherwise, it's valid memory. */
+		detected_size = size + 512 * 1024;
+	}
+
+	/* Distinguish 512 KiB from 0. */
+	if (detected_size == 0) {
+		snd_emu8000_read_wait(emu);
+		EMU8000_SMALR_WRITE(emu, EMU8000_DRAM_OFFSET);
+		EMU8000_SMLD_READ(emu); /* discard stale data  */
+		if (EMU8000_SMLD_READ(emu) == UNIQUE_ID1)
+			detected_size = 512 * 1024;
 	}
 
 	/* wait until FULL bit in SMAxW register is false */

