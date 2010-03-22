Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0CVR5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:57:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab0CVR5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:57:34 -0400
Message-ID: <4BA7AEF8.2030709@redhat.com>
Date: Mon, 22 Mar 2010 13:55:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH 1/5] jump label: notifier atomic call chain notrace
References: <cover.1269272444.git.jbaron@redhat.com> <48e5099e36e4e69d0671e4c16fa8c2f5f3cf5d59.1269272444.git.jbaron@redhat.com>
In-Reply-To: <48e5099e36e4e69d0671e4c16fa8c2f5f3cf5d59.1269272444.git.jbaron@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> In LTTng, being able to use the atomic notifier from cpu idle entry to
> ensure the tracer flush the last events in the current subbuffer
> requires the rcu read-side to be marked "notrace", otherwise it can end
> up calling back into lockdep and the tracer.
> 
> Also apply to the the die notifier.

Looks good for me and it'll be good for kprobe-tracer too:)


> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  kernel/notifier.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index 2488ba7..88453a7 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -148,7 +148,7 @@ int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
>  	spin_lock_irqsave(&nh->lock, flags);
>  	ret = notifier_chain_unregister(&nh->head, n);
>  	spin_unlock_irqrestore(&nh->lock, flags);
> -	synchronize_rcu();
> +	synchronize_sched();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
> @@ -178,9 +178,9 @@ int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
>  {
>  	int ret;
>  
> -	rcu_read_lock();
> +	rcu_read_lock_sched_notrace();
>  	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
> -	rcu_read_unlock();
> +	rcu_read_unlock_sched_notrace();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
