Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2DZKNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:13:07 -0400
Received: from [133.145.228.5] ([133.145.228.5]:37541 "EHLO
	mail4.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2DZKNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:13:05 -0400
X-AuditID: b753bd60-9f483ba000000655-59-4f991f9b2225
X-AuditID: b753bd60-9f483ba000000655-59-4f991f9b2225
Message-ID: <4F991F99.8050301@hitachi.com>
Date: Thu, 26 Apr 2012 19:12:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 6/6][RFC] kprobes: Allow probe on ftrace reserved text
 (but move it)
References: <20120426022922.683707508@goodmis.org> <20120426023708.577576476@goodmis.org>
In-Reply-To: <20120426023708.577576476@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/26 11:29), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> If a probe is placed on a ftrace nop (or ftrace_caller), simply move the
> probe to the next instruction instead of rejecting it. This will allow
> kprobes not to be affected by ftrace using the -mfentry gcc option which
> will put the ftrace nop at the beginning of the function. As a very common
> case for kprobes is to add a probe to the very beginning of a function
> we need a way to handle the case when ftrace takes the first instruction.

Hmm, I think you'd better introduce a flag(KPROBE_FLAG_MOVED) for
adjustment of probed IP address. Caller or handler can fixup its IP
or kprobes itself can do it.

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/kprobes.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index c62b854..560d80e 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1319,10 +1319,20 @@ int __kprobes register_kprobe(struct kprobe *p)
>  	struct kprobe *old_p;
>  	struct module *probed_mod;
>  	kprobe_opcode_t *addr;
> +	unsigned long ftrace_addr;
>  
>  	addr = kprobe_addr(p);
>  	if (IS_ERR(addr))
>  		return PTR_ERR(addr);
> +
> +	/*
> +	 * If the address is located on a ftrace nop, set the
> +	 * breakpoint to the following instruction.
> +	 */
> +	ftrace_addr = ftrace_location((unsigned long)addr);
> +	if (unlikely(ftrace_addr))
> +		addr = (kprobe_opcode_t *)(ftrace_addr + MCOUNT_INSN_SIZE);

And also, you may need to use ftrace_text_reserved() here,
or need a void ftrace_location() function for CONFIG_DYNAMIC_FTRACE=n.

> +
>  	p->addr = addr;
>  
>  	ret = check_kprobe_rereg(p);
> @@ -1333,7 +1343,6 @@ int __kprobes register_kprobe(struct kprobe *p)
>  	preempt_disable();
>  	if (!kernel_text_address((unsigned long) p->addr) ||
>  	    in_kprobes_functions((unsigned long) p->addr) ||
> -	    ftrace_text_reserved(p->addr, p->addr) ||
>  	    jump_label_text_reserved(p->addr, p->addr)) {
>  		ret = -EINVAL;
>  		goto cannot_probe;

Thanks,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
