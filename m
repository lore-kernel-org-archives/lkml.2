Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1BGRdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:33:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:46670 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab1BGRdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="704942808"
Date: Mon, 07 Feb 2011 17:32:59 +0000
From: tadeusz.struk@intel.com
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
        adrian.hoban@intel.com, tadeusz.struk@intel.com, jj@chaosbits.net
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
Message-ID: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: 
Date: Sun, 16 Jan 2011 16:41:11 +0000
Subject: RE: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in rfc4106_set_hash_subkey().

Hi Jesper,
Thanks, but I think there is still a problem here. You don't want to kfree req_data
when the kmalloc failed. I think it should look as follows.  
Are you ok with this?

On Mon, 7 Feb 2011, Herbert Xu wrote:

> On Sun, Feb 06, 2011 at 09:34:33PM +0100, Jesper Juhl wrote:
> > On Mon, 7 Feb 2011, Herbert Xu wrote:
> > 
> > > On Sun, Feb 06, 2011 at 08:43:22PM +0100, Jesper Juhl wrote:
> > > > 
> > > > Herbert: If Tadeusz agrees, could you please replace the patch
> > > > you merged 
> > > > with the one above?
> > > 
> > > Please send an incremental patch.
> > > 
> > Sure thing. What would you like it based on exactly?
> 
> The current cryptodev-2.6 tree should do.
> 
Here goes.

Fix up previous patch that attempted to fix a mem leak in 
rfc4106_set_hash_subkey. The previous patch was flawed in that the 'goto 
out' would still leak.

---
 arch/x86/crypto/aesni-intel_glue.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e013552..c9f0227 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -874,11 +874,11 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 
 	ret = crypto_ablkcipher_setkey(ctr_tfm, key, key_len);
 	if (ret)
-		goto out;
+		goto out_free_ablkcipher;
 
 	req = ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL);
 	if (!req) {
-		ret = -EINVAL;
+		ret = -ENOMEM;
 		goto out_free_ablkcipher;
 	}
 
@@ -911,12 +911,11 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
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
1.7.4

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


