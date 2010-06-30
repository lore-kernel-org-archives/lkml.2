Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0F3Lvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:51:46 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:55828 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab0F3Lvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 07:51:42 -0400
Date: Wed, 30 Jun 2010 13:52:59 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <kruchinin@altell.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/2] padata: Separate cpumasks for cb_cpus and parallel
 workers
Message-ID: <20100630115259.GC10072@secunet.com>
References: <20100629203415.01c953e4@leibniz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629203415.01c953e4@leibniz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Jun 2010 11:51:29.0770 (UTC) FILETIME=[93DEF4A0:01CB184A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I like the idea to have separate cpumasks for parallel and
serial workers. I had not yet time to test your patches, but
I'll do so as soon as possible. I've added some comments to
your patch below.


On Tue, Jun 29, 2010 at 08:34:15PM +0400, Dan Kruchinin wrote:
> 1) Two separate cpumasks for parallel and serial workers
> 2) padata_alloc does not takes cpumask as its argument, instead
> it uses a default one. __padata_alloc takes two cpumasks as its
> arguments: one for parallel workers and another one for serial.
> 3) I made padata_cpu_hash a public function to reduce code size(in
> several places in pcrypt.c there is near the same code(for getting cpu
> hash) as in padata_cpu_hash)

Please add a Signed-off-by line to your patches.

[snip]

>  static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
>  {
> -	int cpu, cpu_index;
>  	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
> -	struct pcrypt_instance_ctx *ictx = crypto_instance_ctx(inst);
>  	struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
>  	struct crypto_aead *cipher;
>  
> -	ictx->tfm_count++;
> -
> -	cpu_index = ictx->tfm_count % cpumask_weight(cpu_active_mask);
> -
> -	ctx->cb_cpu = cpumask_first(cpu_active_mask);
> -	for (cpu = 0; cpu < cpu_index; cpu++)
> -		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_active_mask);
> -
> +	ctx->tfm_count++;

Having a transformation count on the transformation context itself
does not make too much sense. pcrypt_aead_init_tfm() is called once
for each transformation, so all transformations have a count of one.
The transformation count has to stay at the instance context.

[snip]

>  
>  	/*
> -	 * The next object that needs serialization might have arrived to
> -	 * the reorder queues in the meantime, we will be called again
> -	 * from the timer function if noone else cares for it.
> -	 */
> +     * The next object that needs serialization might have arrived to
> +     * the reorder queues in the meantime, we will be called again
> +     * from the timer function if noone else cares for it.
> +     */

You replaced the tabs by some whitespaces in the lines above,
this changed the code indent of some lines of this comment.

[snip]

>  static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
>  {
> -	struct parallel_data *pd;
> +	struct parallel_data *pd = NULL;
>  
>  	if (cpumask_test_cpu(cpu, cpu_active_mask)) {
> -		pd = padata_alloc_pd(pinst, pinst->cpumask);
> +		pd = padata_alloc_pd(pinst,
> +				pinst->cpumask.pcpu, pinst->cpumask.cbcpu);
>  		if (!pd)
>  			return -ENOMEM;
> -
> -		padata_replace(pinst, pd);
>  	}
>  
> +	padata_replace(pinst, pd);

This crashes if the cpu you add is not in the active cpumask,
as you pass a NULL pointer to padata_replace() then.

Some minor general things. It is quite helpfull to run checkpatch
on your patches, this helps to spot some codingstyle issues.
Also reading Documentation/CodingStyle is helpfull to get an
idea of the recommended codingstyle.

The rest of the patch looks quite good.

Thanks a lot,

Steffen
