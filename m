Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab1ITTxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:53:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51093 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1ITTxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:53:35 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Arnaud Lacombe <lacombar@gmail.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH v1 3/4] encrypted-keys: check hex2bin result
Date: Tue, 20 Sep 2011 15:52:52 -0400
Message-Id: <1316548373-8782-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each hex2bin call in encrypted keys, check that the ascii hex string
is valid.  On failure, return -EINVAL.

Changelog v1:
- hex2bin now returns an int

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/keys/encrypted-keys/encrypted.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 3f57795..f33804c 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -667,11 +667,19 @@ static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
 		return -EINVAL;
 
 	hex_encoded_data = hex_encoded_iv + (2 * ivsize) + 2;
-	hex2bin(epayload->iv, hex_encoded_iv, ivsize);
-	hex2bin(epayload->encrypted_data, hex_encoded_data, encrypted_datalen);
+	ret = hex2bin(epayload->iv, hex_encoded_iv, ivsize);
+	if (ret < 0)
+		return -EINVAL;
+	ret = hex2bin(epayload->encrypted_data, hex_encoded_data,
+		      encrypted_datalen);
+	if (ret < 0)
+		return -EINVAL;
 
 	hmac = epayload->format + epayload->datablob_len;
-	hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2), HASH_SIZE);
+	ret = hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2),
+		      HASH_SIZE);
+	if (ret < 0)
+		return -EINVAL;
 
 	mkey = request_master_key(epayload, &master_key, &master_keylen);
 	if (IS_ERR(mkey))
-- 
1.7.3.4

