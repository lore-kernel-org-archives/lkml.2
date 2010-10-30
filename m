Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0J3TDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:03:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29709 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0J3TDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:03:04 -0400
Date: Sat, 30 Oct 2010 20:52:47 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Cliff Wickman <cpw@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH] SGI UltraViolet: Prefer kzalloc over kmalloc and memset and
 remove a pointless cast
Message-ID: <alpine.LNX.2.00.1010302036450.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Using kzalloc() instead of kmalloc()+memset() carries no downsides that I 
can see, but it results in smaller (and presumably slightly faster) code.
There are two places in arch/x86/platform/uv/ that I've found where we can 
make this improvement - patch below.
I also removed the cast of the kzalloc() return value since it returns a 
void* so the cast is pointless.

It compiles, but I have no way to test it further than that.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 tlb_uv.c  |    4 +---
 uv_time.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 20ea20a..f5b0258 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1520,9 +1520,7 @@ static void __init uv_init_per_cpu(int nuvhubs)
 
 	timeout_us = calculate_destination_timeout();
 
-	uvhub_descs = (struct uvhub_desc *)
-		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
-	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+	uvhub_descs = kzalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 56e421b..523975c 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -149,10 +149,9 @@ static __init int uv_rtc_allocate_timers(void)
 {
 	int cpu;
 
-	blade_info = kmalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
+	blade_info = kzalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
 	if (!blade_info)
 		return -ENOMEM;
-	memset(blade_info, 0, uv_possible_blades * sizeof(void *));
 
 	for_each_present_cpu(cpu) {
 		int nid = cpu_to_node(cpu);


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

