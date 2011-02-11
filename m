Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab1BKKDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:03:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab1BKKDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:03:16 -0500
Message-ID: <4D550913.5060508@redhat.com>
Date: Fri, 11 Feb 2011 11:01:55 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, Alexander Kjeldaas <astor@fast.no>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: NULL deref in drivers/md/dm-crypt.c:crypt_convert()
References: <alpine.LNX.2.00.1102062320230.13593@swampdragon.chaosbits.net> <4D4F25A3.1090401@redhat.com> <alpine.LNX.2.00.1102102004140.26035@swampdragon.chaosbits.net> <4D54E753.9090906@redhat.com> <alpine.LNX.2.00.1102111020260.13370@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102111020260.13370@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 10:26 AM, Jesper Juhl wrote:
> On Fri, 11 Feb 2011, Milan Broz wrote:
> But, is that really where it says the problem is? That's not how I read 
> it.
>
> The problem is the second time through the while loop, not the first :
> ...
> 776             while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
> 777                   ctx->idx_out < ctx->bio_out->bi_vcnt) {
> 778
> 779                     crypt_alloc_req(cc, ctx);
> 780
> 781                     atomic_inc(&ctx->pending);
> 782
> 783                     r = crypt_convert_block(cc, ctx, this_cc->req);
>
> first time through the loop this is fine, but if we then subsequently hit 
> the -EINPROGRESS case in the switch below we'll explictly assign NULL to 
> this_cc->req and the the 'continue' ensures that we do one more trip 
> around the loop and on that second pass we pass a NULL this_cc->req to 
> crypt_convert_block()
>
Sigh. Did you read my first email? It is false positive.

this_cc->req is allocated in crypt_alloc_req(cc, ctx);

this_cc is simple per cpu struct, common in both functions.

The code here tries to simply support both sync and async cryptAPI operation.

In sync, we can reuse this_cc->req immediately (this is common case).

In async mode (returns EBUSY, EINPROGRESS) we must not use it again (because it is
still processing) so we explicitly set it here to NULL and in the NEXT iteration
crypt_alloc_req(cc, ctx) allocates new this_cc->req from pool.

crypt_alloc_req can probably take this_cc as argument directly and not calculate
it again, but compiler will inline and optimise the code anyway.

You can easily test async path, just apply in crypt_ctr and use some crypt mapping
-                      "%s(%s)", chainmode, cipher);                                                                                       
+                      "cryptd(%s(%s-generic))", chainmode, cipher);                                                                       

To make coverity happy, see patch below.
-
Tidy code to reuse per cpu pointer

Signed-off-by: Milan Broz <mbroz@redhat.com>
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ad2a6df..a2312e3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -748,9 +748,9 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error);
 
 static void crypt_alloc_req(struct crypt_config *cc,
-			    struct convert_context *ctx)
+			    struct convert_context *ctx,
+			    struct crypt_cpu *this_cc)
 {
-	struct crypt_cpu *this_cc = this_crypt_config(cc);
 	unsigned key_index = ctx->sector & (cc->tfms_count - 1);
 
 	if (!this_cc->req)
@@ -776,7 +776,7 @@ static int crypt_convert(struct crypt_config *cc,
 	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
 	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
 
-		crypt_alloc_req(cc, ctx);
+		crypt_alloc_req(cc, ctx, this_cc);
 
 		atomic_inc(&ctx->pending);
 

Milan


