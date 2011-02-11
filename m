Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab1BKJ1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:27:34 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20347 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab1BKJ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:27:31 -0500
Date: Fri, 11 Feb 2011 10:26:22 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Milan Broz <mbroz@redhat.com>
cc: linux-kernel@vger.kernel.org, Alexander Kjeldaas <astor@fast.no>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: NULL deref in drivers/md/dm-crypt.c:crypt_convert()
In-Reply-To: <4D54E753.9090906@redhat.com>
Message-ID: <alpine.LNX.2.00.1102111020260.13370@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102062320230.13593@swampdragon.chaosbits.net> <4D4F25A3.1090401@redhat.com> <alpine.LNX.2.00.1102102004140.26035@swampdragon.chaosbits.net> <4D54E753.9090906@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Milan Broz wrote:

> On 02/10/2011 08:14 PM, Jesper Juhl wrote:
> > On Sun, 6 Feb 2011, Milan Broz wrote:
> > 
> > If you have a coverity scan account it is CID 40766. But since you ask I 
> > assume you do not have an account, so I've also pasted the output from 
> > their web interface here :
> 
> Thanks.
> 
> I would say that the checker has problem to follow per cpu pointers...
> 
> In this case
> static struct crypt_cpu *this_crypt_config(struct crypt_config *cc)
> {
>         return this_cpu_ptr(cc->cpu);
> 
> Otherwise it must see that the struct is allocated in
> crypt_alloc_req(cc, ctx);
> 
> And mempool allocation should never return NULL here.
> 

But, is that really where it says the problem is? That's not how I read 
it.

The problem is the second time through the while loop, not the first :
...
776             while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
777                   ctx->idx_out < ctx->bio_out->bi_vcnt) {
778
779                     crypt_alloc_req(cc, ctx);
780
781                     atomic_inc(&ctx->pending);
782
783                     r = crypt_convert_block(cc, ctx, this_cc->req);

first time through the loop this is fine, but if we then subsequently hit 
the -EINPROGRESS case in the switch below we'll explictly assign NULL to 
this_cc->req and the the 'continue' ensures that we do one more trip 
around the loop and on that second pass we pass a NULL this_cc->req to 
crypt_convert_block()

784
785                     switch (r) {
786                     /* async */
787                     case -EBUSY:
788                             wait_for_completion(&ctx->restart);
789                             INIT_COMPLETION(ctx->restart);
790                             /* fall through*/
791                     case -EINPROGRESS:
792                             this_cc->req = NULL;
793                             ctx->sector++;
794                             continue;
...





-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

