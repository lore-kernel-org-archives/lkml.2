Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab2LFOjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:39:15 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:52705 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2LFOjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:39:14 -0500
From: Nicolas Schichan <nschichan@freebox.fr>
To: mgherzan@gmail.com, rmk+kernel@arm.linux.org.uk
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: net: bpf_jit_32: fix kzalloc gfp/size mismatch.
Date: Thu,  6 Dec 2012 15:38:31 +0100
Message-Id: <1354804718-1662-1-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Official prototype for kzalloc is:

void *kzalloc(size_t, gfp_t);

The ARM bpf_jit code was having the assumption that it was:

void *kzalloc(gfp_t, size);

This was resulting the use of some random GFP flags depending on the
size requested and some random overflows once the really needed size
was more than the value of GFP_KERNEL.

This bug was present since the original inclusion of bpf_jit for ARM
(ddecdfce: ARM: 7259/3: net: JIT compiler for packet filters).

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---
 arch/arm/net/bpf_jit_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index c641fb6..a64d349 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -845,7 +845,7 @@ void bpf_jit_compile(struct sk_filter *fp)
 	ctx.skf		= fp;
 	ctx.ret0_fp_idx = -1;
 
-	ctx.offsets = kzalloc(GFP_KERNEL, 4 * (ctx.skf->len + 1));
+	ctx.offsets = kzalloc(4 * (ctx.skf->len + 1), GFP_KERNEL);
 	if (ctx.offsets == NULL)
 		return;
 
@@ -864,7 +864,7 @@ void bpf_jit_compile(struct sk_filter *fp)
 
 	ctx.idx += ctx.imm_count;
 	if (ctx.imm_count) {
-		ctx.imms = kzalloc(GFP_KERNEL, 4 * ctx.imm_count);
+		ctx.imms = kzalloc(4 * ctx.imm_count, GFP_KERNEL);
 		if (ctx.imms == NULL)
 			goto out;
 	}
-- 
1.7.5.4

