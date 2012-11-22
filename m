Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab2KVUyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:54:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2KVS6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:34 -0500
Date: Wed, 21 Nov 2012 18:09:54 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-148b20989e0b83cb301e1fcd9e987c7abde05333@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-32-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-32-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Move init_gbpages() out of setup.c
Git-Commit-ID: 148b20989e0b83cb301e1fcd9e987c7abde05333
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:10:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  148b20989e0b83cb301e1fcd9e987c7abde05333
Gitweb:     http://git.kernel.org/tip/148b20989e0b83cb301e1fcd9e987c7abde05333
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:08 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:37 -0800

x86, mm: Move init_gbpages() out of setup.c

Put it in mm/init.c, and call it from probe_page_mask().
init_mem_mapping is calling probe_page_mask at first.
So calling sequence is not changed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-32-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 15 +--------------
 arch/x86/mm/init.c      | 12 ++++++++++++
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
