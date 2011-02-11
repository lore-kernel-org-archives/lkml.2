Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab1BKLF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 06:05:58 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21308 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab1BKLF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 06:05:57 -0500
Date: Fri, 11 Feb 2011 12:04:48 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Milan Broz <mbroz@redhat.com>
cc: linux-kernel@vger.kernel.org, Alexander Kjeldaas <astor@fast.no>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: NULL deref in drivers/md/dm-crypt.c:crypt_convert()
In-Reply-To: <4D550913.5060508@redhat.com>
Message-ID: <alpine.LNX.2.00.1102111203140.13370@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102062320230.13593@swampdragon.chaosbits.net> <4D4F25A3.1090401@redhat.com> <alpine.LNX.2.00.1102102004140.26035@swampdragon.chaosbits.net> <4D54E753.9090906@redhat.com> <alpine.LNX.2.00.1102111020260.13370@swampdragon.chaosbits.net>
 <4D550913.5060508@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Milan Broz wrote:

> On 02/11/2011 10:26 AM, Jesper Juhl wrote:
> > On Fri, 11 Feb 2011, Milan Broz wrote:
> > But, is that really where it says the problem is? That's not how I read 
> > it.
> >
> > The problem is the second time through the while loop, not the first :
> > ...
> > 776             while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
> > 777                   ctx->idx_out < ctx->bio_out->bi_vcnt) {
> > 778
> > 779                     crypt_alloc_req(cc, ctx);
> > 780
> > 781                     atomic_inc(&ctx->pending);
> > 782
> > 783                     r = crypt_convert_block(cc, ctx, this_cc->req);
> >
> > first time through the loop this is fine, but if we then subsequently hit 
> > the -EINPROGRESS case in the switch below we'll explictly assign NULL to 
> > this_cc->req and the the 'continue' ensures that we do one more trip 
> > around the loop and on that second pass we pass a NULL this_cc->req to 
> > crypt_convert_block()
> >
> Sigh. Did you read my first email? It is false positive.
> 
Read it. Obviously misunderstood it. :-(


> this_cc->req is allocated in crypt_alloc_req(cc, ctx);
> 
> this_cc is simple per cpu struct, common in both functions.
> 
> The code here tries to simply support both sync and async cryptAPI operation.
> 
> In sync, we can reuse this_cc->req immediately (this is common case).
> 
> In async mode (returns EBUSY, EINPROGRESS) we must not use it again (because it is
> still processing) so we explicitly set it here to NULL and in the NEXT iteration
> crypt_alloc_req(cc, ctx) allocates new this_cc->req from pool.
> 
> crypt_alloc_req can probably take this_cc as argument directly and not calculate
> it again, but compiler will inline and optimise the code anyway.
> 
> You can easily test async path, just apply in crypt_ctr and use some crypt mapping
> -                      "%s(%s)", chainmode, cipher);                                                                                       
> +                      "cryptd(%s(%s-generic))", chainmode, cipher);                                                                       
> 
> To make coverity happy, see patch below.

Thank you for patient explanation.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

