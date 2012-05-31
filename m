Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab2EaS6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:58:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56591 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab2EaS6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:58:53 -0400
Message-ID: <4FC7BF59.3070906@zytor.com>
Date: Thu, 31 May 2012 11:58:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
References: <20120531012829.160060586@goodmis.org> <20120531020441.500105258@goodmis.org>
In-Reply-To: <20120531020441.500105258@goodmis.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 06:28 PM, Steven Rostedt wrote:
> 
> diff --git a/arch/x86/kernel/cpu/common.c
> b/arch/x86/kernel/cpu/common.c index 82f29e7..63fc083 100644 ---
> a/arch/x86/kernel/cpu/common.c +++ b/arch/x86/kernel/cpu/common.c 
> @@ -1101,14 +1101,20 @@ int is_debug_stack(unsigned long addr) addr
> > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ)); }
> 
> +static DEFINE_PER_CPU(atomic_t, debug_idt_zero); + void
> debug_stack_set_zero(void) { +
> atomic_inc(&__get_cpu_var(debug_idt_zero)); load_idt((const struct
> desc_ptr *)&nmi_idt_descr); }
> 
> void debug_stack_reset(void) { -	load_idt((const struct desc_ptr
> *)&idt_descr); +	if
> (WARN_ON(!atomic_read(&__get_cpu_var(debug_idt_zero)))) +		return; 
> +	if (atomic_dec_and_test(&__get_cpu_var(debug_idt_zero))) +
> load_idt((const struct desc_ptr *)&idt_descr); }
> 

What you have here is a nesting counter, which is good, but I have
some objections to the implementation.

The name "debug_idt_zero" doesn't convey a counter in any way, shape
or form; perhaps debug_stack_users or something like that.

Since this is percpu, there is no reason to use the atomic operations
(globally locked!), and since it is on the local CPU there is no need
to manifest a pointer; we can instead use this_cpu_inc/dec_return:

static DEFINE_PER_CPU(u32, debug_stack_use_ctr);

void debug_stack_set_zero(void)
{
	if (this_cpu_inc_return(debug_stack_use_ctr) == 1)
	 	load_idt((const struct desc_ptr *)&nmi_idt_descr);
}

void debug_stack_reset(void)
{
	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
		load_idt((const struct desc_ptr *)&idt_descr);
}

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
