Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab1D2Pc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:32:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366Ab1D2P3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wIR2KZROq/sj88ZzSaIgQ8q7usrCuWxXb2vugO3//r0cqHHIpZljwyjG2vrJjYot5U
         a16nni0LBxHUgUsT0ux8NHTSoKBGtJJAuWBGM7iQ36SSE0ZlTX2qWqZs0kg+s5ZVAdxa
         My+kNOVbW2oLKLNxn94TEjVzDsyY9g06zEQgY=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/25] x86-32, NUMA: Move get_memcfg_numa() into numa_32.c
Date: Fri, 29 Apr 2011 17:28:30 +0200
Message-Id: <1304090924-8197-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason get_memcfg_numa() to be implemented inline in
mmzone_32.h.  Move it to numa_32.c and also make
get_memcfg_numa_flag() static.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/mmzone_32.h |   18 ------------------
 arch/x86/mm/numa_32.c            |   11 ++++++++++-
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 91df7c5..73e5745 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -16,28 +16,10 @@ extern struct pglist_data *node_data[];
 /* summit or generic arch */
 #include <asm/srat.h>
 
-extern int get_memcfg_numa_flat(void);
-/*
- * This allows any one NUMA architecture to be compiled
- * for, and still fall back to the flat function if it
- * fails.
- */
-static inline void get_memcfg_numa(void)
-{
-
-	if (get_memcfg_numaq())
-		return;
-	if (get_memcfg_from_srat())
-		return;
-	get_memcfg_numa_flat();
-}
-
 extern void resume_map_numa_kva(pgd_t *pgd);
 
 #else /* !CONFIG_NUMA */
 
-#define get_memcfg_numa get_memcfg_numa_flat
-
 static inline void resume_map_numa_kva(pgd_t *pgd) {}
 
 #endif /* CONFIG_NUMA */
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index f847fa1..abf1247 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -112,7 +112,7 @@ void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
  *        a single node with all available processors in it with a flat
  *        memory map.
  */
-int __init get_memcfg_numa_flat(void)
+static int __init get_memcfg_numa_flat(void)
 {
 	printk(KERN_DEBUG "NUMA - single node, flat memory mode\n");
 
@@ -332,6 +332,15 @@ static __init void init_alloc_remap(int nid)
 	       nid, node_pa, node_pa + size, remap_va, remap_va + size);
 }
 
+static void get_memcfg_numa(void)
+{
+	if (get_memcfg_numaq())
+		return;
+	if (get_memcfg_from_srat())
+		return;
+	get_memcfg_numa_flat();
+}
+
 void __init initmem_init(void)
 {
 	int nid;
-- 
1.7.1

