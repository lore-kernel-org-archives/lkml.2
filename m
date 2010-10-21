Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0JULOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:14:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab0JULOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:14:19 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=LuwKl7ggZIAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4BKNm4wy7LaF7vkoOuIA:9 a=EjixQbyAtvvveGDfHqtCAD8o1bEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20101020154045.GA18353@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu>  <20101020154045.GA18353@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Oct 2010 07:14:16 -0400
Message-ID: <1287659656.16971.573.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 17:40 +0200, Ingo Molnar wrote:
> FYI, there's a new mystery hang (sometimes crash) that triggers in -tip - and which 
> seems to be tracing related. See the crashlog below - config attached.
> 
> It's not bisectable - small changes in the kernel make the bug come/go. (might be a 
> race of some sorts)
> 


> [   42.324027] Testing all events: 
> [  245.668090] INFO: task swapper:1 blocked for more than 120 seconds.
> [  245.672051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  245.676026] swapper       D f6420b40  6544     1      0 0x00000000
> [  245.684051]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> [  245.692237]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> [  245.701068]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> [  245.709071] Call Trace:
> [  245.711551]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> [  245.712036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  245.716037]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> [  245.720061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> [  245.724036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> [  245.728036]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> [  245.732062]  [<c102de32>] ? default_wake_function+0x0/0x12
> [  245.736041]  [<c1a7e863>] wait_for_completion+0x17/0x19
> [  245.740069]  [<c10667a2>] __stop_cpus+0xdd/0x103
> [  245.744072]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> [  245.748040]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> [  245.752040]  [<c106683d>] stop_cpus+0x2c/0x3f
> [  245.756069]  [<c10668af>] __stop_machine+0x5f/0x67
> [  245.760186]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  245.764040]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> [  245.768071]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> [  245.772040]  [<c10060fd>] text_poke_smp+0x3a/0x42
> [  245.776039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde


> [  245.780098]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> [  245.784042]  [<c104ef0d>] jump_label_update+0x49/0x98

Looks like this code had jump labels enabled. Do you have a dump where
they are not enabled?

-- Steve

> [  245.788041]  [<c1070b33>] tracepoint_update_probe_range+0xec/0x116
> [  245.792070]  [<c1070c74>] tracepoint_probe_unregister+0x51/0x6b
> [  245.796040]  [<c107f3c0>] ftrace_event_reg+0x48/0x4c
> [  245.800041]  [<c107e87c>] ftrace_event_enable_disable+0x39/0x8a
> [  245.804070]  [<c107ebdf>] __ftrace_set_clr_event+0x91/0xbc
> [  245.808043]  [<c1fbee72>] event_trace_self_tests+0x1cd/0x239
> [  245.812040]  [<c1fbf025>] event_trace_self_tests_init+0x2a/0x39
> [  245.816230]  [<c1fab282>] do_one_initcall+0x47/0x113
> [  245.820069]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  245.824040]  [<c1fbeffb>] ? event_trace_self_tests_init+0x0/0x39
> [  245.828069]  [<c1fab477>] kernel_init+0x10d/0x18e
> [  245.832040]  [<c1fab36a>] ? kernel_init+0x0/0x18e
> [  245.836040]  [<c1002c7e>] kernel_thread_helper+0x6/0x10


