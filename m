Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1ASQCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:02:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:49071 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab1ASQCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:02:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,345,1291622400"; 
   d="scan'208";a="878937591"
From: "Struk, Tadeusz" <tadeusz.struk@intel.com>
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>
Date: Wed, 19 Jan 2011 16:02:46 +0000
Subject: RE: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
Thread-Topic: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
Thread-Index: Acu1ixwl2NePExY1ROuehvw1T8vI3ACZpL9g
Message-ID: <24483BA4C9F69C43A7379639D35543D7C5398DB6@irsmsx502.ger.corp.intel.com>
References: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,
We have tested your changes and all is fine.
Thank you for identifying this issue.
Regards,
Tadeusz

-----Original Message-----
From: Jesper Juhl [mailto:jj@chaosbits.net] 
Sent: Sunday, January 16, 2011 2:39 PM
To: linux-crypto@vger.kernel.org
Cc: Struk, Tadeusz; linux-kernel@vger.kernel.org; x86@kernel.org; H. Peter Anvin; Ingo Molnar; Thomas Gleixner; David S. Miller; Herbert Xu; Huang, Ying; Hoban, Adrian; Paoloni, Gabriele; O Mahony, Aidan
Subject: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in rfc4106_set_hash_subkey().

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

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


