Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1BFTol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:44:41 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21396 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1BFToj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:44:39 -0500
Date: Sun, 6 Feb 2011 20:43:22 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Struk, Tadeusz" <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>
Subject: RE: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
In-Reply-To: <24483BA4C9F69C43A7379639D35543D7C5398DB6@irsmsx502.ger.corp.intel.com>
Message-ID: <alpine.LNX.2.00.1102062039080.13593@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net> <24483BA4C9F69C43A7379639D35543D7C5398DB6@irsmsx502.ger.corp.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011, Struk, Tadeusz wrote:

> Hi Jesper,

Hi Tadeusz,

> We have tested your changes and all is fine.
> Thank you for identifying this issue.

You are welcome. But I believe I made a mistake in that patch. I looked at 
it again and I'm convinced that the 'out' label should not exist. The 
jump to it will still leak 'ctr_tfm' - don't you agree?

I believe the patch should look like this instead:


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 aesni-intel_glue.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e1e60c7..4a8c015 100644
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
+		goto out_free_ablkcipher;
 
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
 
@@ -913,8 +911,10 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 		if (!ret)
 			ret = req_data->result.err;
 	}
+out_free_request:
 	ablkcipher_request_free(req);
 	kfree(req_data);
+out_free_ablkcipher:
 	crypto_free_ablkcipher(ctr_tfm);
 	return ret;
 }


Herbert: If Tadeusz agrees, could you please replace the patch you merged 
with the one above?

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

