Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0LVNRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:17:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:55789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0LVNRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:17:34 -0500
Date: Wed, 22 Dec 2010 13:17:06 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130195926.834804371@sgi.com>
References: <20101130195926.834804371@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Add common uv_early_read_mmr() function for reading MMRs
Message-ID: <tip-e681041388e61ecd7f99dba66b3c1db11a564d92@git.kernel.org>
Git-Commit-ID: e681041388e61ecd7f99dba66b3c1db11a564d92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 13:17:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e681041388e61ecd7f99dba66b3c1db11a564d92
Gitweb:     http://git.kernel.org/tip/e681041388e61ecd7f99dba66b3c1db11a564d92
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Tue, 30 Nov 2010 13:55:39 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Dec 2010 12:31:15 +0100

x86, UV: Add common uv_early_read_mmr() function for reading MMRs

Early in boot, reading MMRs from the UV hub controller require
calls to early_ioremap()/early_iounmap().  Rather than
duplicating code, add a common function to do the
map/read/unmap.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20101130195926.834804371@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index c1c52c3..0c3675f 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -48,6 +48,16 @@ unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
+static unsigned long __init uv_early_read_mmr(unsigned long addr)
+{
+	unsigned long val, *mmr;
+
+	mmr = early_ioremap(UV_LOCAL_MMR_BASE | addr, sizeof(*mmr));
+	val = *mmr;
+	early_iounmap(mmr, sizeof(*mmr));
+	return val;
+}
+
 static inline bool is_GRU_range(u64 start, u64 end)
 {
 	return start >= gru_start_paddr && end <= gru_end_paddr;
@@ -58,16 +68,12 @@ static bool uv_is_untracked_pat_range(u64 start, u64 end)
 	return is_ISA_range(start, end) || is_GRU_range(start, end);
 }
 
-static int early_get_nodeid(void)
+static int __init early_get_nodeid(void)
 {
 	union uvh_node_id_u node_id;
-	unsigned long *mmr;
-
-	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_NODE_ID, sizeof(*mmr));
-	node_id.v = *mmr;
-	early_iounmap(mmr, sizeof(*mmr));
 
 	/* Currently, all blades have same revision number */
+	node_id.v = uv_early_read_mmr(UVH_NODE_ID);
 	uv_min_hub_revision_id = node_id.s.revision;
 
 	return node_id.s.node_id;
@@ -75,11 +81,7 @@ static int early_get_nodeid(void)
 
 static void __init early_get_apic_pnode_shift(void)
 {
-	unsigned long *mmr;
-
-	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_APICID, sizeof(*mmr));
-	uvh_apicid.v = *mmr;
-	early_iounmap(mmr, sizeof(*mmr));
+	uvh_apicid.v = uv_early_read_mmr(UVH_APICID);
 	if (!uvh_apicid.v)
 		/*
 		 * Old bios, use default value
@@ -95,12 +97,8 @@ static void __init early_get_apic_pnode_shift(void)
 static void __init uv_set_apicid_hibit(void)
 {
 	union uvh_lb_target_physical_apic_id_mask_u apicid_mask;
-	unsigned long *mmr;
 
-	mmr = early_ioremap(UV_LOCAL_MMR_BASE |
-		UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK, sizeof(*mmr));
-	apicid_mask.v = *mmr;
-	early_iounmap(mmr, sizeof(*mmr));
+	apicid_mask.v = uv_early_read_mmr(UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK);
 	uv_apicid_hibits = apicid_mask.s.bit_enables & UV_APICID_HIBIT_MASK;
 }
 
