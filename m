Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1IPMvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:51:10 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44166 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab1IPMuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:50:52 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 4/5] encrypted-keys: check hex2bin result
Date: Fri, 16 Sep 2011 08:50:29 -0400
Message-Id: <1316177430-13167-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

For each hex2bin call in encrypted keys, check that the ascii hex string
is valid.  On failure, return -EINVAL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/keys/encrypted-keys/encrypted.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 3f57795..cd654d9 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -667,11 +667,16 @@ static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
 		return -EINVAL;
 
 	hex_encoded_data = hex_encoded_iv + (2 * ivsize) + 2;
-	hex2bin(epayload->iv, hex_encoded_iv, ivsize);
-	hex2bin(epayload->encrypted_data, hex_encoded_data, encrypted_datalen);
+	if (!hex2bin(epayload->iv, hex_encoded_iv, ivsize))
+		return -EINVAL;
+	if (!hex2bin(epayload->encrypted_data, hex_encoded_data,
+		     encrypted_datalen))
+		return -EINVAL;
 
 	hmac = epayload->format + epayload->datablob_len;
-	hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2), HASH_SIZE);
+	if (!hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2),
+		     HASH_SIZE))
+		return -EINVAL;
 
 	mkey = request_master_key(epayload, &master_key, &master_keylen);
 	if (IS_ERR(mkey))
-- 
1.7.3.4

