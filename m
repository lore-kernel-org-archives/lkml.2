Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2B0Jey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:34:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab2B0Jex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:34:53 -0500
Date: Mon, 27 Feb 2012 10:34:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        systemtap@sourceware.org, anderson@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH v3 -tip] [BUGFIX] x86/kprobes: Fix to recover
 instructions on optimized path
Message-ID: <20120227093421.GA10078@elte.hu>
References: <20120223083703.GA26781@elte.hu>
 <20120224095412.8462.55698.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224095412.8462.55698.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> +
> +#ifdef CONFIG_OPTPROBES
> +static unsigned long __recover_optprobed_insn(struct kprobe *kp,
> +					      kprobe_opcode_t *buf,
> +					      unsigned long addr)
> +{
> +	long offs = addr - (unsigned long)kp->addr - 1;
> +	struct optimized_kprobe *op = container_of(kp, struct optimized_kprobe, kp);
> +
> +	/*
> +	 * If the kprobe can be optimized, original bytes which can be
> +	 * overwritten by jump destination address. In this case, original
> +	 * bytes must be recovered from op->optinsn.copied_insn buffer.
> +	 */
> +	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> +	if (addr == (unsigned long)kp->addr) {
> +		buf[0] = kp->opcode;
> +		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
> +	} else
> +		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
> +
> +	return (unsigned long)buf;
> +}
> +#endif

Why not stick this into a new kprobes-opt.c file?

> +
> +/*
> + * Recover the probed instruction at addr for further analysis.
> + * Caller must lock kprobes by kprobe_mutex, or disable preemption
> + * for preventing to release referencing kprobes.
> + */
> +static unsigned long recover_probed_instruction(kprobe_opcode_t *buf,
> +						unsigned long addr)
> +{
> +	struct kprobe *kp;
> +#ifdef CONFIG_OPTPROBES
> +	int i;
> +
> +	for (i = 0; i < RELATIVEJUMP_SIZE; i++) {
> +		kp = get_kprobe((void *)addr - i);
> +		if (kp && kprobe_optready(kp))
> +			return __recover_optprobed_insn(kp, buf, addr);
> +	}
> +#endif

This should be a separate, kprobes_recover_opt() method and be 
inside kprobes-opt.c as well.

Thanks,

	Ingo
