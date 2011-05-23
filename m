Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1EWKTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:19:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56195 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab1EWKTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:19:41 -0400
Date: Mon, 23 May 2011 12:19:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110523101926.GA29815@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

 Thanks,

	Ingo

------------------>
Fenghua Yu (1):
      x86, SMEP: Fix section mismatch warnings

Gustavo F. Padovan (1):
      x86: Eliminate various 'set but not used' warnings

Roedel, Joerg (1):
      x86, amd: Use _safe() msr access for GartTlbWlk disable code


 arch/x86/kernel/amd_iommu.c  |    5 +----
 arch/x86/kernel/cpu/amd.c    |    9 ++++++---
 arch/x86/kernel/cpu/common.c |    4 ++--
 arch/x86/kernel/test_nx.c    |    2 +-
 arch/x86/mm/pf_in.c          |   14 +++-----------
 5 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 873e7e1..cd8cbeb 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1538,13 +1538,11 @@ static void do_detach(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
 	u16 devid;
 
 	devid    = get_device_id(dev);
 	iommu    = amd_iommu_rlookup_table[devid];
 	dev_data = get_dev_data(dev);
-	pdev     = to_pci_dev(dev);
 
 	/* decrease reference counters */
 	dev_data->domain->dev_iommu[iommu->index] -= 1;
@@ -1703,10 +1701,9 @@ static struct protection_domain *domain_for_device(struct device *dev)
 	struct protection_domain *dom;
 	struct iommu_dev_data *dev_data, *alias_data;
 	unsigned long flags;
-	u16 devid, alias;
+	u16 devid;
 
 	devid      = get_device_id(dev);
-	alias      = amd_iommu_alias_table[devid];
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
 	if (!alias_data)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6f9d1f6..8f5cabb 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -629,10 +629,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
 		 */
 		u64 mask;
+		int err;
 
-		rdmsrl(MSR_AMD64_MCx_MASK(4), mask);
-		mask |= (1 << 10);
-		wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		err = rdmsrl_safe(MSR_AMD64_MCx_MASK(4), &mask);
+		if (err == 0) {
+			mask |= (1 << 10);
+			checking_wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		}
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cbc70a2..c8b4162 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -254,7 +254,7 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
-static int disable_smep __initdata;
+static int disable_smep __cpuinitdata;
 static __init int setup_disable_smep(char *arg)
 {
 	disable_smep = 1;
@@ -262,7 +262,7 @@ static __init int setup_disable_smep(char *arg)
 }
 __setup("nosmep", setup_disable_smep);
 
-static __init void setup_smep(struct cpuinfo_x86 *c)
+static __cpuinit void setup_smep(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SMEP)) {
 		if (unlikely(disable_smep)) {
diff --git a/arch/x86/kernel/test_nx.c b/arch/x86/kernel/test_nx.c
index 787a5e4..3f92ce0 100644
--- a/arch/x86/kernel/test_nx.c
+++ b/arch/x86/kernel/test_nx.c
@@ -161,7 +161,7 @@ static int test_NX(void)
 	}
 
 #endif
-	return 0;
+	return ret;
 }
 
 static void test_exit(void)
diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
index 38e6d17..9f0614d 100644
--- a/arch/x86/mm/pf_in.c
+++ b/arch/x86/mm/pf_in.c
@@ -414,22 +414,17 @@ unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
 	unsigned char *p;
 	struct prefix_bits prf;
 	int i;
-	unsigned long rv;
 
 	p = (unsigned char *)ins_addr;
 	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 	for (i = 0; i < ARRAY_SIZE(reg_rop); i++)
-		if (reg_rop[i] == opcode) {
-			rv = REG_READ;
+		if (reg_rop[i] == opcode)
 			goto do_work;
-		}
 
 	for (i = 0; i < ARRAY_SIZE(reg_wop); i++)
-		if (reg_wop[i] == opcode) {
-			rv = REG_WRITE;
+		if (reg_wop[i] == opcode)
 			goto do_work;
-		}
 
 	printk(KERN_ERR "mmiotrace: Not a register instruction, opcode "
 							"0x%02x\n", opcode);
@@ -474,16 +469,13 @@ unsigned long get_ins_imm_val(unsigned long ins_addr)
 	unsigned char *p;
 	struct prefix_bits prf;
 	int i;
-	unsigned long rv;
 
 	p = (unsigned char *)ins_addr;
 	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 	for (i = 0; i < ARRAY_SIZE(imm_wop); i++)
-		if (imm_wop[i] == opcode) {
-			rv = IMM_WRITE;
+		if (imm_wop[i] == opcode)
 			goto do_work;
-		}
 
 	printk(KERN_ERR "mmiotrace: Not an immediate instruction, opcode "
 							"0x%02x\n", opcode);
