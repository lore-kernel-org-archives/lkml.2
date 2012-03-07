Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2CGNKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:10:46 -0500
Received: from bluegiga.fi ([194.100.31.45]:16223 "EHLO darkblue.bluegiga.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab2CGNKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:10:45 -0500
From: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2] mm: module_alloc: check if size is 0
Date: Wed,  7 Mar 2012 15:09:28 +0200
Message-Id: <1331125768-25454-1-git-send-email-veli-pekka.peltola@bluegiga.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330631119-10059-1-git-send-email-veli-pekka.peltola@bluegiga.com>
References: <1330631119-10059-1-git-send-email-veli-pekka.peltola@bluegiga.com>
X-OriginalArrivalTime: 07 Mar 2012 13:10:38.0247 (UTC) FILETIME=[B0A50B70:01CCFC63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit de7d2b567d040e3b67fe7121945982f14343213d (mm/vmalloc.c: report
more vmalloc failures) users will get a warning if vmalloc_node_range() is
called with size 0. This happens if module's init size equals to 0. This
patch changes ARM, MIPS and x86 module_alloc() to return NULL before calling
vmalloc_node_range() that would also return NULL and print a warning.

Signed-off-by: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
I found this with ARM but after checking out various implementations of
module_alloc() I thought it would be better to fix all at once.

One way to replicate the warning:
compile kernel with CONFIG_KALLSYMS=n
insmod a module without init, I used usb-common.ko

Changes since v1:
 - changed style as hpa suggested

 arch/arm/kernel/module.c  |    2 ++
 arch/mips/kernel/module.c |    2 ++
 arch/x86/kernel/module.c  |    2 +-
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 1e9be5d..17648e2 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -39,6 +39,8 @@
 #ifdef CONFIG_MMU
 void *module_alloc(unsigned long size)
 {
+	if (!size)
+		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
 				GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
 				__builtin_return_address(0));
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index a5066b1..1a51de1 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -47,6 +47,8 @@ static DEFINE_SPINLOCK(dbe_lock);
 #ifdef MODULE_START
 void *module_alloc(unsigned long size)
 {
+	if (!size)
+		return NULL;
 	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
 				GFP_KERNEL, PAGE_KERNEL, -1,
 				__builtin_return_address(0));
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 925179f..fd44d69 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -38,7 +38,7 @@
 
 void *module_alloc(unsigned long size)
 {
-	if (PAGE_ALIGN(size) > MODULES_LEN)
+	if (!size || PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
 				GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
-- 
1.7.5.4

