Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2B1CxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:53:00 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37325 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab2B1Cw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:52:59 -0500
X-AuditID: b753bd60-9b8c6ba00000029c-a2-4f4c41880624
X-AuditID: b753bd60-9b8c6ba00000029c-a2-4f4c41880624
Message-ID: <4F4C4182.1040706@hitachi.com>
Date: Tue, 28 Feb 2012 11:52:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        systemtap@sourceware.org, anderson@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: Re: [PATCH v3 -tip] [BUGFIX] x86/kprobes: Fix to recover instructions
 on optimized path
References: <20120223083703.GA26781@elte.hu> <20120224095412.8462.55698.stgit@localhost.localdomain> <20120227093421.GA10078@elte.hu>
In-Reply-To: <20120227093421.GA10078@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/27 18:34), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> +
>> +#ifdef CONFIG_OPTPROBES
>> +static unsigned long __recover_optprobed_insn(struct kprobe *kp,
>> +					      kprobe_opcode_t *buf,
>> +					      unsigned long addr)
>> +{
>> +	long offs = addr - (unsigned long)kp->addr - 1;
>> +	struct optimized_kprobe *op = container_of(kp, struct optimized_kprobe, kp);
>> +
>> +	/*
>> +	 * If the kprobe can be optimized, original bytes which can be
>> +	 * overwritten by jump destination address. In this case, original
>> +	 * bytes must be recovered from op->optinsn.copied_insn buffer.
>> +	 */
>> +	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
>> +	if (addr == (unsigned long)kp->addr) {
>> +		buf[0] = kp->opcode;
>> +		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
>> +	} else
>> +		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
>> +
>> +	return (unsigned long)buf;
>> +}
>> +#endif
> 
> Why not stick this into a new kprobes-opt.c file?

Would you mean that I should split all optprobe stuffs
into new file?

> 
>> +
>> +/*
>> + * Recover the probed instruction at addr for further analysis.
>> + * Caller must lock kprobes by kprobe_mutex, or disable preemption
>> + * for preventing to release referencing kprobes.
>> + */
>> +static unsigned long recover_probed_instruction(kprobe_opcode_t *buf,
>> +						unsigned long addr)
>> +{
>> +	struct kprobe *kp;
>> +#ifdef CONFIG_OPTPROBES
>> +	int i;
>> +
>> +	for (i = 0; i < RELATIVEJUMP_SIZE; i++) {
>> +		kp = get_kprobe((void *)addr - i);
>> +		if (kp && kprobe_optready(kp))
>> +			return __recover_optprobed_insn(kp, buf, addr);
>> +	}
>> +#endif
> 
> This should be a separate, kprobes_recover_opt() method and be 
> inside kprobes-opt.c as well.

OK, I'll do that. But I think it should be separated work.
Just for the bugfix, I think this should go into this style,
because this should be pushed into stable tree too.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
