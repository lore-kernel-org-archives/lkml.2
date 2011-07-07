Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1GGTvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:51:45 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:44580 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1GGTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:51:44 -0400
Subject: Re: [PATCH v3 1/2] slub: Enable backtrace for create/delete points.
From: Pekka Enberg <penberg@kernel.org>
To: greearb@candelatech.com
Cc: cl@linux.com, linux-kernel@vger.kernel.org
In-Reply-To: <1310063797-14914-1-git-send-email-greearb@candelatech.com>
References: <1310063797-14914-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 07 Jul 2011 22:51:42 +0300
Message-ID: <1310068302.21902.64.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 11:36 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This patch attempts to grab a backtrace for the creation
> and deletion points of the slub object.  When a fault is
> detected, we can then get a better idea of where the item
> was deleted.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v3:  Don't rename addr to caddr.
>      Move 'int i' into #ifdef block to ensure there is no
>      warning when #ifdef'd code is not compiled.
> 
> :100644 100644 35f351f... c52fa60... M	mm/slub.c
>  mm/slub.c |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 35f351f..c52fa60 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -191,8 +191,12 @@ static LIST_HEAD(slab_caches);
>  /*
>   * Tracking user of a slab.
>   */
> +#define TRACK_ADDRS_COUNT 16
>  struct track {
>  	unsigned long addr;	/* Called from address */
> +#ifdef CONFIG_STACKTRACE
> +	unsigned long addrs[TRACK_ADDRS_COUNT];	/* Called from address */
> +#endif
>  	int cpu;		/* Was running on cpu */
>  	int pid;		/* Pid context */
>  	unsigned long when;	/* When did the operation occur */
> @@ -420,6 +424,24 @@ static void set_track(struct kmem_cache *s, void *object,
>  	struct track *p = get_track(s, object, alloc);
>  
>  	if (addr) {
> +#ifdef CONFIG_STACKTRACE
> +		struct stack_trace trace;

This needed <linux/stacktrace.h> - I fixed it myself.

> +		int i;
> +
> +		trace.nr_entries = 0;
> +		trace.max_entries = TRACK_ADDRS_COUNT;
> +		trace.entries = p->addrs;
> +		trace.skip = 3;
> +		save_stack_trace(&trace);
> +
> +		/* See rant in lockdep.c */
> +		if (trace.nr_entries != 0 &&
> +		    trace.entries[trace.nr_entries - 1] == ULONG_MAX)
> +			trace.nr_entries--;
> +
> +		for (i = trace.nr_entries; i < TRACK_ADDRS_COUNT; i++)
> +			p->addrs[i] = 0;
> +#endif
>  		p->addr = addr;
>  		p->cpu = smp_processor_id();
>  		p->pid = current->pid;
> @@ -444,6 +466,16 @@ static void print_track(const char *s, struct track *t)
>  
>  	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
>  		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
> +#ifdef CONFIG_STACKTRACE
> +	{
> +		int i;
> +		for (i = 0; i < TRACK_ADDRS_COUNT; i++)
> +			if (t->addrs[i])
> +				printk(KERN_ERR "\t%pS\n", (void *)t->addrs[i]);
> +			else
> +				break;
> +	}
> +#endif
>  }
>  
>  static void print_tracking(struct kmem_cache *s, void *object)


