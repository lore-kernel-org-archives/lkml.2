Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab2HVXpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:45:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2HVXpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:45:15 -0400
Date: Wed, 22 Aug 2012 16:45:03 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-c96d2c0905cc48e34f2b37b775b59932c416b343@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-11-git-send-email-bp@amd64.org>
References: <1344361461-10076-11-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, AMD:
  Add reverse equiv table search
Git-Commit-ID: c96d2c0905cc48e34f2b37b775b59932c416b343
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:45:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c96d2c0905cc48e34f2b37b775b59932c416b343
Gitweb:     http://git.kernel.org/tip/c96d2c0905cc48e34f2b37b775b59932c416b343
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 1 Aug 2012 14:55:01 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:16:11 -0700

x86, microcode, AMD: Add reverse equiv table search

We search the equivalence table using the CPUID(1) signature of the
CPU in order to get the equivalence ID of the patch which we need to
apply. Add a function which does the reverse - it will be needed in
later patches.

While at it, pull the other equiv table function up in the file so that
it can be used by other functionality without forward declarations.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-11-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_amd.c |   46 +++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 94ecdaa..03ed5af 100644
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
