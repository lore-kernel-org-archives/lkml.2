Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2GQCIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:08:36 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40707 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2GQCId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:08:33 -0400
X-AuditID: b753bd60-a1c87ba000000655-69-5004c91e5e26
X-AuditID: b753bd60-a1c87ba000000655-69-5004c91e5e26
Message-ID: <5004C917.1060909@hitachi.com>
Date: Tue, 17 Jul 2012 11:08:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386
 function calls
References: <20120711195048.885039013@goodmis.org>  <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com> <1342205273.30075.19.camel@gandalf.stny.rr.com>
In-Reply-To: <1342205273.30075.19.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/14 3:47), Steven Rostedt wrote:
> On Thu, 2012-07-12 at 21:39 +0900, Masami Hiramatsu wrote:
> 
>> /*
>>  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
>>  * when it traps.  The previous stack will be directly underneath the saved
>>  * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
>>  *
>>  * This is valid only for kernel mode traps.
>>  */
>> static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
>> {
>> #ifdef CONFIG_X86_32
>>         return (unsigned long)(&regs->sp);
>> #else
>>         return regs->sp;
>> #endif
>> }
> 
> I found that regs_get_register() doesn't honor this either. Thus,
> kprobes in tracing gets this:
> 
>  # echo 'p:ftrace sys_read+4 s=%sp' > /debug/tracing/kprobe_events
>  # echo 1 > /debug/tracing/events/kprobes/enable
>  # cat trace
>             sshd-1345  [000] d...   489.117168: ftrace: (sys_read+0x4/0x70) s=b7e96768
>             sshd-1345  [000] d...   489.117191: ftrace: (sys_read+0x4/0x70) s=b7e96768
>              cat-1447  [000] d...   489.117392: ftrace: (sys_read+0x4/0x70) s=5a7
>              cat-1447  [001] d...   489.118023: ftrace: (sys_read+0x4/0x70) s=b77ad05f
>             less-1448  [000] d...   489.118079: ftrace: (sys_read+0x4/0x70) s=b7762e06
>             less-1448  [000] d...   489.118117: ftrace: (sys_read+0x4/0x70) s=b7764970
> 

Yes, that is by design, since I made it so. :)
Instead of %sp, kprobe tracer provides $stack special argument
for stack address, because "sp" is not always means the stack
address on every arch.

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


