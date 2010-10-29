Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab0J2EUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:20:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56517 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0J2EUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:20:34 -0400
X-AuditID: b753bd60-a6131ba000000226-e5-4cca4b8f5b3d
Message-ID: <4CCA4B8A.5050909@hitachi.com>
Date: Fri, 29 Oct 2010 13:20:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 3/8] jump label: Fix error with preempt disable holding
 mutex
References: <20101028135548.055490014@goodmis.org> <20101028135647.429157214@goodmis.org>
In-Reply-To: <20101028135647.429157214@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/28 22:55), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Kprobes and jump label were having a race between mutexes that
> was fixed by reordering the jump label. But this reordering
> moved the jump label mutex into a preempt disable location.
> 
> This patch does a little fiddling to move the grabbing of
> the jump label mutex from inside the preempt disable section
> and still keep the order correct between the mutex and the
> kprobes lock.

Ah, right. Thank you for fixing it.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/kprobes.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 9437e14..9737a76 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1145,17 +1145,13 @@ int __kprobes register_kprobe(struct kprobe *p)
>  	if (ret)
>  		return ret;
>  
> -	preempt_disable();
>  	jump_label_lock();
> +	preempt_disable();
>  	if (!kernel_text_address((unsigned long) p->addr) ||
>  	    in_kprobes_functions((unsigned long) p->addr) ||
>  	    ftrace_text_reserved(p->addr, p->addr) ||
> -	    jump_label_text_reserved(p->addr, p->addr)) {
> -		preempt_enable();
> -		jump_label_unlock();
> -		return -EINVAL;
> -	}
> -	jump_label_unlock();
> +	    jump_label_text_reserved(p->addr, p->addr))
> +		goto fail_with_jump_label;
>  
>  	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
>  	p->flags &= KPROBE_FLAG_DISABLED;
> @@ -1169,10 +1165,9 @@ int __kprobes register_kprobe(struct kprobe *p)
>  		 * We must hold a refcount of the probed module while updating
>  		 * its code to prohibit unexpected unloading.
>  		 */
> -		if (unlikely(!try_module_get(probed_mod))) {
> -			preempt_enable();
> -			return -EINVAL;
> -		}
> +		if (unlikely(!try_module_get(probed_mod)))
> +			goto fail_with_jump_label;
> +
>  		/*
>  		 * If the module freed .init.text, we couldn't insert
>  		 * kprobes in there.
> @@ -1180,11 +1175,11 @@ int __kprobes register_kprobe(struct kprobe *p)
>  		if (within_module_init((unsigned long)p->addr, probed_mod) &&
>  		    probed_mod->state != MODULE_STATE_COMING) {
>  			module_put(probed_mod);
> -			preempt_enable();
> -			return -EINVAL;
> +			goto fail_with_jump_label;
>  		}
>  	}
>  	preempt_enable();
> +	jump_label_unlock();
>  
>  	p->nmissed = 0;
>  	INIT_LIST_HEAD(&p->list);
> @@ -1226,6 +1221,11 @@ out:
>  		module_put(probed_mod);
>  
>  	return ret;
> +
> +fail_with_jump_label:
> +	preempt_enable();
> +	jump_label_unlock();
> +	return -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(register_kprobe);
>  


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
