Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab0JHOB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:01:28 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:18543 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab0JHOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:00:44 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9Z5KW-01-A9N-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/7] oprofile, x86: Add support for IBS branch target address reporting
Date: Fri, 8 Oct 2010 15:56:31 +0200
Message-ID: <1286546192-18593-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
References: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for IBS branch target address reporting. A new
MSR (MSRC001_103B IBS Branch Target Address) has been added that
provides the logical address in canonical form for the branch
target. The size of the IBS sample that is transferred to the userland
has been increased.

For backward compatibility, the userland daemon must explicit enable
the feature by writing to the oprofilefs file

 ibs_op/branch_target

After enabling branch target address reporting, the userland daemon
must handle the extended size of the IBS sample.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/msr-index.h |    1 +
 arch/x86/oprofile/op_model_amd.c |   26 ++++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 986f779..91ba8e6 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -121,6 +121,7 @@
 #define MSR_AMD64_IBSDCLINAD		0xc0011038
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
+#define MSR_AMD64_IBSBRTARGET		0xc001103b
 
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 9d45097..9de33fa 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -55,10 +55,13 @@ struct ibs_config {
 	unsigned long max_cnt_op;
 	unsigned long rand_en;
 	unsigned long dispatched_ops;
+	unsigned long branch_target;
 };
 
 struct ibs_state {
-	u64	ibs_op_ctl;
+	u64		ibs_op_ctl;
+	int		branch_target;
+	unsigned long	sample_size;
 };
 
 static struct ibs_config ibs_config;
@@ -79,6 +82,7 @@ static struct ibs_state ibs_state;
 #define IBS_CAPS_OPSAM			(1U<<2)
 #define IBS_CAPS_RDWROPCNT		(1U<<3)
 #define IBS_CAPS_OPCNT			(1U<<4)
+#define IBS_CAPS_BRNTRGT		(1U<<5)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
 					 | IBS_CAPS_FETCHSAM	\
@@ -207,8 +211,8 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 		rdmsrl(MSR_AMD64_IBSOPCTL, ctl);
 		if (ctl & IBS_OP_VAL) {
 			rdmsrl(MSR_AMD64_IBSOPRIP, val);
-			oprofile_write_reserve(&entry, regs, val,
-					       IBS_OP_CODE, IBS_OP_SIZE);
+			oprofile_write_reserve(&entry, regs, val, IBS_OP_CODE,
+					       ibs_state.sample_size);
 			oprofile_add_data64(&entry, val);
 			rdmsrl(MSR_AMD64_IBSOPDATA, val);
 			oprofile_add_data64(&entry, val);
@@ -220,6 +224,10 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			oprofile_add_data64(&entry, val);
 			rdmsrl(MSR_AMD64_IBSDCPHYSAD, val);
 			oprofile_add_data64(&entry, val);
+			if (ibs_state.branch_target) {
+				rdmsrl(MSR_AMD64_IBSBRTARGET, val);
+				oprofile_add_data(&entry, (unsigned long)val);
+			}
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
@@ -266,6 +274,11 @@ static inline void op_amd_start_ibs(void)
 		val |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
 		val |= IBS_OP_ENABLE;
 		ibs_state.ibs_op_ctl = val;
+		ibs_state.sample_size = IBS_OP_SIZE;
+		if (ibs_config.branch_target) {
+			ibs_state.branch_target = 1;
+			ibs_state.sample_size++;
+		}
 		val = op_amd_randomize_ibs_op(ibs_state.ibs_op_ctl);
 		wrmsrl(MSR_AMD64_IBSOPCTL, val);
 	}
@@ -540,11 +553,9 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 	/* model specific files */
 
 	/* setup some reasonable defaults */
+	memset(&ibs_config, 0, sizeof(ibs_config));
 	ibs_config.max_cnt_fetch = 250000;
-	ibs_config.fetch_enabled = 0;
 	ibs_config.max_cnt_op = 250000;
-	ibs_config.op_enabled = 0;
-	ibs_config.dispatched_ops = 0;
 
 	if (ibs_caps & IBS_CAPS_FETCHSAM) {
 		dir = oprofilefs_mkdir(sb, root, "ibs_fetch");
@@ -565,6 +576,9 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 		if (ibs_caps & IBS_CAPS_OPCNT)
 			oprofilefs_create_ulong(sb, dir, "dispatched_ops",
 						&ibs_config.dispatched_ops);
+		if (ibs_caps & IBS_CAPS_BRNTRGT)
+			oprofilefs_create_ulong(sb, dir, "branch_target",
+						&ibs_config.branch_target);
 	}
 
 	return 0;
-- 
1.7.2.2


