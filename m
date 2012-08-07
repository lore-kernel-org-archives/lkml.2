Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2HGRoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:30 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35601 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab2HGRo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:28 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 11/12] x86, microcode, AMD: Add a small, per-family patches cache
Date: Tue,  7 Aug 2012 19:44:20 +0200
Message-Id: <1344361461-10076-12-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is a trivial cache which collects all ucode patches for the current
family of CPUs on the system. If a newer patch appears due to the
container file being updated in userspace, we replace our cached version
with the new one.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c | 67 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 03ed5af7053d..cacdc9a5ee49 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -78,12 +78,22 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 /* page-sized ucode patch buffer */
 void *patch;
 
+struct ucode_patch {
+	struct list_head plist;
+	void *data;
+	u32 patch_id;
+	u16 equiv_cpu;
+};
+
+static LIST_HEAD(pcache);
+
 static u16 find_equiv_id(unsigned int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int i = 0;
 
-	BUG_ON(equiv_cpu_table == NULL);
+	if (!equiv_cpu_table)
+		return 0;
 
 	while (equiv_cpu_table[i].installed_cpu != 0) {
 		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
@@ -108,6 +118,61 @@ static u32 find_cpu_family_by_equiv_cpu(u16 equiv_cpu)
 	return 0;
 }
 
+/*
+ * a small, trivial cache of per-family ucode patches
+ */
+static struct ucode_patch *cache_find_patch(u16 equiv_cpu)
+{
+	struct ucode_patch *p;
+
+	list_for_each_entry(p, &pcache, plist)
+		if (p->equiv_cpu == equiv_cpu)
+			return p;
+	return NULL;
+}
+
+static void update_cache(struct ucode_patch *new_patch)
+{
+	struct ucode_patch *p;
+
+	list_for_each_entry(p, &pcache, plist) {
+		if (p->equiv_cpu == new_patch->equiv_cpu) {
+			if (p->patch_id >= new_patch->patch_id)
+				/* we already have the latest patch */
+				return;
+
+			list_replace(&p->plist, &new_patch->plist);
+			kfree(p->data);
+			kfree(p);
+			return;
+		}
+	}
+	/* no patch found, add it */
+	list_add_tail(&new_patch->plist, &pcache);
+}
+
+static void free_cache(void)
+{
+	struct ucode_patch *p;
+
+	list_for_each_entry_reverse(p, &pcache, plist) {
+		__list_del(p->plist.prev, p->plist.next);
+		kfree(p->data);
+		kfree(p);
+	}
+}
+
+static struct ucode_patch *find_patch(unsigned int cpu)
+{
+	u16 equiv_id;
+
+	equiv_id = find_equiv_id(cpu);
+	if (!equiv_id)
+		return NULL;
+
+	return cache_find_patch(equiv_id);
+}
+
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-- 
1.7.11.rc1

