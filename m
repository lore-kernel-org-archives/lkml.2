Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1DZJ1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:27:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:49917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1DZJ1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:27:34 -0400
Subject: Re: [PATCH -tip v2] sched: more sched_domain iterations fix
From: Peter Zijlstra <peterz@infradead.org>
To: Xiaotian feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1303469634-11678-1-git-send-email-dfeng@redhat.com>
References: <1303384893.2035.73.camel@laptop>
	 <1303469634-11678-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 11:27:19 +0200
Message-ID: <1303810039.20212.221.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 18:53 +0800, Xiaotian feng wrote:
> From: Xiaotian Feng <dfeng@redhat.com>
> 
> sched_domain iterations needs to be protected by rcu_read_lock() now,
> this patch adds another two places which needs the rcu lock, which is
> spotted by following suspicious rcu_dereference_check() usage warnings.
> 
> kernel/sched_rt.c:1244 invoked rcu_dereference_check() without protection!
> kernel/sched_stats.h:41 invoked rcu_dereference_check() without protection!

Much better, one worry:

> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---

> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index 48ddf43..331e01b 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -37,7 +37,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  
>  #ifdef CONFIG_SMP
>  		/* domain-specific stats */
> -		preempt_disable();
> +		rcu_read_lock();
>  		for_each_domain(cpu, sd) {
>  			enum cpu_idle_type itype;
>  
> @@ -64,7 +64,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
>  			    sd->ttwu_move_balance);
>  		}
> -		preempt_enable();
> +		rcu_read_unlock();
>  #endif
>  	}
>  	kfree(mask_str);

Did you indeed validate that the preempt_disable() wasn't needed for
anything else? Your changelog doesn't mention and I didn't check, just
noticed the possibility on the first posting.
