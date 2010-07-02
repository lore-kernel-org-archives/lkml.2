Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab0GBIvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:51:52 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42493 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab0GBIvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:51:48 -0400
Date: Fri, 2 Jul 2010 10:53:23 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
Message-ID: <20100702085323.GF10072@secunet.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jul 2010 08:51:45.0040 (UTC) FILETIME=[CC7F4100:01CB19C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan.

Your e-mail client corrupted all your patches on multiple lines,
so they do not apply. Please fix your e-mail client and resend.
Documentation/email-clients.txt might help here.

On Thu, Jul 01, 2010 at 05:57:57PM +0400, Dan Kruchinin wrote:
> Hello, Steffen.
> 
> Thank you for your comments about errors and coding-style in my previous
> patchset. I hope now I fixed all of them.

The Signed-off-by line and everything above goes to the git commit
message of the patch. So you should decribe your changes here.
It is good to read Documentation/SubmittingPatches and
Documentation/SubmitChecklist.

> 
> Signed-off-by: Dan Kruchinin <dkruchinin@acm.org>
> ---
>  crypto/pcrypt.c        |   53 +++----
>  include/linux/padata.h |   92 ++++++++----
>  kernel/padata.c        |  396
> +++++++++++++++++++++++++++++++++---------------
>  3 files changed, 361 insertions(+), 180 deletions(-)
> 
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index 247178c..f9b8b0b 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -38,28 +38,30 @@ struct pcrypt_instance_ctx {
> 
>  struct pcrypt_aead_ctx {
>         struct crypto_aead *child;
> -       unsigned int cb_cpu;
> +       int cb_cpu;
> +       unsigned int count;
>  };
> 
> -static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int
> *cb_cpu,
> +static int pcrypt_do_parallel(struct padata_priv *padata,
> +                             struct pcrypt_aead_ctx *ctx,
>                               struct padata_instance *pinst)
>  {
> -       unsigned int cpu_index, cpu, i;
> +       int cpu;
> 
> -       cpu = *cb_cpu;
> +       cpu = ctx->cb_cpu;
> +       if (cpu < 0) {
> +               struct cpumask mask;
> +               int cpu_index, i;
> 
> -       if (cpumask_test_cpu(cpu, cpu_active_mask))
> -                       goto out;
> +               padata_get_cb_cpumask(pinst, &mask);
> +               cpu_index = ctx->count % cpumask_weight(&mask);
> +               cpu = cpumask_first(&mask);
> +               for (i = 0; i < cpu_index; i++)
> +                       cpu = cpumask_next(cpu, &mask);
> 
> -       cpu_index = cpu % cpumask_weight(cpu_active_mask);
> -
> -       cpu = cpumask_first(cpu_active_mask);
> -       for (i = 0; i < cpu_index; i++)
> -               cpu = cpumask_next(cpu, cpu_active_mask);
> -
> -       *cb_cpu = cpu;
> +               ctx->cb_cpu = cpu;
> +       }

The above is not save against cpu hotplug. You initialize ctx->cb_cpu
to -1 when the transformation is initialized. So you choose your
callback cpu with the first call to pcrypt_do_parallel() and then never
again. What if the coosen callback cpu goes offline?

Also I don't understand why you changed the prototype of pcrypt_do_parallel
and added a 'count' to pcrypt_aead_ctx. The only change you have to do, is to
check whether the choosen callback cpu is still in the cpu_active_mask _and_
in your new padata callback cpumask and update the callback cpu accordingly
if not. Checking whether the callback cpu is in the callback cpumask needs
some special care in your other patch of course, because you can change this
cpumask from userspace then.

Putting the cpumask on the stack is also not a good idea. This can lead to
stack corruption on systems with many cpus.

> 
> -out:
>         return padata_do_parallel(pinst, padata, cpu);
>  }
> 
> @@ -142,7 +144,7 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
>                                req->cryptlen, req->iv);
>         aead_request_set_assoc(creq, req->assoc, req->assoclen);
> 
> -       err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
> +       err = pcrypt_do_parallel(padata, ctx, pcrypt_enc_padata);
>         if (err)
>                 return err;
>         else
> @@ -186,7 +188,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
>                                req->cryptlen, req->iv);
>         aead_request_set_assoc(creq, req->assoc, req->assoclen);
> 
> -       err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_dec_padata);
> +       err = pcrypt_do_parallel(padata, ctx, pcrypt_dec_padata);
>         if (err)
>                 return err;
>         else
> @@ -232,7 +234,7 @@ static int pcrypt_aead_givencrypt(struct
> aead_givcrypt_request *req)
>         aead_givcrypt_set_assoc(creq, areq->assoc, areq->assoclen);
>         aead_givcrypt_set_giv(creq, req->giv, req->seq);
> 
> -       err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
> +       err = pcrypt_do_parallel(padata, ctx, pcrypt_enc_padata);
>         if (err)
>                 return err;
>         else
> @@ -243,20 +245,13 @@ static int pcrypt_aead_givencrypt(struct
> aead_givcrypt_request *req)
> 
>  static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
>  {
> -       int cpu, cpu_index;
>         struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
> -       struct pcrypt_instance_ctx *ictx = crypto_instance_ctx(inst);
>         struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
> +       struct pcrypt_instance_ctx *ictx = crypto_instance_ctx(inst);
>         struct crypto_aead *cipher;
> 
> -       ictx->tfm_count++;
> -
> -       cpu_index = ictx->tfm_count % cpumask_weight(cpu_active_mask);
> -
> -       ctx->cb_cpu = cpumask_first(cpu_active_mask);
> -       for (cpu = 0; cpu < cpu_index; cpu++)
> -               ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_active_mask);
> -
> +       ctx->count = ++ictx->tfm_count;
> +       ctx->cb_cpu = -1;
>         cipher = crypto_spawn_aead(crypto_instance_ctx(inst));

