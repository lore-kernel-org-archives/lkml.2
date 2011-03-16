Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1CPTps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:45:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:35004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1CPTpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:45:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,195,1299484800"; 
   d="scan'208";a="613829535"
From: Andi Kleen <andi@firstfloor.org>
To: robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] oprofile: Allow setting EDGE/INV/CMASK for Intel counter events v2
Date: Wed, 16 Mar 2011 12:44:33 -0700
Message-Id: <1300304673-4823-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For some performance events it's useful to set the EDGE and INV
bits and the CMASK mask in the counter control register. The list
of predefined events Intel releases for each CPU has some events which
require these settings to get more "natural" to use higher level events.

oprofile currently doesn't allow this.

This patch adds new extra configuration fields for them, so that
they can be specified in oprofilefs.

An updated oprofile daemon can then make use of this to set them.

v2: Write back masked extra value to variable.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/oprofile/nmi_int.c    |    5 +++++
 arch/x86/oprofile/op_counter.h |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index e2b7b0c..ee165f1 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -49,6 +49,10 @@ u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 	val |= counter_config->user ? ARCH_PERFMON_EVENTSEL_USR : 0;
 	val |= counter_config->kernel ? ARCH_PERFMON_EVENTSEL_OS : 0;
 	val |= (counter_config->unit_mask & 0xFF) << 8;
+	counter_config->extra &= (ARCH_PERFMON_EVENTSEL_INV |
+				  ARCH_PERFMON_EVENTSEL_EDGE |
+				  ARCH_PERFMON_EVENTSEL_CMASK);
+	val |= counter_config->extra;
 	event &= model->event_mask ? model->event_mask : 0xFF;
 	val |= event & 0xFF;
 	val |= (event & 0x0F00) << 24;
@@ -440,6 +444,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
 		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
 		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
+		oprofilefs_create_ulong(sb, dir, "extra", &counter_config[i].extra);
 	}
 
 	return 0;
diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
index e28398d..0b7b7b1 100644
--- a/arch/x86/oprofile/op_counter.h
+++ b/arch/x86/oprofile/op_counter.h
@@ -22,6 +22,7 @@ struct op_counter_config {
 	unsigned long kernel;
 	unsigned long user;
 	unsigned long unit_mask;
+	unsigned long extra;
 };
 
 extern struct op_counter_config counter_config[];
-- 
1.7.4

