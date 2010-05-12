Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0ELJxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:53:37 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49590 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab0ELJxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:53:32 -0400
Date: Wed, 12 May 2010 10:56:38 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       ", H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] arch/x86/kernel: Drop memory allocation cast
In-Reply-To: <Pine.LNX.4.64.1005121021110.31474@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1005121056240.31474@ask.diku.dk>
References: <Pine.LNX.4.64.1005112028160.4330@ask.diku.dk> <4BEA58C6.7030103@bfs.de>
 <Pine.LNX.4.64.1005121021110.31474@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Drop cast on the result of kmalloc and similar functions.
The third occurrence is additionally modified by hand to use kcalloc and to
check that the result of the allocation is not NULL.

The semantic patch that makes the drop cast change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
@@

- (T *)
  (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
   kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/x86/kernel/tlb_uv.c            |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 7fea555..97e790c 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -1141,7 +1141,7 @@ uv_activation_descriptor_init(int node, int pnode)
 	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
 	 * per cpu; and up to 32 (UV_ADP_SIZE) cpu's per uvhub
 	 */
-	bau_desc = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
+	bau_desc = kmalloc_node(sizeof(struct bau_desc) *
 		UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
 	BUG_ON(!bau_desc);
 
@@ -1200,7 +1200,7 @@ uv_payload_queue_init(int node, int pnode)
 	struct bau_payload_queue_entry *pqp_malloc;
 	struct bau_control *bcp;
 
-	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
+	pqp = kmalloc_node(
 		(DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry),
 		GFP_KERNEL, node);
 	BUG_ON(!pqp);
@@ -1286,9 +1286,8 @@ static void uv_init_per_cpu(int nuvhubs)
 	};
 	struct uvhub_desc *uvhub_descs;
 
-	uvhub_descs = (struct uvhub_desc *)
-		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
-	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+	uvhub_descs = kcalloc(nuvhubs, sizeof(struct uvhub_desc), GFP_KERNEL);
+	BUG_ON(!uvhub_descs);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
