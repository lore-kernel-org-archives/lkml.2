Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2HCQnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:43:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:34177 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab2HCQn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:43:26 -0400
Message-ID: <501BFF95.8040202@linutronix.de>
Date: Fri, 03 Aug 2012 18:43:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: fix set_task_blockstep()->update_debugctlmsr()
 logic
References: <20120803162954.GA19806@redhat.com>
In-Reply-To: <20120803162954.GA19806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 06:29 PM, Oleg Nesterov wrote:
> diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
> index afa60db..636402e 100644
> --- a/arch/x86/kernel/step.c
> +++ b/arch/x86/kernel/step.c
> @@ -166,12 +166,18 @@ static void set_task_blockstep(struct task_struct *task, bool on)
>   	else
>   		clear_tsk_thread_flag(task, TIF_BLOCKSTEP);
>
> +	if (task != current)
> +		return;
> +
> +	/* ensure irq/preemption can't change debugctl in between */
> +	local_irq_disable();
>   	debugctl = get_debugctlmsr();
>   	if (on)
>   		debugctl |= DEBUGCTLMSR_BTF;
>   	else
>   		debugctl&= ~DEBUGCTLMSR_BTF;
>   	update_debugctlmsr(debugctl);
> +	local_irq_enable();

wouldn't preempt_disable() be enough?

>   }
>
>   /*

Sebastian
