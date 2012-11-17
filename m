Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2KQDpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:45:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27445 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2KQDki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:38 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 31/46] x86, mm: Move init_gbpages() out of setup.c
Date: Fri, 16 Nov 2012 19:39:08 -0800
Message-Id: <1353123563-3103-32-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put it in mm/init.c, and call it from probe_page_mask().
init_mem_mapping is calling probe_page_mask at first.
So calling sequence is not changed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |   15 +--------------
 arch/x86/mm/init.c      |   12 ++++++++++++
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2015194..85b62f1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -282,18 +282,7 @@ void * __init extend_brk(size_t size, size_t align)
 	return ret;
 }
 
-#ifdef CONFIG_X86_64
-static void __init init_gbpages(void)
-{
-	if (direct_gbpages && cpu_has_gbpages)
-		printk(KERN_INFO "Using GB pages for direct mapping\n");
-	else
-		direct_gbpages = 0;
-}
-#else
-static inline void init_gbpages(void)
-{
-}
+#ifdef CONFIG_X86_32
 static void __init cleanup_highmap(void)
 {
 }
@@ -933,8 +922,6 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	init_gbpages();
-
 	init_mem_mapping();
 
 	memblock.current_limit = get_max_mapped();
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3cadf10..8168bf8 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -98,6 +98,16 @@ int direct_gbpages
 #endif
 ;
 
+static void __init init_gbpages(void)
+{
+#ifdef CONFIG_X86_64
+	if (direct_gbpages && cpu_has_gbpages)
+		printk(KERN_INFO "Using GB pages for direct mapping\n");
+	else
+		direct_gbpages = 0;
+#endif
+}
+
 struct map_range {
 	unsigned long start;
 	unsigned long end;
@@ -108,6 +118,8 @@ static int page_size_mask;
 
 static void __init probe_page_size_mask(void)
 {
+	init_gbpages();
+
 #if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-- 
1.7.7

