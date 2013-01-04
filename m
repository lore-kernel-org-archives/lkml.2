Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3ADAuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:50:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30490 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3ADAuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:50:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Rob Landley <rob@landley.net>, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v7u1 23/31] x86, boot: update comments about entries for 64bit image
Date: Thu,  3 Jan 2013 16:48:43 -0800
Message-Id: <1357260531-11115-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now 64bit entry is fixed on 0x200, can not be changed anymore.

Update the comments to reflect that.

Also put info about it in boot.txt

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/x86/boot.txt         |   38 ++++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/head_64.S |   22 ++++++++++++---------
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 18ca9fb..24cc542 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -1042,6 +1042,44 @@ must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
 must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
 address of the struct boot_params; %ebp, %edi and %ebx must be zero.
 
+**** 64-bit BOOT PROTOCOL
+
+For machine with 64bit cpus and 64bit kernel, we could use 64bit bootloader
+We need a 64-bit boot protocol.
+
+In 64-bit boot protocol, the first step in loading a Linux kernel
+should be to setup the boot parameters (struct boot_params,
+traditionally known as "zero page"). The memory for struct boot_params
+should be allocated under or above 4G and initialized to all zero.
+Then the setup header from offset 0x01f1 of kernel image on should be
+loaded into struct boot_params and examined. The end of setup header
+can be calculated as follow:
+
+	0x0202 + byte value at offset 0x0201
+
+In addition to read/modify/write the setup header of the struct
+boot_params as that of 16-bit boot protocol, the boot loader should
+also fill the additional fields of the struct boot_params as that
+described in zero-page.txt.
+
+After setting up the struct boot_params, the boot loader can load the
+64-bit kernel in the same way as that of 16-bit boot protocol, but
+kernel could be above 4G.
+
+In 64-bit boot protocol, the kernel is started by jumping to the
+64-bit kernel entry point, which is the start address of loaded
+64-bit kernel plus 0x200.
+
+At entry, the CPU must be in 64-bit mode with paging enabled.
+The range with setup_header.init_size from start address of loaded
+kernel and zero page and command line buffer get ident mapping;
+a GDT must be loaded with the descriptors for selectors
+__BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
+segment; __BOOT_CS must have execute/read permission, and __BOOT_DS
+must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
+must be __BOOT_DS; interrupt must be disabled; %rsi must hold the base
+address of the struct boot_params.
+
 **** EFI HANDOVER PROTOCOL
 
 This protocol allows boot loaders to defer initialisation to the EFI
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 5c80b94..aaafd4e 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -37,6 +37,12 @@
 	__HEAD
 	.code32
 ENTRY(startup_32)
+	/*
+	 * 32bit entry is 0, could not be changed!
+	 * If we come here directly from a bootloader,
+	 * kernel(text+data+bss+brk) ramdisk, zero_page, command line
+	 * all need to be under 4G limit.
+	 */
 	cld
 	/*
 	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
@@ -182,20 +188,18 @@ ENTRY(startup_32)
 	lret
 ENDPROC(startup_32)
 
-	/*
-	 * Be careful here startup_64 needs to be at a predictable
-	 * address so I can export it in an ELF header.  Bootloaders
-	 * should look at the ELF header to find this address, as
-	 * it may change in the future.
-	 */
 	.code64
 	.org 0x200
 ENTRY(startup_64)
 	/*
+	 * 64bit entry is 0x200, could not be changed!
 	 * We come here either from startup_32 or directly from a
-	 * 64bit bootloader.  If we come here from a bootloader we depend on
-	 * an identity mapped page table being provied that maps our
-	 * entire text+data+bss and hopefully all of memory.
+	 * 64bit bootloader.
+	 * If we come here from a bootloader, kernel(text+data+bss+brk),
+	 * ramdisk, zero_page, command line could be above 4G.
+	 * We depend on an identity mapped page table being provided
+	 * that maps our entire kernel(text+data+bss+brk), zero page
+	 * and command line.
 	 */
 #ifdef CONFIG_EFI_STUB
 	/*
-- 
1.7.10.4

