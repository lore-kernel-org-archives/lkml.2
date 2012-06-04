Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737Ab2FDO5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:57:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54258 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760716Ab2FDO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:57:47 -0400
X-AuditID: b753bd60-a2688ba000000655-45-4fcccce84dd0
X-AuditID: b753bd60-a2688ba000000655-45-4fcccce84dd0
Message-ID: <4FCCCCE6.5000606@hitachi.com>
Date: Mon, 04 Jun 2012 23:57:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: Re: [RFC PATCH -tip  1/9] ftrace: Add pt_regs acceptable
 trace callback
References: <20120529124833.9191.23007.stgit@localhost.localdomain>   <20120529124857.9191.5868.stgit@localhost.localdomain>  <1338602877.13348.474.camel@gandalf.stny.rr.com>  <4FCCBEE9.8030006@hitachi.com> <1338819915.13348.508.camel@gandalf.stny.rr.com>
In-Reply-To: <1338819915.13348.508.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/04 23:25), Steven Rostedt wrote:
> On Mon, 2012-06-04 at 22:58 +0900, Masami Hiramatsu wrote:
> 
>> Hmm, how about initializing in __init function ?
>> Or we can make func and regs_func in different members,
>> instead of using a union. (in that case, we can remove
>> FTRACE_OPS_FL_SAVE_REGS.)
>> I just consider passing uninitialized argument to user
>> function can cause unexpected behavior...
> 
> Easy solution:
> 
> As I want all functions to pass the ftrace_ops anyway, we can implement
> the ftrace_ops and the regs passing together. The arch will need to
> update both at the same time.

Hmm, is that ftrace_ops for recursion check? :)

> 
> But for archs that do not support ftrace_ops (and thus also not regs),
> we can do (and I will do this):
> 
> static inline void
>  __global_list_func(unsigned long ip, unsigned long parent_ip,
> 			struct ftrace_ops *ops, struct pt_regs *regs)
> {
> 	[do the loop, ignoring ops anyway, but passing in regs]
> }
> 
> #ifndef ARCH_SUPPORTS_FTRACE_OPS
> static void
> noregs_global_list_func(unsigned long ip, unsigned long parent_ip)
> {
> 	__global_list_func(ip, parent_ip, NULL, NULL);
> }
> #define global_list_func (ftrace_func_t)noregs_global_list_func
> #else
> static void global_list_func(unsigned long ip, unsigned long parent_ip,
> 			struct ftrace_ops *ops, struct pt_regs *regs)
> {
> 	__global_list_func(ip, parent_ip, ops, regs);
> }
> #endif
> 
> 
> 
> Nothing will be passed uninitialized. If an arch does not support
> passing ftrace ops and regs, then it will be calling the
> noregs_global_list_func() (or whatever I name it), which only expects
> the ip and parent_ip as parameters. Then that will be calling the actual
> loop function with NULLs in the parameters.

Yeah, that's safe, but I think dyn_ftrace can't call handler
directly from ftrace_call on such archs, can it?
# It depends on performance degradation.

> When an arch supports passing of ftrace_ops, then it should also support
> passing in the regs (as that should be the trivial part).

Preparing pt_regs by software is hard on some archs, e.g. IA64.
But yeah, that's an obsolete arch. We'd better focus on x86 and
ARM variants.

> Note, all funcs will get regs, but it may not get the full regs. That
> requires the ftrace_ops setting the special flag. The regs are saved for
> the mcount already. But only a partial set. Those will be sent to all
> function callbacks. If the function call back requires a full set (like
> kprobes does), then it must set the flag before registering.

Just out of curiously, would you mean that you will allocate full
pt_regs frame on stack always?

> 
> Hows this sound?

Sounds better to me, at far as there are non-initialized parameters
passed to user handler. :)

BTW, would you like to update ftrace part? I'd like to fix to remove
notrace from my previous patchset and resend tomorrow.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
