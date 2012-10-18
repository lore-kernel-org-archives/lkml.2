Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2JRUvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24676 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab2JRUvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 15/19] x86, mm: Move init_gbpages() out of setup.c
Date: Thu, 18 Oct 2012 13:50:26 -0700
Message-Id: <1350593430-24470-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
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
index 9cb2e27..d5e0887 100644
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
@@ -930,8 +919,6 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	init_gbpages();
-
 	init_mem_mapping();
 
 	memblock.current_limit = get_max_mapped();
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3fcdfa9..3fb0848 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -89,6 +89,16 @@ int direct_gbpages
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
@@ -99,6 +109,8 @@ static int page_size_mask;
 
 static void __init probe_page_size_mask(void)
 {
+	init_gbpages();
+
 #if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-- 
1.7.7

