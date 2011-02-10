Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1BJTPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:15:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23934 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab1BJTPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:15:31 -0500
Date: Thu, 10 Feb 2011 20:14:20 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Milan Broz <mbroz@redhat.com>
cc: linux-kernel@vger.kernel.org, Alexander Kjeldaas <astor@fast.no>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: NULL deref in drivers/md/dm-crypt.c:crypt_convert()
In-Reply-To: <4D4F25A3.1090401@redhat.com>
Message-ID: <alpine.LNX.2.00.1102102004140.26035@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102062320230.13593@swampdragon.chaosbits.net> <4D4F25A3.1090401@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011, Milan Broz wrote:

> On 02/06/2011 11:31 PM, Jesper Juhl wrote:
> > The coverity checker found this. I don't know how to fix it, so I'll just 
> > report it and hope that someone else can address the issue.
> 
> Hi,
> can I see the plain output from the coverity check somewhere?
> 

If you have a coverity scan account it is CID 40766. But since you ask I 
assume you do not have an account, so I've also pasted the output from 
their web interface here :

Checker: FORWARD_NULL
Function: crypt_convert
File: /linux-2.6/drivers/md/dm-crypt.c
...
768  	static int crypt_convert(struct crypt_config *cc,
769  				 struct convert_context *ctx)
770  	{
771  		struct crypt_cpu *this_cc = this_crypt_config(cc);
772  		int r;
773  	
774  		atomic_set(&ctx->pending, 1);
775  	
At conditional (1): "ctx->idx_in < ctx->bio_in->bi_vcnt" taking true path
At conditional (2): "ctx->idx_out < ctx->bio_out->bi_vcnt" taking true path
776  		while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
777  		      ctx->idx_out < ctx->bio_out->bi_vcnt) {
778  	
779  			crypt_alloc_req(cc, ctx);
780  	
781  			atomic_inc(&ctx->pending);
782  	
Event var_deref_model: Passing null variable "this_cc->req" to function "crypt_convert_block", which dereferences it. [details]
783  			r = crypt_convert_block(cc, ctx, this_cc->req);
784  	
785  			switch (r) {
786  			/* async */
787  			case -EBUSY:
788  				wait_for_completion(&ctx->restart);
789  				INIT_COMPLETION(ctx->restart);
790  				/* fall through*/
791  			case -EINPROGRESS:
Event assign_zero: Assigning: "this_cc->req" = 0.
792  				this_cc->req = NULL;
793  				ctx->sector++;
794  				continue;
795  	
796  			/* sync */
797  			case 0:
798  				atomic_dec(&ctx->pending);
799  				ctx->sector++;
800  				cond_resched();
801  				continue;
802  	
803  			/* error */
804  			default:
805  				atomic_dec(&ctx->pending);
806  				return r;
807  			}
808  		}
809  	
810  		return 0;
811  	}
...

The "[details]" link above shows this info:

...
692  	static int crypt_convert_block(struct crypt_config *cc,
693  				       struct convert_context *ctx,
694  				       struct ablkcipher_request *req)
695  	{
696  		struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
697  		struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
698  		struct dm_crypt_request *dmreq;
699  		u8 *iv;
700  		int r = 0;
701  	
702  		dmreq = dmreq_of_req(cc, req);
703  		iv = iv_of_dmreq(cc, dmreq);
704  	
705  		dmreq->iv_sector = ctx->sector;
706  		dmreq->ctx = ctx;
707  		sg_init_table(&dmreq->sg_in, 1);
708  		sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
709  			    bv_in->bv_offset + ctx->offset_in);
710  	
711  		sg_init_table(&dmreq->sg_out, 1);
712  		sg_set_page(&dmreq->sg_out, bv_out->bv_page, 1 << SECTOR_SHIFT,
713  			    bv_out->bv_offset + ctx->offset_out);
714  	
715  		ctx->offset_in += 1 << SECTOR_SHIFT;
716  		if (ctx->offset_in >= bv_in->bv_len) {
717  			ctx->offset_in = 0;
718  			ctx->idx_in++;
719  		}
720  	
721  		ctx->offset_out += 1 << SECTOR_SHIFT;
722  		if (ctx->offset_out >= bv_out->bv_len) {
723  			ctx->offset_out = 0;
724  			ctx->idx_out++;
725  		}
726  	
727  		if (cc->iv_gen_ops) {
728  			r = cc->iv_gen_ops->generator(cc, iv, dmreq);
729  			if (r < 0)
730  				return r;
731  		}
732  	
Event deref_parm_in_call: Function "ablkcipher_request_set_crypt" dereferences parameter "req". [details]
733  		ablkcipher_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
734  					     1 << SECTOR_SHIFT, iv);
735  	
736  		if (bio_data_dir(ctx->bio_in) == WRITE)
737  			r = crypto_ablkcipher_encrypt(req);
738  		else
739  			r = crypto_ablkcipher_decrypt(req);
740  	
741  		if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
742  			r = cc->iv_gen_ops->post(cc, iv, dmreq);
743  	
744  		return r;
745  	}
...

And the second "[details]" link gives this:

...
713  	static inline void ablkcipher_request_set_crypt(
714  		struct ablkcipher_request *req,
715  		struct scatterlist *src, struct scatterlist *dst,
716  		unsigned int nbytes, void *iv)
717  	{
Event deref_parm: Directly dereferencing parameter "req".
718  		req->src = src;
719  		req->dst = dst;
720  		req->nbytes = nbytes;
721  		req->info = iv;
722  	}
...


> > 
> > In drivers/md/dm-crypt.c:crypt_convert() we have this code:
> > ...
> >   		while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
> >   		      ctx->idx_out < ctx->bio_out->bi_vcnt) {
> >   	
> >   			crypt_alloc_req(cc, ctx);
> 
> Here in crypt_alloc_req() you have:
> 
> 	struct crypt_cpu *this_cc = this_crypt_config(cc);
> 	if (!this_cc->req)
> 		this_cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
> 
> >   	
> >   			atomic_inc(&ctx->pending);
> >   	
> >   			r = crypt_convert_block(cc, ctx, this_cc->req);
> 
> this_cc is: struct crypt_cpu *this_cc = this_crypt_config(cc);
> and because it is always running on the same CPU, 
> this_cc->req cannot be NULL here, because it was allocated
> in crypt_alloc_req().
> 
> It is false positive here.
> 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