Same as above, just choose a cpu that is active and in your cpumask.

[snip]

> -static int padata_cpu_hash(struct padata_priv *padata)
> +/**
> + * padata_cpu_hash: Select cpu from cpumask @mask using simple
> + *                         hash function by integer @seq_nr.
> + *
> + * @mask: A pointer to cpumask that will be used for cpu selection.
> + * @seq_nr: An integer to hash.
> + */
> +static int padata_cpu_hash(const struct cpumask *mask, int seq_nr)
>  {
>         int cpu_index;
> -       struct parallel_data *pd;
> 
> -       pd =  padata->pd;
> 
>         /*
>          * Hash the sequence numbers to the cpus by taking
>          * seq_nr mod. number of cpus in use.
>          */
> -       cpu_index =  padata->seq_nr % cpumask_weight(pd->cpumask);
> +       cpu_index =  seq_nr % cpumask_weight(mask);
> 
> -       return padata_index_to_cpu(pd, cpu_index);
> +       return padata_index_to_cpu(mask, cpu_index);
>  }

Why you changed the prototype of padata_cpu_hash?
I think it's better to keep it as it was. We pass in the padata_priv
of the object that wants parallel processing and you get the cpu
on which the thing must run.

> 
> -static void padata_parallel_worker(struct work_struct *work)
> +/**
> + * padata_get_cb_cpumask: Fetch cpumask containing cpus that may be used
> for
> + *                        serialization callback from parallel data and
> copy it
> + *                        into the @mask.
> + *
> + * @pinst: A pointer to padata instance
> + * @mask: A pointer to cpumask structure where
> + *        cpumask for callbacks will be copied.
> + */
> +void padata_get_cb_cpumask(struct padata_instance *pinst, struct cpumask
> *mask)
>  {
> -       struct padata_queue *queue;
> +       struct parallel_data *pd;
> +
> +       rcu_read_lock_bh();
> +       pd = rcu_dereference(pinst->pd);
> +       cpumask_copy(mask, pd->cpumask.cbcpu);
> +       rcu_read_unlock_bh();
> +}
> +EXPORT_SYMBOL(padata_get_cb_cpumask);
> +
> +static void padata_parallel_worker(struct work_struct *parallel_work)
> +{
> +       struct padata_parallel_queue *pqueue;
>         struct parallel_data *pd;
>         struct padata_instance *pinst;
>         LIST_HEAD(local_list);
> 
>         local_bh_disable();
> -       queue = container_of(work, struct padata_queue, pwork);
> -       pd = queue->pd;
> +       pqueue = container_of(parallel_work,
> +                             struct padata_parallel_queue,
> +                             work);
> +
> +       pd = pqueue->pd;
>         pinst = pd->pinst;
> 
> -       spin_lock(&queue->parallel.lock);
> -       list_replace_init(&queue->parallel.list, &local_list);
> -       spin_unlock(&queue->parallel.lock);
> +       spin_lock(&pqueue->parallel.lock);
> +       list_replace_init(&pqueue->parallel.list, &local_list);
> +       spin_unlock(&pqueue->parallel.lock);
> 
>         while (!list_empty(&local_list)) {
>                 struct padata_priv *padata;
> @@ -93,8 +121,8 @@ static void padata_parallel_worker(struct work_struct
> *work)
>   *
>   * @pinst: padata instance
>   * @padata: object to be parallelized
> - * @cb_cpu: cpu the serialization callback function will run on,
> - *          must be in the cpumask of padata.
> + * @cb_cpu: cpu the serialization callback function will run on.
> + *          NOTE: @cb_cpu *must* be in serial cpumask(i.e.
> pinst->cpumask.cbcpu)
>   *
>   * The parallelization callback function will run with BHs off.
>   * Note: Every object which is parallelized by padata_do_parallel
> @@ -104,7 +132,7 @@ int padata_do_parallel(struct padata_instance *pinst,
>                        struct padata_priv *padata, int cb_cpu)
>  {
>         int target_cpu, err;
> -       struct padata_queue *queue;
> +       struct padata_parallel_queue *pqueue;
>         struct parallel_data *pd;
> 
>         rcu_read_lock_bh();
> @@ -123,27 +151,27 @@ int padata_do_parallel(struct padata_instance *pinst,
>                 goto out;
> 
>         err = -EINVAL;
> -       if (!cpumask_test_cpu(cb_cpu, pd->cpumask))
> +       if (!cpumask_test_cpu(cb_cpu, pd->cpumask.cbcpu))
>                 goto out;
> 
>         err = -EINPROGRESS;
>         atomic_inc(&pd->refcnt);
>         padata->pd = pd;
> -       padata->cb_cpu = cb_cpu;
> 
>         if (unlikely(atomic_read(&pd->seq_nr) == pd->max_seq_nr))
>                 atomic_set(&pd->seq_nr, -1);
> 
> +       padata->cb_cpu = cb_cpu;

Why you moved this line below the sequence number check?
It's a minor issue, but there are several places where you shuffle code
arround for no real reason. It is good to read through your patches,
so you see what you actually changed. I'll do so usually, this helps
to find unneeded and accidentally introduced changes.
 
I know, I'm picky. But I hope this helps to get your patches
on the right way :)

Thanks,

Steffen
