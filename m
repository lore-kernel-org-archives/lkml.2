Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2HGRoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:34 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35600 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab2HGRo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:28 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 10/12] x86, microcode, AMD: Add reverse equiv table search
Date: Tue,  7 Aug 2012 19:44:19 +0200
Message-Id: <1344361461-10076-11-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

We search the equivalence table using the CPUID(1) signature of the
CPU in order to get the equivalence ID of the patch which we need to
apply. Add a function which does the reverse - it will be needed in
later patches.

While at it, pull the other equiv table function up in the file so that
it can be used by other functionality without forward declarations.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c | 46 +++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 94ecdaa24052..03ed5af7053d 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -78,6 +78,36 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 /* page-sized ucode patch buffer */
 void *patch;
 
+static u16 find_equiv_id(unsigned int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	int i = 0;
+
+	BUG_ON(equiv_cpu_table == NULL);
+
+	while (equiv_cpu_table[i].installed_cpu != 0) {
+		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
+			return equiv_cpu_table[i].equiv_cpu;
+
+		i++;
+	}
+	return 0;
+}
+
+static u32 find_cpu_family_by_equiv_cpu(u16 equiv_cpu)
+{
+	int i = 0;
+
+	BUG_ON(!equiv_cpu_table);
+
+	while (equiv_cpu_table[i].equiv_cpu != 0) {
+		if (equiv_cpu == equiv_cpu_table[i].equiv_cpu)
+			return equiv_cpu_table[i].installed_cpu;
+		i++;
+	}
+	return 0;
+}
+
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -119,22 +149,6 @@ static unsigned int verify_ucode_size(int cpu, u32 patch_size,
 	return patch_size;
 }
 
-static u16 find_equiv_id(unsigned int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	int i = 0;
-
-	BUG_ON(equiv_cpu_table == NULL);
-
-	while (equiv_cpu_table[i].installed_cpu != 0) {
-		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
-			return equiv_cpu_table[i].equiv_cpu;
-
-		i++;
-	}
-	return 0;
-}
-
 /*
  * we signal a good patch is found by returning its size > 0
  */
-- 
1.7.11.rc1

