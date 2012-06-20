Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2FTJVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2FTJVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:21:14 -0400
From: Laszlo Ersek <lersek@redhat.com>
To: linux-kernel@vger.kernel.org, lersek@redhat.com
Subject: [PATCH] allow padlock module to load without xcrypt support
Date: Wed, 20 Jun 2012 11:22:19 +0200
Message-Id: <1340184139-6718-1-git-send-email-lersek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lack of (enabled) hardware is arguably not a module initialization error,
thus it should not cause problems during the boot process.

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
Please CC me on any comments. Thanks.

 drivers/crypto/padlock-aes.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 37b2e94..a42a308 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -516,11 +516,11 @@ static int __init padlock_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 
 	if (!x86_match_cpu(padlock_cpu_id))
-		return -ENODEV;
+		return 0;
 
 	if (!cpu_has_xcrypt_enabled) {
 		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
-		return -ENODEV;
+		return 0;
 	}
 
 	if ((ret = crypto_register_alg(&aes_alg)))
@@ -554,6 +554,9 @@ aes_err:
 
 static void __exit padlock_fini(void)
 {
+	if (!x86_match_cpu(padlock_cpu_id) || !cpu_has_xcrypt_enabled)
+		return;
+
 	crypto_unregister_alg(&cbc_aes_alg);
 	crypto_unregister_alg(&ecb_aes_alg);
 	crypto_unregister_alg(&aes_alg);
-- 
1.7.1

