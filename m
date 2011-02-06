Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1BFVet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:34:49 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22795 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1BFVer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:34:47 -0500
Date: Sun, 6 Feb 2011 22:33:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: "Struk, Tadeusz" <tadeusz.struk@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
In-Reply-To: <20110206204829.GA12652@gondor.apana.org.au>
Message-ID: <alpine.LNX.2.00.1102062231530.13593@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net> <24483BA4C9F69C43A7379639D35543D7C5398DB6@irsmsx502.ger.corp.intel.com> <alpine.LNX.2.00.1102062039080.13593@swampdragon.chaosbits.net> <20110206203408.GA12426@gondor.apana.org.au>
 <alpine.LNX.2.00.1102062134150.13593@swampdragon.chaosbits.net> <20110206204829.GA12652@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Herbert Xu wrote:

> On Sun, Feb 06, 2011 at 09:34:33PM +0100, Jesper Juhl wrote:
> > On Mon, 7 Feb 2011, Herbert Xu wrote:
> > 
> > > On Sun, Feb 06, 2011 at 08:43:22PM +0100, Jesper Juhl wrote:
> > > > 
> > > > Herbert: If Tadeusz agrees, could you please replace the patch you merged 
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

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 aesni-intel_glue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git 
a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e013552..4a8c015 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -874,7 +874,7 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 
 	ret = crypto_ablkcipher_setkey(ctr_tfm, key, key_len);
 	if (ret)
-		goto out;
+		goto out_free_ablkcipher;
 
 	req = ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL);
 	if (!req) {
@@ -916,7 +916,6 @@ out_free_request:
 	kfree(req_data);
 out_free_ablkcipher:
 	crypto_free_ablkcipher(ctr_tfm);
-out:
 	return ret;
 }
 
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

