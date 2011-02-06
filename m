Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1BFWca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:32:30 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23472 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1BFWc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:32:29 -0500
Date: Sun, 6 Feb 2011 23:31:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Alexander Kjeldaas <astor@fast.no>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: NULL deref in drivers/md/dm-crypt.c:crypt_convert()
Message-ID: <alpine.LNX.2.00.1102062320230.13593@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The coverity checker found this. I don't know how to fix it, so I'll just 
report it and hope that someone else can address the issue.

In drivers/md/dm-crypt.c:crypt_convert() we have this code:
...
  		while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
  		      ctx->idx_out < ctx->bio_out->bi_vcnt) {
  	
  			crypt_alloc_req(cc, ctx);
  	
  			atomic_inc(&ctx->pending);
  	
  			r = crypt_convert_block(cc, ctx, this_cc->req);
  	
  			switch (r) {
  			/* async */
 			case -EBUSY:
  				wait_for_completion(&ctx->restart);
  				INIT_COMPLETION(ctx->restart);
  				/* fall through*/
  			case -EINPROGRESS:
  				this_cc->req = NULL;
  				ctx->sector++;
  				continue;
...

If we take the first pass through the 'while' loop and hit the 
'-EINPROGRESS' case of the switch, then the second time around we'll pass 
a NULL 'this_cc->req' to 'crypt_convert_block()'. 'crypt_convert_block()' 
passes the pointer to 'ablkcipher_request_set_crypt()' which dereferences
it:
...
  	static inline void ablkcipher_request_set_crypt(
  		struct ablkcipher_request *req,
  		struct scatterlist *src, struct scatterlist *dst,
  		unsigned int nbytes, void *iv)
  	{
  		req->src = src;
...

That's going to go "BOOM" - definately no what we want, so we need a fix 
somehow...

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

