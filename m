Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0EYHcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:32:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43823 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab0EYHcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:32:54 -0400
Date: Tue, 25 May 2010 09:32:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100525073246.GA6085@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
References: <1274554806-28216-1-git-send-email-bp@alien8.de>
 <1274554806-28216-2-git-send-email-bp@alien8.de>
 <1274638513.1674.1727.camel@laptop>
 <20100523183353.GB1408@liondog.tnic>
 <1274640047.1674.1731.camel@laptop>
 <20100523185411.GA5608@liondog.tnic>
 <1274642601.1674.1755.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1274642601.1674.1755.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Sun, May 23, 2010 at 09:23:21PM +0200

> Either we add some notifier thing, or we simply add an explicit call in
> the init sequence after the perf_event subsystem is running. I would
> suggest we start with some explicit call, and take it from there.

Ok, this couldn't be more straightforward. So I looked at the init
sequence we do when booting wrt to perf/ftrace initialization:

start_kernel
...
|-> sched_init
    |-> perf_event_init
...
|-> ftrace_init
rest_init
kernel_init
|-> do_pre_smp_initcalls
|...
|-> smp_int
|-> do_basic_setup
    |-> do_initcalls

and one of the convenient places after both perf is initialized and
ftrace has enumerated the tracepoints is do_initcalls() (It cannot be an
early_initcall since at that time we're not running SMP yet and we want
the MCE event per cpu.)

So I added a core_initcall that registers the mce perf event. This makes
it more or less a persistent event without any changes to the perf_event
subsystem. I guess this should work - at least it builds here, will give
it a run later.

As a further enhancement, the init-function should read out all the
logged mce events which survived the warm reboot and those which happen
between mce init and the actual event registration so that perf can
postprocess those too at a more convenient time.

Thanks.

---
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8a6f0af..e3370a2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -94,6 +94,7 @@ static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
+static DEFINE_PER_CPU(struct perf_event *, mce_event);
 static int			cpu_missing;
 
 /*
@@ -1996,6 +1997,60 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	}
 }
 
+struct perf_event_attr pattr = {
+	.type	= PERF_TYPE_TRACEPOINT,
+	.size	= sizeof(pattr),
+};
+
+static int mcheck_enable_perf_event_on_cpu(int cpu)
+{
+	struct perf_event *event;
+
+	pattr.config = event_mce_record.id;
+
+	event = perf_event_create_kernel_counter(&pattr, cpu, -1, NULL);
+	if (IS_ERR(event))
+		return -EINVAL;
+
+	perf_event_enable(event);
+	per_cpu(mce_event, cpu) = event;
+
+	return 0;
+}
+
+static void mcheck_disable_perf_event_on_cpu(int cpu)
+{
+	struct perf_event *event = per_cpu(mce_event, cpu);
+
+	if (!event)
+		return;
+
+	perf_event_disable(event);
+	per_cpu(mce_event, cpu) = NULL;
+	perf_event_release_kernel(event);
+}
+
+static int mcheck_init_perf_event(void)
+{
+	int cpu, err;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu) {
+		err = mcheck_enable_perf_event_on_cpu(cpu);
+		if (err) {
+			printk(KERN_ERR "mce: error initializing mce tracepoint"
+					" on cpu %d\n", cpu);
+			return err;
+		}
+	}
+
+	put_online_cpus();
+
+	return 0;
+}
+core_initcall(mcheck_init_perf_event);
+
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
 static int __cpuinit
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -2009,6 +2064,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		mce_create_device(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
+		mcheck_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -2020,6 +2076,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE_FROZEN:
 		del_timer_sync(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+		mcheck_disable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
@@ -2029,6 +2086,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			add_timer_on(t, cpu);
 		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
+		mcheck_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_POST_DEAD:
 		/* intentionally ignoring frozen here */

-- 
Regards/Gruss,
    Boris.
