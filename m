Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0F3MqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:46:16 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:41789 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0F3MqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:46:15 -0400
Date: Wed, 30 Jun 2010 14:47:42 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <kruchinin@altell.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 2/2] pcrypt:  sysfs interface
Message-ID: <20100630124742.GD10072@secunet.com>
References: <20100629203939.29a0b4ff@leibniz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629203939.29a0b4ff@leibniz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Jun 2010 12:46:12.0709 (UTC) FILETIME=[38A7B150:01CB1852]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 08:39:39PM +0400, Dan Kruchinin wrote:

[snip]

> @@ -390,6 +427,9 @@ static int __init pcrypt_init(void)
>  	if (!pcrypt_dec_padata)
>  		goto err_free_padata;
>  
> +	if (pcrypt_init_sysfs() != 0)
> +		goto err_free_padata;

We leak pcrypt_dec_padata if pcrypt_init_sysfs() fails.
pcrypt_dec_padata must be freed in this case.

[snip]

>  struct padata_priv {
> -	struct list_head	list;
> -	struct parallel_data	*pd;
> -	int			cb_cpu;
> -	int			seq_nr;
> -	int			info;
> -	void                    (*parallel)(struct padata_priv *padata);
> -	void                    (*serial)(struct padata_priv *padata);
> +	struct list_head      list;
> +	struct parallel_data *pd;
> +	int                   cb_cpu;
> +	int                   seq_nr;
> +	int                   info;
> +	void                  (*parallel)(struct padata_priv *padata);
> +	void                  (*serial)(struct padata_priv *padata);
>  };

These whitespace changes are quite pointless.
Please try to avoid such whitespace changes in patches that
change real content. 

[snip]

> @@ -107,6 +108,7 @@ static void padata_parallel_worker(struct work_struct *parallel_work)
>  				    struct padata_priv, list);
>  
>  		list_del_init(&padata->list);
> +		atomic_dec(&pinst->stat.parallel_objs);
>  
>  		padata->parallel(padata);
>  	}
> @@ -166,6 +168,7 @@ int padata_do_parallel(struct padata_instance *pinst,
>  	pqueue = per_cpu_ptr(pd->pqueue, target_cpu);
>  
>  	spin_lock(&pqueue->parallel.lock);
> +	atomic_inc(&pinst->stat.parallel_objs);
>  	list_add_tail(&padata->list, &pqueue->parallel.list);
>  	spin_unlock(&pqueue->parallel.lock);

These statistic counters add a lot of atomic operations to the fast-path.
Would'nt it be better to have these statistics in a percpu manner?
This would avoid the atomic operations and we would get some additional
information on the distribution of the queued objects.

>  
> @@ -202,6 +205,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  	struct padata_parallel_queue *queue, *next_queue;
>  	struct padata_priv *padata;
>  	struct padata_list *reorder;
> +	struct padata_stat *stat = &pd->pinst->stat;
>  
>  	empty = 0;
>  	next_nr = -1;
> @@ -266,7 +270,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  
>  		spin_lock(&reorder->lock);
>  		list_del_init(&padata->list);
> -		atomic_dec(&pd->reorder_objects);
> +		atomic_dec(&stat->reorder_objs);
>  		spin_unlock(&reorder->lock);
>  
>  		atomic_inc(&next_queue->num_obj);
> @@ -330,6 +334,7 @@ static void padata_reorder(struct parallel_data *pd)
>  		squeue = per_cpu_ptr(pd->squeue, padata->cb_cpu);
>  
>  		spin_lock(&squeue->serial.lock);
> +        atomic_inc(&pinst->stat.serial_objs);

Wrong code indent.

Please try to split the patch in a padata and a pcrypt part.
I.e. add the interface to padata, then use it with pcrypt.

Thanks again,

Steffen
