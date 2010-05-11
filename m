Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab0EKOkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:40:18 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45065 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755283Ab0EKOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:40:15 -0400
Date: Tue, 11 May 2010 10:40:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip 4/5] kprobes/x86: Use text_poke_smp_batch
Message-ID: <20100511144013.GA17656@Krystal>
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6> <20100510175340.27396.7222.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510175340.27396.7222.stgit@localhost6.localdomain6>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:39:08 up 108 days, 17:16,  9 users,  load average: 0.46, 0.30,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Use text_poke_smp_batch() in optimization path for reducing
> the number of stop_machine() issues.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
> 
>  arch/x86/kernel/kprobes.c |   37 ++++++++++++++++++++++++++++++-------
>  include/linux/kprobes.h   |    2 +-
>  kernel/kprobes.c          |   13 +------------
>  3 files changed, 32 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 345a4b1..63a5c24 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -1385,10 +1385,14 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
>  	return 0;
>  }
>  
> -/* Replace a breakpoint (int3) with a relative jump.  */
> -int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
> +#define MAX_OPTIMIZE_PROBES 256

So what kind of interrupt latency does a 256-probes batch generate on the
system ?  Are we talking about a few milliseconds, a few seconds ?

Thanks,

Mathieu

> +static struct text_poke_param jump_params[MAX_OPTIMIZE_PROBES];
> +static char jump_code_buf[MAX_OPTIMIZE_PROBES][RELATIVEJUMP_SIZE];
> +
> +static void __kprobes setup_optimize_kprobe(struct text_poke_param *tprm,
> +					    char *insn_buf,
> +					    struct optimized_kprobe *op)
>  {
> -	unsigned char jmp_code[RELATIVEJUMP_SIZE];
>  	s32 rel = (s32)((long)op->optinsn.insn -
>  			((long)op->kp.addr + RELATIVEJUMP_SIZE));
>  
> @@ -1396,16 +1400,35 @@ int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
>  	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
>  	       RELATIVE_ADDR_SIZE);
>  
> -	jmp_code[0] = RELATIVEJUMP_OPCODE;
> -	*(s32 *)(&jmp_code[1]) = rel;
> +	insn_buf[0] = RELATIVEJUMP_OPCODE;
> +	*(s32 *)(&insn_buf[1]) = rel;
> +
> +	tprm->addr = op->kp.addr;
> +	tprm->opcode = insn_buf;
> +	tprm->len = RELATIVEJUMP_SIZE;
> +}
> +
> +/* Replace a breakpoint (int3) with a relative jump.  */
> +void __kprobes arch_optimize_kprobes(struct list_head *oplist)
> +{
> +	struct optimized_kprobe *op, *tmp;
> +	int c = 0;
> +
> +	list_for_each_entry_safe(op, tmp, oplist, list) {
> +		WARN_ON(kprobe_disabled(&op->kp));
> +		/* Setup param */
> +		setup_optimize_kprobe(&jump_params[c], jump_code_buf[c], op);
> +		list_del_init(&op->list);
> +		if (++c >= MAX_OPTIMIZE_PROBES)
> +			break;
> +	}
>  
>  	/*
>  	 * text_poke_smp doesn't support NMI/MCE code modifying.
>  	 * However, since kprobes itself also doesn't support NMI/MCE
>  	 * code probing, it's not a problem.
>  	 */
> -	text_poke_smp(op->kp.addr, jmp_code, RELATIVEJUMP_SIZE);
> -	return 0;
> +	text_poke_smp_batch(jump_params, c);
>  }
>  
>  /* Replace a relative jump with a breakpoint (int3).  */
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index e7d1b2e..fe157ba 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -275,7 +275,7 @@ extern int arch_prepared_optinsn(struct arch_optimized_insn *optinsn);
>  extern int arch_check_optimized_kprobe(struct optimized_kprobe *op);
>  extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
>  extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
> -extern int  arch_optimize_kprobe(struct optimized_kprobe *op);
> +extern void arch_optimize_kprobes(struct list_head *oplist);
>  extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
>  extern kprobe_opcode_t *get_optinsn_slot(void);
>  extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index aae368a..c824c23 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -424,14 +424,10 @@ static LIST_HEAD(optimizing_list);
>  static void kprobe_optimizer(struct work_struct *work);
>  static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
>  #define OPTIMIZE_DELAY 5
> -#define MAX_OPTIMIZE_PROBES 64
>  
>  /* Kprobe jump optimizer */
>  static __kprobes void kprobe_optimizer(struct work_struct *work)
>  {
> -	struct optimized_kprobe *op, *tmp;
> -	int c = 0;
> -
>  	/* Lock modules while optimizing kprobes */
>  	mutex_lock(&module_mutex);
>  	mutex_lock(&kprobe_mutex);
> @@ -459,14 +455,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
>  	 */
>  	get_online_cpus();
>  	mutex_lock(&text_mutex);
> -	list_for_each_entry_safe(op, tmp, &optimizing_list, list) {
> -		WARN_ON(kprobe_disabled(&op->kp));
> -		if (arch_optimize_kprobe(op) < 0)
> -			op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
> -		list_del_init(&op->list);
> -		if (++c >= MAX_OPTIMIZE_PROBES)
> -			break;
> -	}
> +	arch_optimize_kprobes(&optimizing_list);
>  	mutex_unlock(&text_mutex);
>  	put_online_cpus();
>  	if (!list_empty(&optimizing_list))
> 
> 
> -- 
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
