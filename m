Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1KHRLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:11:44 -0500
Received: from ams-iport-3.cisco.com ([144.254.224.146]:7374 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1KHRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:11:41 -0500
X-IronPort-AV: E=Sophos;i="4.69,477,1315180800"; 
   d="scan'208";a="2657333"
Date: Tue, 8 Nov 2011 22:35:35 +0530
From: Maneesh Soni <manesoni@cisco.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>, ananth@in.ibm.com,
        kamensky@cisco.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: [PATCH 2/4] MIPS Kprobes: Deny probes on ll/sc instructions
Message-ID: <20111108170535.GC16526@cisco.com>
Reply-To: manesoni@cisco.com
References: <20111108170336.GA16526@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108170336.GA16526@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Maneesh Soni <manesoni@cisco.com>

Deny probes on ll/sc instructions for MIPS kprobes

As ll/sc instruction are for atomic read-modify-write operations, allowing
probes on top of these insturctions is a bad idea.

Signed-off-by: Victor Kamensky <kamensky@cisco.com>
Signed-off-by: Maneesh Soni <manesoni@cisco.com>
---
 arch/mips/kernel/kprobes.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
index 9fb1876..0ab1a5f 100644
--- a/arch/mips/kernel/kprobes.c
+++ b/arch/mips/kernel/kprobes.c
@@ -113,6 +113,30 @@ insn_ok:
 	return 0;
 }
 
+/*
+ * insn_has_ll_or_sc function checks whether instruction is ll or sc
+ * one; putting breakpoint on top of atomic ll/sc pair is bad idea;
+ * so we need to prevent it and refuse kprobes insertion for such
+ * instructions; cannot do much about breakpoint in the middle of
+ * ll/sc pair; it is upto user to avoid those places
+ */
+static int __kprobes insn_has_ll_or_sc(union mips_instruction insn)
+{
+	int ret = 0;
+
+	switch (insn.i_format.opcode) {
+	case ll_op:
+	case lld_op:
+	case sc_op:
+	case scd_op:
+		ret = 1;
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	union mips_instruction insn;
@@ -121,6 +145,13 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 
 	insn = p->addr[0];
 
+	if (insn_has_ll_or_sc(insn)) {
+		pr_notice("Kprobes for ll and sc instructions are not"
+			  "supported\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (insn_has_delayslot(insn)) {
 		pr_notice("Kprobes for branch and jump instructions are not"
 			  "supported\n");
-- 
1.7.1

