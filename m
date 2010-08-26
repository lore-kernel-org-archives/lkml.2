Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0HZAOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:14:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:57081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab0HZAOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:14:19 -0400
Date: Thu, 26 Aug 2010 00:12:46 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-d0cd7425fab774a480cce17c2f649984312d0b55@git.kernel.org>
References: <tip-d0cd7425fab774a480cce17c2f649984312d0b55@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bios] x86, bios: Make the x86 early memory reservation a kernel option
Message-ID: <tip-9ea77bdb39b62c9bf9fd3cdd1c25a9420bccd380@git.kernel.org>
Git-Commit-ID: 9ea77bdb39b62c9bf9fd3cdd1c25a9420bccd380
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 00:12:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ea77bdb39b62c9bf9fd3cdd1c25a9420bccd380
Gitweb:     http://git.kernel.org/tip/9ea77bdb39b62c9bf9fd3cdd1c25a9420bccd380
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 25 Aug 2010 16:38:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 25 Aug 2010 17:10:49 -0700

x86, bios: Make the x86 early memory reservation a kernel option

Add a kernel command-line option so the x86 early memory reservation
size can be adjusted at runtime instead of only at compile time.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <tip-d0cd7425fab774a480cce17c2f649984312d0b55@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 arch/x86/Kconfig                    |    2 +-
 arch/x86/kernel/setup.c             |   28 ++++++++++++++++++++++++++--
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2c85c06..41ce93e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2150,6 +2150,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			Reserves a hole at the top of the kernel virtual
 			address space.
 
+	reservelow=	[X86]
+			Format: nn[K]
+			Set the amount of memory to reserve for BIOS at
+			the bottom of the address space.
+
 	reset_devices	[KNL] Force drivers to reset the underlying device
 			during initialization.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 683ae8f..d359000 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1326,7 +1326,7 @@ config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
 	  Set whether the default state of memory_corruption_check is
 	  on or off.
 
-config X86_LOW_RESERVE
+config X86_RESERVE_LOW
 	int "Amount of low memory, in kilobytes, to reserve for the BIOS"
 	default 64
 	range 4 640
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index eb87f1c..af277e3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -618,6 +618,8 @@ static __init void reserve_ibft_region(void)
 		reserve_early_overlap_ok(addr, addr + size, "ibft");
 }
 
+static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
+
 static void __init trim_bios_range(void)
 {
 	/*
@@ -627,9 +629,9 @@ static void __init trim_bios_range(void)
 	 *
 	 * This typically reserves additional memory (64KiB by default)
 	 * since some BIOSes are known to corrupt low memory.  See the
-	 * Kconfig help text for X86_LOW_RESERVE.
+	 * Kconfig help text for X86_RESERVE_LOW.
 	 */
-	e820_update_range(0, ALIGN(CONFIG_X86_LOW_RESERVE << 10, PAGE_SIZE),
+	e820_update_range(0, ALIGN(reserve_low, PAGE_SIZE),
 			  E820_RAM, E820_RESERVED);
 
 	/*
@@ -641,6 +643,28 @@ static void __init trim_bios_range(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
+static int __init parse_reservelow(char *p)
+{
+	unsigned long long size;
+
+	if (!p)
+		return -EINVAL;
+
+	size = memparse(p, &p);
+
+	if (size < 4096)
+		size = 4096;
+
+	if (size > 640*1024)
+		size = 640*1024;
+
+	reserve_low = size;
+
+	return 0;
+}
+
+early_param("reservelow", parse_reservelow);
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
