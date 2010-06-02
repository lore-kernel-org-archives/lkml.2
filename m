Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab0FBPVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:21:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab0FBPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:21:21 -0400
Date: Wed, 2 Jun 2010 08:16:02 -0700
From: Bill Richardson <wfrichar@chromium.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       akpm@linux-foundation.org, fweisbec@gmail.com, yinghai@kernel.org,
       pavel@ucw.cz, shane.wang@intel.com, linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, msb@chromium.org, drewry@chromium.org
Subject: [RFC] [PATCH] Allow empty e820 map if EFI map will be provided
	later.
Message-ID: <20100602151602.GA3656@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are booting an x86-based system from an EFI BIOS that does not
provide any e820-style memory maps, setup_arch() calls functions that expect
to find the e820 maps long before it calls functions to find the EFI maps.
The default behavior in arch/x86/kernel/e820.c is that if no e820 map
exists, default_machine_specific_memory_setup() adds two default regions
just in case. Later, when you get around to using the EFI maps, these
default regions interfere with the real memory map.

This patch provides a config option that allows the lack of e820 maps to be
ignored, under the assumption that you know what you're doing and will
provide a valid EFI memory map to use.

The reason this problem has not arisen before now is that under most
circumstances either the EFI BIOS' Compatibility Support Module provides an
e820-style memory map in the first place, or the EFI-aware bootloader
(grub2, elilo) translates the EFI map to the e280 format before booting the
kernel.

I'm trying to reduce the boot time and BIOS footprint, so I'm booting
without either of those pre-boot map translations. This patch allows that to
happen.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
---
 arch/x86/Kconfig            |   10 ++++++++++
 arch/x86/include/asm/e820.h |    5 +++++
 arch/x86/kernel/e820.c      |    2 +-
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..5af1da6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1468,6 +1468,16 @@ config EFI
 	  resultant kernel should continue to boot on existing non-EFI
 	  platforms.
 
+config ALLOW_EMPTY_E820
+	bool "Allow empty e820 memory maps"
+	default y
+	depends on EFI && (X86_64 || X86_32)
+	---help---
+	  Enable this if you are using EFI memory maps instead of e820.
+	  The EFI memory maps are scanned much later than the e820 maps, and
+	  without this option the e280 setup code will automatically add
+	  some default mappings that may conflict with the real EFI maps.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index ec8a52d..cbe22f9 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -134,6 +134,11 @@ extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
+#ifdef CONFIG_ALLOW_EMPTY_E820
+static inline int no_e820_map_return(void) { return 0; }
+#else
+static inline int no_e820_map_return(void) { return -1; }
+#endif
 
 /*
  * Returns true iff the specified range [s,e) is completely contained inside
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7bca3c6..b7db15c 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -416,7 +416,7 @@ static int __init append_e820_map(struct e820entry *biosmap, int nr_map)
 {
 	/* Only one memory region (or negative)? Ignore it */
 	if (nr_map < 2)
-		return -1;
+		return no_e820_map_return();
 
 	return __append_e820_map(biosmap, nr_map);
 }
-- 
1.7.0.1


-- 
Art for Art's Sake
Engineering for Money

