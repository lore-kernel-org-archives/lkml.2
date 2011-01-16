Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1APOiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 09:38:51 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13516 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1APOit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 09:38:49 -0500
Date: Sun, 16 Jan 2011 15:38:47 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-crypto@vger.kernel.org
cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Huang Ying <ying.huang@intel.com>,
        Adrian Hoban <adrian.hoban@intel.com>,
        Gabriele Paoloni <gabriele.paoloni@intel.com>,
        aidan.o.mahony@intel.com
Subject: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
Message-ID: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a small memory leak in 
arch/x86/crypto/aesni-intel_glue.c::rfc4106_set_hash_subkey(). If the call 
to kmalloc() fails and returns NULL then the memory allocated previously 
by ablkcipher_request_alloc() is not freed when we leave the function.

I could have just added a call to ablkcipher_request_free() before we 
return -ENOMEM, but that started to look too much like the code we 
already had at the end of the function, so I chose instead to rework the 
code a bit so that there are now a few labels at the end that we goto when 
various allocations fail, so we don't have to repeat the same blocks of 
code (this also reduces the object code size slightly).

Please review and consider merging.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 aesni-intel_glue.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

  compile tested only.

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e1e60c7..e013552 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -873,21 +873,19 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 	crypto_ablkcipher_clear_flags(ctr_tfm, ~0);
 
 	ret = crypto_ablkcipher_setkey(ctr_tfm, key, key_len);
-	if (ret) {
-		crypto_free_ablkcipher(ctr_tfm);
-		return ret;
-	}
+	if (ret)
+		goto out;
 
 	req = ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL);
 	if (!req) {
-		crypto_free_ablkcipher(ctr_tfm);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_free_ablkcipher;
 	}
 
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data) {
-		crypto_free_ablkcipher(ctr_tfm);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free_request;
 	}
 	memset(req_data->iv, 0, sizeof(req_data->iv));
 
@@ -913,9 +911,12 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 		if (!ret)
 			ret = req_data->result.err;
 	}
+out_free_request:
 	ablkcipher_request_free(req);
 	kfree(req_data);
+out_free_ablkcipher:
 	crypto_free_ablkcipher(ctr_tfm);
+out:
 	return ret;
 }
 


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

