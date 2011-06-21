Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1FUPSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:18:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:60000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1FUPSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:18:21 -0400
Date: Tue, 21 Jun 2011 15:18:05 GMT
From: "tip-bot for cpw@sgi.com" <cpw@sgi.com>
Message-ID: <tip-a456eaab87461e33d94e748565eabd474283a475@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621122242.630995969@sgi.com>
References: <20110621122242.630995969@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Rename hubmask to pnmask
Git-Commit-ID: a456eaab87461e33d94e748565eabd474283a475
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 15:18:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a456eaab87461e33d94e748565eabd474283a475
Gitweb:     http://git.kernel.org/tip/a456eaab87461e33d94e748565eabd474283a475
Author:     cpw@sgi.com <cpw@sgi.com>
AuthorDate: Tue, 21 Jun 2011 07:21:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Jun 2011 14:50:32 +0200

x86, UV: Rename hubmask to pnmask

Rename 'bau_targ_hubmask' to 'pnmask' for clarity.

The BAU distribution bit mask is indexed by pnode number, not hub or
blade number.  This important fact is not clear while the mask is
called a 'hubmask'.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20110621122242.630995969@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |   12 ++++++------
 arch/x86/platform/uv/tlb_uv.c    |    5 ++---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 605e613..fa6a48e 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
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
@@ -596,20 +596,20 @@ static inline void write_mmr_data_config(int pnode, unsigned long mr)
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
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 4b28e09..191ef28 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
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
@@ -384,7 +383,7 @@ static void reset_with_ipi(struct bau_targ_hubmask *distribution,
 	reset_args.sender = sender;
 	cpus_clear(mask);
 	/* find a single cpu for each uvhub in this distribution mask */
-	maskbits = sizeof(struct bau_targ_hubmask) * BITSPERBYTE;
+	maskbits = sizeof(struct pnmask) * BITSPERBYTE;
 	/* each bit is a pnode relative to the partition base pnode */
 	for (pnode = 0; pnode < maskbits; pnode++) {
 		int cpu;
