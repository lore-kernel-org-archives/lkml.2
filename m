Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab1FUWuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:50:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756411Ab1FUWuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:50:11 -0400
Date: Tue, 21 Jun 2011 15:49:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Vasiliy Kulikov <segooon@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v2] taskstats: don't allow duplicate entries in listener
 mode
Message-Id: <20110621154900.ea6b8839.akpm@linux-foundation.org>
In-Reply-To: <1308239759-4797-1-git-send-email-segoon@openwall.com>
References: <1308239759-4797-1-git-send-email-segoon@openwall.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 19:55:59 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> Currently a single process may register exit handlers unlimited times.
> It may lead to a bloated listeners chain and very slow process terminations.
> E.g. after 10KK sent TASKSTATS_CMD_ATTR_REGISTER_CPUMASKs ~300 Mb of
> kernel memory is stolen for the handlers chain and "time id" shows 2-7
> seconds instead of normal 0.003.  It makes it possible to exhaust all
> kernel memory and to eat much of CPU time by triggerring numerous exits
> on a single CPU.
> 
> The patch limits the number of times a single process may register
> itself on a single CPU to one.
> 
> One little issue is kept unfixed - as taskstats_exit() is called before
> exit_files() in do_exit(), the orphaned listener entry (if it was not
> explicitly deregistered) is kept until the next someone's exit() and
> implicit deregistration in send_cpu_listeners().  So, if a process
> registered itself as a listener exits and the next spawned process gets
> the same pid, it would inherit taskstats attributes.

ow. That's an unprivileged operation, isn't it?

> 
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 9ffea36..fc0f220 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -285,16 +285,18 @@ ret:
>  static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
>  {
>  	struct listener_list *listeners;
> -	struct listener *s, *tmp;
> +	struct listener *s, *tmp, *s2;
>  	unsigned int cpu;
>  
>  	if (!cpumask_subset(mask, cpu_possible_mask))
>  		return -EINVAL;
>  
> +	s = NULL;
>  	if (isadd == REGISTER) {
>  		for_each_cpu(cpu, mask) {
> -			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
> -					 cpu_to_node(cpu));
> +			if (!s)
> +				s = kmalloc_node(sizeof(struct listener),
> +						 GFP_KERNEL, cpu_to_node(cpu));
>  			if (!s)
>  				goto cleanup;
>  			s->pid = pid;
> @@ -303,9 +305,16 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
>  
>  			listeners = &per_cpu(listener_array, cpu);
>  			down_write(&listeners->sem);
> +			list_for_each_entry_safe(s2, tmp, &listeners->list, list) {
> +				if (s2->pid == pid)
> +					goto next_cpu;
> +			}
>  			list_add(&s->list, &listeners->list);
> +			s = NULL;
> +next_cpu:
>  			up_write(&listeners->sem);
>  		}
> +		kfree(s);
>  		return 0;
>  	}
>  

