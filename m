Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1BVW0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:26:20 -0500
Received: from kroah.org ([198.145.64.141]:32971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab1BVWWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:42 2011
Message-Id: <20110222221842.623602186@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [56/70] ARM: Keep exit text/data around for SMP_ON_UP
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit a9ad21fed09cb95d34af9474be0831525b30c4c6 upstream.

When SMP_ON_UP is used and the spinlocks are inlined, we end up with
inline spinlocks in the exit code, with references from the SMP
alternatives section to the exit sections.  This causes link time
errors.  Avoid this by placing the exit sections in the init-discarded
region.

Tested-by: Dave Martin <dave.martin@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/vmlinux.lds.S |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -21,6 +21,12 @@
 #define ARM_CPU_KEEP(x)
 #endif
 
+#if defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)
+#define ARM_EXIT_KEEP(x)	x
+#else
+#define ARM_EXIT_KEEP(x)
+#endif
+
 OUTPUT_ARCH(arm)
 ENTRY(stext)
 
@@ -43,6 +49,7 @@ SECTIONS
 		_sinittext = .;
 			HEAD_TEXT
 			INIT_TEXT
+			ARM_EXIT_KEEP(EXIT_TEXT)
 		_einittext = .;
 		ARM_CPU_DISCARD(PROC_INFO)
 		__arch_info_begin = .;
@@ -67,6 +74,7 @@ SECTIONS
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
 		INIT_DATA
+		ARM_EXIT_KEEP(EXIT_DATA)
 #endif
 	}
 
@@ -161,6 +169,7 @@ SECTIONS
 		. = ALIGN(PAGE_SIZE);
 		__init_begin = .;
 		INIT_DATA
+		ARM_EXIT_KEEP(EXIT_DATA)
 		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 #endif


