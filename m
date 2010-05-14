Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0ENQVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:21:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0ENQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:21:30 -0400
Date: Fri, 14 May 2010 09:18:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/4] padata: Add some code comments
Message-Id: <20100514091857.cd576ed2.randy.dunlap@oracle.com>
In-Reply-To: <20100514114606.GD2184@secunet.com>
References: <20100514114336.GB2184@secunet.com>
	<20100514114606.GD2184@secunet.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BED783D.0095:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 13:46:06 +0200 Steffen Klassert wrote:

> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  include/linux/padata.h |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/padata.c        |   50 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 101 insertions(+), 2 deletions(-)

Hi Steffen,

These comments are roughly 90% of the way to being kernel-doc notation,
so how about going the rest of the way, please?


> diff --git a/include/linux/padata.h b/include/linux/padata.h
> index 64836a6..e8aac0f 100644
> --- a/include/linux/padata.h
> +++ b/include/linux/padata.h
> @@ -26,6 +26,17 @@
>  #include <linux/list.h>
>  #include <linux/timer.h>
>  
> +/*

Use:
/**
in multiple places.

> + * struct padata_priv -  Embedded to the users data structure.
> + *
> + * @list: List entry, to attach to the padata lists.
> + * @pd: Pointer to the internal control structure.
> + * @cb_cpu: Callback cpu for serializatioon.
> + * @seq_nr: Sequence number of the parallelized data object.
> + * @info: Used to pass information from the parallel to the serial function.
> + * @parallel: Parallel execution function.
> + * @serial: Serial complete function.
> + */
>  struct padata_priv {
>  	struct list_head	list;
>  	struct parallel_data	*pd;
> @@ -36,11 +47,29 @@ struct padata_priv {
>  	void                    (*serial)(struct padata_priv *padata);
>  };
>  
> +/*
> + * struct padata_list
> + *
> + * @list: List head.
> + * @lock: List lock.
> + */
>  struct padata_list {
>  	struct list_head        list;
>  	spinlock_t              lock;
>  };
>  
> +/*
> + * struct padata_queue - The percpu padata queues.
> + *
> + * @parallel: List to wait for parallelization.
> + * @reorder: List to wait for reordering after parallel processing.
> + * @serial: List to wait for serialization after reordering.
> + * @pwork: work struct for parallelization.
> + * @swork: work struct for serialization.
> + * @pd: Backpointer to the internal control structure.
> + * @num_obj: Number of objects that are processed by this cpu.
> + * @cpu_index: Index of the cpu.
> + */
>  struct padata_queue {
>  	struct padata_list	parallel;
>  	struct padata_list	reorder;
> @@ -52,6 +81,20 @@ struct padata_queue {
>  	int			cpu_index;
>  };
>  
> +/*
> + * struct parallel_data - Internal control structure, covers everything
> + * that depends on the cpumask in use.
> + *
> + * @pinst: padata instance.
> + * @queue: percpu padata queues.
> + * @seq_nr: The sequence number that will be attached to the next object.
> + * @reorder_objects: Number of objects waiting in the reorder queues.
> + * @refcnt: Number of objects holding a reference on this parallel_data.
> + * @max_seq_nr:  Maximal used sequence number.
> + * @cpumask: cpumask in use.
> + * @lock: Reorder lock.
> + * @timer: Reorder timer.
> + */
>  struct parallel_data {
>  	struct padata_instance	*pinst;
>  	struct padata_queue	*queue;
> @@ -64,6 +107,16 @@ struct parallel_data {
>  	struct timer_list       timer;
>  };
>  
> +/*
> + * struct padata_instance - The overall control structure.
> + *
> + * @cpu_notifier: cpu hotplug notifier.
> + * @wq: The workqueue in use.
> + * @pd: The internal control structure.
> + * @cpumask: User supplied cpumask.
> + * @lock: padata instance lock.
> + * @flags: padata flags.
> + */
>  struct padata_instance {
>  	struct notifier_block   cpu_notifier;
>  	struct workqueue_struct *wq;
> diff --git a/kernel/padata.c b/kernel/padata.c
> index ec6b8b7..629bef3 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -152,6 +152,23 @@ out:
>  }
>  EXPORT_SYMBOL(padata_do_parallel);
>  
> +/*

/**

> + * padata_get_next - Get the next object that needs serialization.

    * @pd: <parameter description>

> + *
> + * Return values are:
> + *
> + * A pointer to the control struct of the next object that needs
> + * serialization, if present in one of the percpu reorder queues.
> + *
> + * NULL, if all percpu reorder queues are empty.
> + *
> + * -EINPROGRESS, if the next object that needs serialization will
> + *  be parallel processed by another cpu and is not yet present in
> + *  the cpu's reorder queue.
> + *
> + * -ENODATA, if this cpu has to do the parallel processing for
> + *  the next object.
> + */
>  static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  {
>  	int cpu, num_cpus, empty, calc_seq_nr;
> @@ -173,7 +190,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  
>  		/*
>  		 * Calculate the seq_nr of the object that should be
> -		 * next in this queue.
> +		 * next in this reorder queue.
>  		 */
>  		overrun = 0;
>  		calc_seq_nr = (atomic_read(&queue->num_obj) * num_cpus)

Thanks.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
