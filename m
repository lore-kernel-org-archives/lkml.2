Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1C1Pwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:52:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43681 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1C1Pws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WD+XS6oh7WaJZQHgHe0V3v0zjMqKr/fEZwieHlznnzPfny8mBkkgSqroOSm7AKH6mZ
         IDEvbwFMenXPGThR+xiKtKruKexaVGeNYmgS+xyRSJzdClGW0VAPDCD8KazFFB1gnpNz
         TP9pxEDxbw+1naoP0T8jUz7N/d0TQiptocfIk=
MIME-Version: 1.0
Date: Mon, 28 Mar 2011 17:52:47 +0200
Message-ID: <AANLkTin17=rCU4eDGYtnVFZ1ffbUn+var4Q_AQUuGKaw@mail.gmail.com>
Subject: Linux 2.6.38 freeze because of sound/core/pcm_lib.c commit 59ff878ffb26bc0be812ca8295799164f413ae88
From: "Christopher K." <c.krooss@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Kernel 2.6.38 has been freezing ever since rc1 on my asus p7p55d.
After booting up, the kernel seems to use a lot of cpu-time and after
20-30 seconds
the system comes to a complete halt.

I just finished bisecting 2.6.37 - 2.6.38-rc1 and found this commit to
be responsible:

59ff878ffb26bc0be812ca8295799164f413ae88

I attached a patch that reverts this commit, although I don't quite
understand how
it could cause a complete system-lockup. A friend of mine owns exactly the same
motherboard, cpu and ram as me but is not affected.

I noticed this in my logs, but I don't think it's related:

WARNING: at drivers/pci/dmar.c:634 warn_invalid_dmar+0x8a/0xa0()
Hardware name: System Product Name
Your BIOS is broken; DMAR reported at address fed90000 returns all ones!
BIOS vendor: American Megatrends Inc.; Ver: 2003   ; Product Version:
System Version
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.38.2-ARCH #1
Call Trace:
 [<ffffffff8105c07a>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff81627c47>] ? __early_set_fixmap+0x96/0x9d
 [<ffffffff8105c10a>] ? warn_slowpath_fmt_taint+0x3a/0x40
 [<ffffffff81627c47>] ? __early_set_fixmap+0x96/0x9d
 [<ffffffff812337ea>] ? warn_invalid_dmar+0x8a/0xa0
 [<ffffffff81628143>] ? early_iounmap+0xf4/0x13d
 [<ffffffff8163d2b7>] ? check_zero_address+0xd4/0x116
 [<ffffffff81276bad>] ? acpi_get_table_with_size+0x53/0xb4
 [<ffffffff813bb55a>] ? _etext+0x0/0x256aa6
 [<ffffffff8163d310>] ? detect_intel_iommu+0x17/0x84
 [<ffffffff81619865>] ? pci_iommu_alloc+0x47/0x72
 [<ffffffff81627a7c>] ? mem_init+0x19/0xec
 [<ffffffff81612ace>] ? start_kernel+0x203/0x40d
 [<ffffffff81612347>] ? x86_64_start_reservations+0x132/0x136
 [<ffffffff8161244c>] ? x86_64_start_kernel+0x101/0x110
---[ end trace a7919e7f17c0a725 ]---


I'd be glad to help debug this.
Hope I'm not doing anything wrong, this is my first time posting to lkml.

Regards
Chris

--- a/sound/core/pcm_lib.c	2011-03-27 20:37:20.000000000 +0200
+++ b/sound/core/pcm_lib.c	2011-03-28 17:14:26.000000000 +0200
@@ -374,25 +374,8 @@
 			   (unsigned long)runtime->hw_ptr_base);
 	}

-	if (runtime->no_period_wakeup) {
-		/*
-		 * Without regular period interrupts, we have to check
-		 * the elapsed time to detect xruns.
-		 */
-		jdelta = jiffies - runtime->hw_ptr_jiffies;
-		if (jdelta < runtime->hw_ptr_buffer_jiffies / 2)
-			goto no_delta_check;
-		hdelta = jdelta - delta * HZ / runtime->rate;
-		while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
-			delta += runtime->buffer_size;
-			hw_base += runtime->buffer_size;
-			if (hw_base >= runtime->boundary)
-				hw_base = 0;
-			new_hw_ptr = hw_base + pos;
-			hdelta -= runtime->hw_ptr_buffer_jiffies;
-		}
+	if (runtime->no_period_wakeup)
 		goto no_delta_check;
-	}

 	/* something must be really wrong */
 	if (delta >= runtime->buffer_size + runtime->period_size) {
