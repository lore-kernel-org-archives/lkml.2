Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2IQRiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:38:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:14196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab2IQRiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,437,1344236400"; 
   d="scan'208";a="193994549"
Subject: [patch] crypto, tcrypt: remove local_bh_disable/enable() around
 local_irq_disable/enable()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com
Date: Mon, 17 Sep 2012 10:37:26 -0700
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347903446.26695.269.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ran into this while looking at some new crypto code using FPU
hitting a WARN_ON_ONCE(!irq_fpu_usable()) in the kernel_fpu_begin()
on a x86 kernel that uses the new eagerfpu model. In short, current eagerfpu
changes return 0 for interrupted_kernel_fpu_idle() and the in_interrupt()
thinks it is in the interrupt context because of the local_bh_disable().
Thus resulting in the WARN_ON().

Remove the local_bh_disable/enable() calls around the existing
local_irq_disable/enable() calls. local_irq_disable/enable() already
disables the BH.

 [ If there are any other legitimate users calling kernel_fpu_begin() from
   the process context but with BH disabled, then we can look into fixing the
   irq_fpu_usable() in future. ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/tcrypt.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 5cf2ccb..de8c5d3 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -97,7 +97,6 @@ static int test_cipher_cycles(struct blkcipher_desc *desc, int enc,
 	int ret = 0;
 	int i;
 
-	local_bh_disable();
 	local_irq_disable();
 
 	/* Warm-up run. */
@@ -130,7 +129,6 @@ static int test_cipher_cycles(struct blkcipher_desc *desc, int enc,
 
 out:
 	local_irq_enable();
-	local_bh_enable();
 
 	if (ret == 0)
 		printk("1 operation in %lu cycles (%d bytes)\n",
@@ -300,7 +298,6 @@ static int test_hash_cycles_digest(struct hash_desc *desc,
 	int i;
 	int ret;
 
-	local_bh_disable();
 	local_irq_disable();
 
 	/* Warm-up run. */
@@ -327,7 +324,6 @@ static int test_hash_cycles_digest(struct hash_desc *desc,
 
 out:
 	local_irq_enable();
-	local_bh_enable();
 
 	if (ret)
 		return ret;
@@ -348,7 +344,6 @@ static int test_hash_cycles(struct hash_desc *desc, struct scatterlist *sg,
 	if (plen == blen)
 		return test_hash_cycles_digest(desc, sg, blen, out);
 
-	local_bh_disable();
 	local_irq_disable();
 
 	/* Warm-up run. */
@@ -391,7 +386,6 @@ static int test_hash_cycles(struct hash_desc *desc, struct scatterlist *sg,
 
 out:
 	local_irq_enable();
-	local_bh_enable();
 
 	if (ret)
 		return ret;


