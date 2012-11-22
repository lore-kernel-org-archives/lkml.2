Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2KVU6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:58:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833Ab2KVS62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:28 -0500
Date: Wed, 21 Nov 2012 18:21:20 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-94b43c3d86dddf95064fc83e9087448b35f985ff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-43-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-43-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: kill numa_free_all_bootmem()
Git-Commit-ID: 94b43c3d86dddf95064fc83e9087448b35f985ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:21:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94b43c3d86dddf95064fc83e9087448b35f985ff
Gitweb:     http://git.kernel.org/tip/94b43c3d86dddf95064fc83e9087448b35f985ff
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:19 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:47 -0800

x86, mm: kill numa_free_all_bootmem()

Now NO_BOOTMEM version free_all_bootmem_node() does not really
do free_bootmem at all, and it only call register_page_bootmem_info_node
instead.

That is confusing, try to kill that free_all_bootmem_node().

Before that, this patch will remove numa_free_all_bootmem().

That function could be replaced with register_page_bootmem_info() and
free_all_bootmem();

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-43-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |  2 --
 arch/x86/mm/init_64.c          | 15 +++++++++++----
 arch/x86/mm/numa_64.c          | 13 -------------
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 0c05f7a..fe4d2d4 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -1,6 +1,4 @@
 #ifndef _ASM_X86_NUMA_64_H
 #define _ASM_X86_NUMA_64_H
 
-extern unsigned long numa_free_all_bootmem(void);
-
 #endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1d53def..4178530 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -629,6 +629,16 @@ EXPORT_SYMBOL_GPL(arch_add_memory);
 
 static struct kcore_list kcore_vsyscall;
 
+static void __init register_page_bootmem_info(void)
+{
+#ifdef CONFIG_NUMA
+	int i;
+
+	for_each_online_node(i)
+		register_page_bootmem_info_node(NODE_DATA(i));
+#endif
+}
+
 void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
@@ -641,11 +651,8 @@ void __init mem_init(void)
 	reservedpages = 0;
 
 	/* this will put all low memory onto the freelists */
-#ifdef CONFIG_NUMA
-	totalram_pages = numa_free_all_bootmem();
-#else
+	register_page_bootmem_info();
 	totalram_pages = free_all_bootmem();
-#endif
 
 	absent_pages = absent_pages_in_range(0, max_pfn);
 	reservedpages = max_pfn - totalram_pages - absent_pages;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 92e2711..9405ffc 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -10,16 +10,3 @@ void __init initmem_init(void)
 {
 	x86_numa_init();
 }
-
-unsigned long __init numa_free_all_bootmem(void)
-{
-	unsigned long pages = 0;
-	int i;
-
-	for_each_online_node(i)
-		pages += free_all_bootmem_node(NODE_DATA(i));
-
-	pages += free_low_memory_core_early(MAX_NUMNODES);
-
-	return pages;
-}
