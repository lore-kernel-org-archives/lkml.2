Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1EURVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 13:21:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:34092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab1EURVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 13:21:47 -0400
Date: Sat, 21 May 2011 17:21:29 GMT
From: "tip-bot for Gustavo F. Padovan" <padovan@profusion.mobi>
Message-ID: <tip-6ec5ff4bc3a90b7716eadc4c8a686e904131f03a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        padovan@profusion.mobi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        padovan@profusion.mobi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
References: <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Eliminate various 'set but not used' warnings
Git-Commit-ID: 6ec5ff4bc3a90b7716eadc4c8a686e904131f03a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 21 May 2011 17:21:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ec5ff4bc3a90b7716eadc4c8a686e904131f03a
Gitweb:     http://git.kernel.org/tip/6ec5ff4bc3a90b7716eadc4c8a686e904131f03a
Author:     Gustavo F. Padovan <padovan@profusion.mobi>
AuthorDate: Fri, 20 May 2011 16:13:00 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 May 2011 19:10:33 +0200

x86: Eliminate various 'set but not used' warnings

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Cc: Joerg Roedel <joerg.roedel@amd.com> (supporter:AMD IOMMU (AMD-VI))
Cc: iommu@lists.linux-foundation.org (open list:AMD IOMMU (AMD-VI))
Link: http://lkml.kernel.org/r/1305918786-7239-3-git-send-email-padovan@profusion.mobi
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/amd_iommu.c |    5 +----
 arch/x86/kernel/test_nx.c   |    2 +-
 arch/x86/mm/pf_in.c         |   14 +++-----------
 3 files changed, 5 insertions(+), 16 deletions(-)

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
