Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2HGJmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:42:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:50825 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2HGJmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:42:15 -0400
Message-ID: <5020E2E4.3090104@linutronix.de>
Date: Tue, 07 Aug 2012 11:41:56 +0200
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
>   }

I would say that you can remove this chunk. For task != current we
leave.
For uprobes we never set the bit, we only need it cleared. We get here
via int 3 and do_debug() already clears TIF_BLOCKSTEP because the
CPU clears the bit in CPU. So both, TIF_BLOCKSTEP and DEBUGCTLMSR_BTF
are never set.

Sebastian
