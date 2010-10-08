Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0JHOAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:00:48 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:1501 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0JHOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:00:45 -0400
X-SpamScore: -7
X-BigFish: VS-7(zzzz1202hzz8275bh5eeePz32i87h2a8h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9Z5KV-02-0J8-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] oprofile, x86: Check IBS capability bits 1 and 2
Date: Fri, 8 Oct 2010 15:56:28 +0200
Message-ID: <1286546192-18593-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
References: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are IBS CPUID feature flags in CPUID Fn8000_001B to detect if
the cpu supports IBS fetch sampling (FetchSam) and/or IBS execution
sampling (OpSam). This patch adds checks if the both features are
available.

Spec:

 http://support.amd.com/us/Processor_TechDocs/31116.pdf

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   59 ++++++++++++++++++++++++-------------
 1 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index b67a6b5..96852d5 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -70,9 +70,22 @@ static u64 ibs_op_ctl;
  * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
  * bit 0 is used to indicate the existence of IBS.
  */
-#define IBS_CAPS_AVAIL			(1LL<<0)
-#define IBS_CAPS_RDWROPCNT		(1LL<<3)
-#define IBS_CAPS_OPCNT			(1LL<<4)
+#define IBS_CAPS_AVAIL			(1U<<0)
+#define IBS_CAPS_FETCHSAM		(1U<<1)
+#define IBS_CAPS_OPSAM			(1U<<2)
+#define IBS_CAPS_RDWROPCNT		(1U<<3)
+#define IBS_CAPS_OPCNT			(1U<<4)
+
+#define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
+					 | IBS_CAPS_FETCHSAM	\
+					 | IBS_CAPS_OPSAM)
+
+/*
+ * IBS APIC setup
+ */
+#define IBSCTL				0x1cc
+#define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
+#define IBSCTL_LVT_OFFSET_MASK		0x0F
 
 /*
  * IBS randomization macros
@@ -92,12 +105,12 @@ static u32 get_ibs_caps(void)
 	/* check IBS cpuid feature flags */
 	max_level = cpuid_eax(0x80000000);
 	if (max_level < IBS_CPUID_FEATURES)
-		return IBS_CAPS_AVAIL;
+		return IBS_CAPS_DEFAULT;
 
 	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
 	if (!(ibs_caps & IBS_CAPS_AVAIL))
 		/* cpuid flags not valid */
-		return IBS_CAPS_AVAIL;
+		return IBS_CAPS_DEFAULT;
 
 	return ibs_caps;
 }
@@ -527,22 +540,26 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 	ibs_config.op_enabled = 0;
 	ibs_config.dispatched_ops = 0;
 
-	dir = oprofilefs_mkdir(sb, root, "ibs_fetch");
-	oprofilefs_create_ulong(sb, dir, "enable",
-				&ibs_config.fetch_enabled);
-	oprofilefs_create_ulong(sb, dir, "max_count",
-				&ibs_config.max_cnt_fetch);
-	oprofilefs_create_ulong(sb, dir, "rand_enable",
-				&ibs_config.rand_en);
-
-	dir = oprofilefs_mkdir(sb, root, "ibs_op");
-	oprofilefs_create_ulong(sb, dir, "enable",
-				&ibs_config.op_enabled);
-	oprofilefs_create_ulong(sb, dir, "max_count",
-				&ibs_config.max_cnt_op);
-	if (ibs_caps & IBS_CAPS_OPCNT)
-		oprofilefs_create_ulong(sb, dir, "dispatched_ops",
-					&ibs_config.dispatched_ops);
+	if (ibs_caps & IBS_CAPS_FETCHSAM) {
+		dir = oprofilefs_mkdir(sb, root, "ibs_fetch");
+		oprofilefs_create_ulong(sb, dir, "enable",
+					&ibs_config.fetch_enabled);
+		oprofilefs_create_ulong(sb, dir, "max_count",
+					&ibs_config.max_cnt_fetch);
+		oprofilefs_create_ulong(sb, dir, "rand_enable",
+					&ibs_config.rand_en);
+	}
+
+	if (ibs_caps & IBS_CAPS_OPSAM) {
+		dir = oprofilefs_mkdir(sb, root, "ibs_op");
+		oprofilefs_create_ulong(sb, dir, "enable",
+					&ibs_config.op_enabled);
+		oprofilefs_create_ulong(sb, dir, "max_count",
+					&ibs_config.max_cnt_op);
+		if (ibs_caps & IBS_CAPS_OPCNT)
+			oprofilefs_create_ulong(sb, dir, "dispatched_ops",
+						&ibs_config.dispatched_ops);
+	}
 
 	return 0;
 }
-- 
1.7.2.2


