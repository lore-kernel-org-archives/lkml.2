Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2DDNGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:06:23 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48339 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2DDNGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:06:22 -0400
From: Borislav Petkov <bp@amd64.org>
To: linux-crypto@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH] crypto, xor: Sanitize checksumming function selection output
Date: Wed,  4 Apr 2012 15:06:10 +0200
Message-Id: <1333544770-21303-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Currently, it says

[    1.015541] xor: automatically using best checksumming function: generic_sse
[    1.040769]    generic_sse:  6679.000 MB/sec
[    1.045377] xor: using function: generic_sse (6679.000 MB/sec)

and repeats the function name three times unnecessarily. Change it into

[    1.015115] xor: automatically using best checksumming function:
[    1.040794]    generic_sse:  6680.000 MB/sec

and save us a line in dmesg.

No functional change.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 crypto/xor.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index b75182d8ab14..664b6dfa9e2c 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -129,9 +129,9 @@ calibrate_xor_blocks(void)
 
 	if (fastest) {
 		printk(KERN_INFO "xor: automatically using best "
-			"checksumming function: %s\n",
-			fastest->name);
+				 "checksumming function:\n");
 		xor_speed(fastest);
+		goto out;
 	} else {
 		printk(KERN_INFO "xor: measuring software checksum speed\n");
 		XOR_TRY_TEMPLATES;
@@ -146,6 +146,7 @@ calibrate_xor_blocks(void)
 
 #undef xor_speed
 
+ out:
 	free_pages((unsigned long)b1, 2);
 
 	active_template = fastest;
-- 
1.7.9.3.362.g71319

