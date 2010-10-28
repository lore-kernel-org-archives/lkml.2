Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab0J1Qod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:44:33 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:62019 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758933Ab0J1Qo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:44:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAI8/yUxGGOIS/2dsb2JhbAChR3K/d4VIBI9c
Date: Thu, 28 Oct 2010 12:04:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jason Baron <jbaron@redhat.com>
Cc: masami.hiramatsu.pt@hitachi.com, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, fweisbec@gmail.com, rostedt@goodmis.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] call stop_machine_text_poke() on all cpus
Message-ID: <20101028160423.GB11953@Krystal>
References: <20101028152026.GB2875@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20101028152026.GB2875@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:02:40 up 204 days,  1:53,  3 users,  load average: 0.03, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> Currently, text_poke_smp() passes a NULL as the third argument to
> __stop_machine(), which will only run stop_machine_text_poke()
> on 1 cpu. Change NULL -> cpu_online_mask, as stop_machine_text_poke()
> is intended to be run on all cpus.
> 
> I actually didn't notice any problems with stop_machine_text_poke()
> only being called on 1 cpu, but found this via code inspection.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Good catch!

The side-effect of this is that the other CPUs are not executing the
memory barrier and not flushing the icache, as we would normally expect.

Thanks,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
>  arch/x86/kernel/alternative.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 9f39a1c..3c3f26f 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -705,6 +705,6 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
>  	atomic_set(&stop_machine_first, 1);
>  	wrote_text = 0;
>  	/* Use __stop_machine() because the caller already got online_cpus. */
> -	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> +	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
>  	return addr;
>  }
> -- 
> 1.7.1
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
