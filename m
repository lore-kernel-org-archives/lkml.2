Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0KHXYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:24:17 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19005 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0KHXTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:19:38 -0500
Date: Tue, 9 Nov 2010 00:08:11 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, amd64-microcode@amd64.org, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 02/17][trivial] x86: Remove unnecessary casts of void ptr
 returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082310220.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from arch/x86


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 kernel/microcode_amd.c |    2 +-
 platform/uv/tlb_uv.c   |   13 ++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e1af7c0..ce0cb47 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -212,7 +212,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 		return 0;
 	}
 
-	equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
+	equiv_cpu_table = vmalloc(size);
 	if (!equiv_cpu_table) {
 		pr_err("failed to allocate equivalent CPU table\n");
 		return 0;
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 20ea20a..a318194 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1343,8 +1343,8 @@ uv_activation_descriptor_init(int node, int pnode)
 	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
 	 * per cpu; and up to 32 (UV_ADP_SIZE) cpu's per uvhub
 	 */
-	bau_desc = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
-		UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
+	bau_desc = kmalloc_node(sizeof(struct bau_desc) * UV_ADP_SIZE
+				* UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
 	BUG_ON(!bau_desc);
 
 	pa = uv_gpa(bau_desc); /* need the real nasid*/
@@ -1402,9 +1402,9 @@ uv_payload_queue_init(int node, int pnode)
 	struct bau_payload_queue_entry *pqp_malloc;
 	struct bau_control *bcp;
 
-	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
-		(DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry),
-		GFP_KERNEL, node);
+	pqp = kmalloc_node((DEST_Q_SIZE + 1)
+			   * sizeof(struct bau_payload_queue_entry),
+			   GFP_KERNEL, node);
 	BUG_ON(!pqp);
 	pqp_malloc = pqp;
 
@@ -1520,8 +1520,7 @@ static void __init uv_init_per_cpu(int nuvhubs)
 
 	timeout_us = calculate_destination_timeout();
 
-	uvhub_descs = (struct uvhub_desc *)
-		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
+	uvhub_descs = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 	for_each_present_cpu(cpu) {



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

