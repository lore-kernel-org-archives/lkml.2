Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab2E3H4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:56:31 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41403 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2E3H4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:56:30 -0400
X-AuditID: b753bd60-9f483ba000000655-87-4fc5d2ac9c7b
X-AuditID: b753bd60-9f483ba000000655-87-4fc5d2ac9c7b
Message-ID: <4FC5D2A9.3000309@hitachi.com>
Date: Wed, 30 May 2012 16:56:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: ananth@in.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip  8/9] kprobes: introduce ftrace based optiomization
References: <20120529124833.9191.23007.stgit@localhost.localdomain> <20120529124944.9191.81924.stgit@localhost.localdomain> <20120530072202.GA29068@in.ibm.com>
In-Reply-To: <20120530072202.GA29068@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/30 16:22), Ananth N Mavinakayanahalli wrote:
> On Tue, May 29, 2012 at 09:49:45PM +0900, Masami Hiramatsu wrote:
>> Introduce function trace based kprobes optimization.
>>
>> With using ftrace optimization, kprobes on the mcount calling
>> address, use ftrace's mcount call instead of breakpoint.
>> Farthermore, this optimization works with preemptive kernel
>> not like as current jump-based optimization. Of cource,
>> this feature is limited only if the probe on mcount call.
> 
> The above paragraph doesn't parse correctly for me. Do you mean to say
> if the probe is on the mcount calling address, use the jump based
> approach instead of the breakpoint one? Could you please rephrase?

Right, but not use current jump-base one, but use function
tracer handler directly.

So, ftrace-based optimization will be done on the kprobe at
the mcount calling address, which has been replaced with a
5 byte NOP at the build-time.
The ftrace-based optimization uses function-tracer handler
(kernel/trace/ftrace.c) instead of int3 breakpoint trapping.

The probing behavior is like below

1. hit mcount calling address
2. call ftrace_caller
  -> 3. save all registers
     4. call ftrace's handler (kprobe_ftrace_handler)
       -> 5. set up current kprobe
          6. call kprobe handler
       <- 7. return
     8. restore registers
  <- 9. return
10. continue to run

>> +static void __kprobes kprobe_ftrace_init(void)
>> +{
>> +	int ret;
>> +
>> +	ret = register_ftrace_function(&kprobe_ftrace_ops);
>> +	WARN(ret < 0, "Failed to init kprobe-ftrace (%d)\n", ret);
>> +
>> +	kprobe_ftrace_enabled = 1;
> 
> Hmm.. is this right? kprobe_ftrace_enabled is 1 even if the init failed.

Oops, that should be a bug! thanks!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
