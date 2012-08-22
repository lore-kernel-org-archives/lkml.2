Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2HVXqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:46:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2HVXqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:46:11 -0400
Date: Wed, 22 Aug 2012 16:45:58 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-a3eb3b4da106a23b5d41bf915726172e31654a65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-12-git-send-email-bp@amd64.org>
References: <1344361461-10076-12-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, AMD: Add a small,
  per-family patches cache
Git-Commit-ID: a3eb3b4da106a23b5d41bf915726172e31654a65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:46:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3eb3b4da106a23b5d41bf915726172e31654a65
Gitweb:     http://git.kernel.org/tip/a3eb3b4da106a23b5d41bf915726172e31654a65
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 1 Aug 2012 15:38:18 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:16:21 -0700

x86, microcode, AMD: Add a small, per-family patches cache

This is a trivial cache which collects all ucode patches for the current
family of CPUs on the system. If a newer patch appears due to the
container file being updated in userspace, we replace our cached version
with the new one.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-12-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_amd.c |   67 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 03ed5af..cacdc9a 100644
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
