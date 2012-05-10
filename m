Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab2EJOba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:31:30 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56051 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2EJOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 6/9] x86, MCE, AMD: Cleanup reading of error_count
Date: Thu, 10 May 2012 16:30:26 +0200
Message-Id: <1336660229-32644-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

We have rdmsr_on_cpu() now so remove locally defined solution in favor
of the generic one.

No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 0b1bb0e15881..a7204ef37223 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -359,27 +359,14 @@ store_threshold_limit(struct threshold_block *b, const char *buf, size_t size)
 	return size;
 }
 
-struct threshold_block_cross_cpu {
-	struct threshold_block	*tb;
-	long			retval;
-};
-
-static void local_error_count_handler(void *_tbcc)
-{
-	struct threshold_block_cross_cpu *tbcc = _tbcc;
-	struct threshold_block *b = tbcc->tb;
-	u32 low, high;
-
-	rdmsr(b->address, low, high);
-	tbcc->retval = (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
-}
-
 static ssize_t show_error_count(struct threshold_block *b, char *buf)
 {
-	struct threshold_block_cross_cpu tbcc = { .tb = b, };
+	u32 lo, hi;
+
+	rdmsr_on_cpu(b->cpu, b->address, &lo, &hi);
 
-	smp_call_function_single(b->cpu, local_error_count_handler, &tbcc, 1);
-	return sprintf(buf, "%lu\n", tbcc.retval);
+	return sprintf(buf, "%u\n", ((hi & THRESHOLD_MAX) -
+				     (THRESHOLD_MAX - b->threshold_limit)));
 }
 
 static ssize_t store_error_count(struct threshold_block *b,
-- 
1.7.9.3.362.g71319

