Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1BFWvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:51:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab1BFWvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:51:35 -0500
Message-ID: <4D4F25A3.1090401@redhat.com>
Date: Sun, 06 Feb 2011 23:50:11 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, Alexander Kjeldaas <astor@fast.no>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: NULL deref in drivers/md/dm-crypt.c:crypt_convert()
References: <alpine.LNX.2.00.1102062320230.13593@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102062320230.13593@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2011 11:31 PM, Jesper Juhl wrote:
> The coverity checker found this. I don't know how to fix it, so I'll just 
> report it and hope that someone else can address the issue.

Hi,
can I see the plain output from the coverity check somewhere?

> 
> In drivers/md/dm-crypt.c:crypt_convert() we have this code:
> ...
>   		while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
>   		      ctx->idx_out < ctx->bio_out->bi_vcnt) {
>   	
>   			crypt_alloc_req(cc, ctx);

Here in crypt_alloc_req() you have:

	struct crypt_cpu *this_cc = this_crypt_config(cc);
	if (!this_cc->req)
		this_cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);

>   	
>   			atomic_inc(&ctx->pending);
>   	
>   			r = crypt_convert_block(cc, ctx, this_cc->req);

this_cc is: struct crypt_cpu *this_cc = this_crypt_config(cc);
and because it is always running on the same CPU, 
this_cc->req cannot be NULL here, because it was allocated
in crypt_alloc_req().

It is false positive here.

Milan
