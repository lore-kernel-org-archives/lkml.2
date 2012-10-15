Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2JOV4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:56:38 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50984 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab2JOV4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:56:35 -0400
Date: Mon, 15 Oct 2012 14:56:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] srcu: add DEFINE_SRCU()
Message-ID: <20121015215607.GB3010@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
 <1350062057-2439-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350062057-2439-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101521-7408-0000-0000-0000095DBC6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 01:14:16AM +0800, Lai Jiangshan wrote:
> In old days, we have two different API sets for dynamic-allocated per_cpu data
> and DEFINE_PER_CPU()-defined per_cpu data, and since we used
> dynamic-allocated per_cpu data, we can't use DEFINE_PER_CPU()-defined
> per_cpu data(otherwise we will introduce a lot of duplicated code.
> 
> In new days, we have only one API sets for both type of per_cpu data,
> so we can use DEFINE_PER_CPU() for DEFINE_SRCU() which allows us
> define and init srcu struct in build time and allows us use srcu APIs
> in very early boot time.
> 
> We also provide DEFINE_STATIC_SRCU() which defines an internal srcu struct
> inside a single *.c.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/srcu.h |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 5cce128..f986df1 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -42,6 +42,8 @@ struct rcu_batch {
>  	struct rcu_head *head, **tail;
>  };
> 
> +#define RCU_BATCH_INIT(name) { NULL, &(name.head) }
> +
>  struct srcu_struct {
>  	unsigned completed;
>  	struct srcu_struct_array __percpu *per_cpu_ref;
> @@ -72,14 +74,42 @@ int __init_srcu_struct(struct srcu_struct *sp, const char *name,
>  	__init_srcu_struct((sp), #sp, &__srcu_key); \
>  })
> 
> +#define __SRCU_DEP_MAP_INIT(srcu_name)	.dep_map = { .name = #srcu_name },
>  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> 
>  int init_srcu_struct(struct srcu_struct *sp);
> 
> +#define __SRCU_DEP_MAP_INIT(srcu_name)
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> 
>  void process_srcu(struct work_struct *work);
> 
> +#define __SRCU_STRUCT_INIT(name)					\
> +	{								\
> +		.completed = -300,					\
> +		.per_cpu_ref = &name##_srcu_array,			\
> +		.queue_lock = __SPIN_LOCK_UNLOCKED(name.queue_lock),	\
> +		.running = false,					\
> +		.batch_queue = RCU_BATCH_INIT(name.batch_queue),	\
> +		.batch_check0 = RCU_BATCH_INIT(name.batch_check0),	\
> +		.batch_check1 = RCU_BATCH_INIT(name.batch_check1),	\
> +		.batch_done = RCU_BATCH_INIT(name.batch_done),		\
> +		.work = __DELAYED_WORK_INITIALIZER(name.work, process_srcu),\
> +		__SRCU_DEP_MAP_INIT(name)				\
> +	}
> +
> +/*
> + * define and init a srcu struct at build time.
> + * dont't call init_srcu_struct() nor cleanup_srcu_struct() on it.
> + */
> +#define DEFINE_SRCU(name)						\
> +	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
> +	struct srcu_struct name = __SRCU_STRUCT_INIT(name);
> +
> +#define DEFINE_STATIC_SRCU(name)						\
> +	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
> +	static struct srcu_struct name = __SRCU_STRUCT_INIT(name);
> +

Why not collapse DEFINE_SRCU() and DEFINE_STATIC_SRCU() as follows?

+#define DEFINE_SRCU(name)						\
+	struct srcu_struct name = __SRCU_STRUCT_INIT(name);		\
+	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);

Then "static DEFINE_SRCU(foo)" would create a static srcu_struct without
the need for a separate DEFINE_STATIC_SRCU().

							Thanx, Paul

>  /**
>   * call_srcu() - Queue a callback for invocation after an SRCU grace period
>   * @sp: srcu_struct in queue the callback
> -- 
> 1.7.7.6
> 

