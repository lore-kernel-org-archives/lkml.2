Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0C3CIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 22:08:51 -0400
Received: from ozlabs.org ([203.10.76.45]:42769 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0C3CIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 22:08:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH RFC] e820_remove_range fail?
Date: Tue, 30 Mar 2010 12:38:42 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301238.43620.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

   I just wrote this patch for lguest, but I think the real problem is
that e820_remove_range can't split a range.  Is this a problem for
real machines?

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  LGUEST: 0000000000000000 - 0000000004000000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI not present or invalid.
[    0.000000] last_pfn = 0x3fa0 max_arch_pfn = 0x100000
[    0.000000] init_memory_mapping: 0000000000000000-0000000003fa0000

Thanks,
Rusty.
===
lguest: handle trimming of our e820 map

Lguest doesn't need to reserve space for the BIOS, but in commit
1b5576e69a5f Yinghai added trim_bios_range which mangles our e820 map.
But e820_remove_range does not handle removing a range from the middle
of a region correctly, so we end up with a bad max_pfn value.

The result is we can't find our (lguest-specific) device table which
we expect above the top of RAM, and fail to find the root device.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1135,12 +1135,15 @@ static struct notifier_block paniced = {
 static __init char *lguest_memory_setup(void)
 {
 	/*
-	 *The Linux bootloader header contains an "e820" memory map: the
+	 * The Linux bootloader header contains an "e820" memory map: the
 	 * Launcher populated the first entry with our memory limit.
+	 *
+	 * We have to skip the traditional BIOS area here, otherwise the
+	 * kernel messes up our map trying to "fix" it in trim_bios_range.
 	 */
-	e820_add_region(boot_params.e820_map[0].addr,
-			  boot_params.e820_map[0].size,
-			  boot_params.e820_map[0].type);
+	e820_add_region(0, BIOS_BEGIN, boot_params.e820_map[0].type);
+	e820_add_region(BIOS_END, boot_params.e820_map[0].size - BIOS_END,
+			boot_params.e820_map[0].type);
 
 	/* This string is for the boot messages. */
 	return "LGUEST";
