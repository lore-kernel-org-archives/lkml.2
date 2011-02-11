Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab1BKVPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:15:54 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11121 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab1BKVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:15:53 -0500
Date: Fri, 11 Feb 2011 22:14:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, tadeusz.struk@intel.com
cc: Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Subject: RE: [PATCH](updated) rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey()..
In-Reply-To: <alpine.LNX.2.00.1102112204020.16994@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1102112211230.16994@swampdragon.chaosbits.net>
References: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com> <alpine.LNX.2.00.1102071922220.27796@swampdragon.chaosbits.net> <20110211142647.GA3920@ucw.cz> <DF7BB929B28FCF479E888E3D9F8D9E88F3E2E668@irsmsx502.ger.corp.intel.com>
 <alpine.LNX.2.00.1102111546310.13370@swampdragon.chaosbits.net> <alpine.LNX.2.00.1102112204020.16994@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Jesper Juhl wrote:

> On Fri, 11 Feb 2011, Jesper Juhl wrote:
> 
> > On Fri, 11 Feb 2011, Paoloni, Gabriele wrote:
> > 
> > > Well anyway I think that the return value of "ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL)" has to be changed from -EINVAL to -ENOMEM in case of failure. That is why would stay on the patch that Tadeusz proposed. Otherwise Juhl should send another one....
> > > 
> > I'll take a look again later this evening when I get home from work.
> > 
> Hopefully this takes care of all complaints and can actually get merged so 
> we can get the leak fixed (patch is against current cryptodev-2.6 tree).
> 
> 
> Fix up previous patch that failed to properly fix mem leak in 
> rfc4106_set_hash_subkey(). This add-on patch; fixes the leak. moves 
> kfree() out of the error path, returns -ENOMEM rather than -EINVAL when 
> ablkcipher_request_alloc() fails.
> 

And of course I just had to screw up and send the wrong diff. The one I 
sent does not compile and was a temporary file I imported into the mail by 
accident :-(
Below is the real patch - changelog above still applies - sorry about 
that.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 aesni-intel_glue.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e013552..e0e6340 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -874,19 +874,17 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 
 	ret = crypto_ablkcipher_setkey(ctr_tfm, key, key_len);
 	if (ret)
-		goto out;
+		goto out_free_ablkcipher;
 
+	ret = -ENOMEM;
 	req = ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL);
-	if (!req) {
-		ret = -EINVAL;
+	if (!req)
 		goto out_free_ablkcipher;
-	}
 
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
-	if (!req_data) {
-		ret = -ENOMEM;
+	if (!req_data)
 		goto out_free_request;
-	}
+
 	memset(req_data->iv, 0, sizeof(req_data->iv));
 
 	/* Clear the data in the hash sub key container to zero.*/
@@ -911,12 +909,11 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 		if (!ret)
 			ret = req_data->result.err;
 	}
+	kfree(req_data);
 out_free_request:
 	ablkcipher_request_free(req);
-	kfree(req_data);
 out_free_ablkcipher:
 	crypto_free_ablkcipher(ctr_tfm);
-out:
 	return ret;
 }
 
 
-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

