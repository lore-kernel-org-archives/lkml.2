Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1FUMYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:24:05 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51706 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab1FUMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:22:43 -0400
Message-Id: <20110621122242.630995969@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 21 Jun 2011 07:21:30 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [patch 5/8 v5] x86, UV: rename hubmask to pnmask
References: <20110621122125.688884227@sgi.com>
Content-Disposition: inline; filename=tlb_uv_ipiresetpnmask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename 'bau_targ_hubmask' to 'pnmask' for clarity.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

The BAU distribution bit mask is indexed by pnode number, not hub or
blade number.  This important fact is not clear while the mask is
called a 'hubmask'.

 arch/x86/include/asm/uv/uv_bau.h |   12 ++++++------
 arch/x86/platform/uv/tlb_uv.c    |    5 ++---
 2 files changed, 8 insertions(+), 9 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -183,7 +183,7 @@
  * 'base_dest_nasid' field of the header corresponds to the
  * destination nodeID associated with that specified bit.
  */
-struct bau_targ_hubmask {
+struct pnmask {
 	unsigned long		bits[BITS_TO_LONGS(UV_DISTRIBUTION_SIZE)];
 };
 
@@ -314,7 +314,7 @@ struct bau_msg_header {
  * Should be 64 bytes
  */
 struct bau_desc {
-	struct bau_targ_hubmask	distribution;
+	struct pnmask			distribution;
 	/*
 	 * message template, consisting of header and payload:
 	 */
@@ -596,20 +596,20 @@ static inline void write_mmr_data_config
 	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG, mr);
 }
 
-static inline int bau_uvhub_isset(int uvhub, struct bau_targ_hubmask *dstp)
+static inline int bau_uvhub_isset(int uvhub, struct pnmask *dstp)
 {
 	return constant_test_bit(uvhub, &dstp->bits[0]);
 }
-static inline void bau_uvhub_set(int pnode, struct bau_targ_hubmask *dstp)
+static inline void bau_uvhub_set(int pnode, struct pnmask *dstp)
 {
 	__set_bit(pnode, &dstp->bits[0]);
 }
-static inline void bau_uvhubs_clear(struct bau_targ_hubmask *dstp,
+static inline void bau_uvhubs_clear(struct pnmask *dstp,
 				    int nbits)
 {
 	bitmap_zero(&dstp->bits[0], nbits);
 }
-static inline int bau_uvhub_weight(struct bau_targ_hubmask *dstp)
+static inline int bau_uvhub_weight(struct pnmask *dstp)
 {
 	return bitmap_weight((unsigned long *)&dstp->bits[0],
 				UV_DISTRIBUTION_SIZE);
Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -370,8 +370,7 @@ static void do_reset(void *ptr)
  * Use IPI to get all target uvhubs to release resources held by
  * a given sending cpu number.
  */
-static void reset_with_ipi(struct bau_targ_hubmask *distribution,
-						struct bau_control *bcp)
+static void reset_with_ipi(struct pnmask *distribution, struct bau_control *bcp)
 {
 	int pnode;
 	int apnode;
@@ -384,7 +383,7 @@ static void reset_with_ipi(struct bau_ta
 	reset_args.sender = sender;
 	cpus_clear(mask);
 	/* find a single cpu for each uvhub in this distribution mask */
-	maskbits = sizeof(struct bau_targ_hubmask) * BITSPERBYTE;
+	maskbits = sizeof(struct pnmask) * BITSPERBYTE;
 	/* each bit is a pnode relative to the partition base pnode */
 	for (pnode = 0; pnode < maskbits; pnode++) {
 		int cpu;

