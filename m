Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab2EaTTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:19:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57107 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab2EaTTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:19:41 -0400
Message-ID: <4FC7C43B.3070106@zytor.com>
Date: Thu, 31 May 2012 12:19:23 -0700
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
Subject: Re: [PATCH 3/5] x86: Reset the debug_stack update counter
References: <20120531012829.160060586@goodmis.org> <20120531020441.165841749@goodmis.org>
In-Reply-To: <20120531020441.165841749@goodmis.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 06:28 PM, Steven Rostedt wrote:
>> 
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c index
> 9087527..c1fffc5 100644 --- a/arch/x86/kernel/nmi.c +++
> b/arch/x86/kernel/nmi.c @@ -450,8 +450,10 @@ static inline void
> nmi_nesting_preprocess(struct pt_regs *regs)
> 
> static inline void nmi_nesting_postprocess(void) { -	if
> (unlikely(__get_cpu_var(update_debug_stack))) +	if
> (unlikely(__get_cpu_var(update_debug_stack))) { 
> debug_stack_reset(); +		__get_cpu_var(update_debug_stack) = 0; +	} 
> } #endif
> 

Please don't use __get_cpu_var(); it causes a pointer to be manifest,
which is free or almost free on most architectures but quite expensive
on x86.

Instead use this_cpu_read()/this_cpu_write().

Consider:

#include <linux/types.h>
#include <linux/percpu.h>

static DEFINE_PER_CPU(int, percpu_test);

int read_foo(void)
{
	return __get_cpu_var(percpu_test);
}

void write_foo(int x)
{
	__get_cpu_var(percpu_test) = x;
}

int read_bar(void)
{
	return this_cpu_read(percpu_test);
}

void write_bar(int x)
{
	this_cpu_write(percpu_test, x);
}

... and the corresponding assembly code (with gcc boilerplate removed):

read_foo:
        movq    $percpu_test, %rax      #, tcp_ptr__
        add %gs:this_cpu_off, %rax      # this_cpu_off, tcp_ptr__
        movl    (%rax), %eax    # *D.8429_3, *D.8429_3
        ret

write_foo:
        movq    $percpu_test, %rax      #, tcp_ptr__
        add %gs:this_cpu_off, %rax      # this_cpu_off, tcp_ptr__
        movl    %edi, (%rax)    # x, *D.8435_3
        ret

read_bar:
        movl %gs:percpu_test,%eax       # percpu_test, pfo_ret__

write_bar:
        movl %edi,%gs:percpu_test       # x, percpu_test
        ret

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

