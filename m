Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1FGTMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:12:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:12353 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077Ab1FGTM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,333,1304319600"; 
   d="scan'208";a="8702119"
Subject: Re: [patch 1/2] stop_machine: enable __stop_machine() to be called
 from the cpu online path
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4DEE712F.3080800@zytor.com>
References: <20110606231655.824641917@sbsiddha-MOBL3.sc.intel.com>
	 <20110606231752.023885847@sbsiddha-MOBL3.sc.intel.com>
	 <20110607180244.GA27552@elte.hu>
	 <1307471902.21608.4476.camel@sbsiddha-MOBL3.sc.intel.com>
	 <4DEE712F.3080800@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 07 Jun 2011 12:12:37 -0700
Message-Id: <1307473957.21608.4480.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 11:42 -0700, H. Peter Anvin wrote:
> On 06/07/2011 11:38 AM, Suresh Siddha wrote:
> > 
> > This is kind of a false positive. We are just checking if the calling
> > cpu is online/offline (and there is no possible process migration
> > between an online and offline cpu).
> > 
> 
> Is the state not available in a percpu variable of some sort?  If not,
> shouldn't it be rather than indirecting via a CPU number?

This is what I first thought about but the current percpu cpu_state is
arch specific and not all architectures define it.

Thinking a bit more, I should be able to use the stop machine's percpu
thread state and use it here. Something like the appended. I am testing
and will send the modified patches shortly.

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index c78b0c2..97a1770 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -153,7 +153,7 @@ static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
  */
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 {
-	int online = cpu_online(smp_processor_id());
+	int online = percpu_read(cpu_stopper.enabled);
 	int include_this_offline = 0;
 	struct cpu_stop_work *work;
 	struct cpu_stop_done done;
@@ -513,13 +513,13 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 					    .active_cpus = cpus };
 
 	/* Include the calling cpu that might not be online yet. */
-	if (!cpu_online(smp_processor_id()))
+	if (!percpu_read(cpu_stopper.enabled))
 		smdata.num_threads++;
 
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
 
-	if (cpu_online(smp_processor_id()))
+	if (percpu_read(cpu_stopper.enabled))
 		return stop_cpus(cpu_online_mask, stop_machine_cpu_stop,
 				 &smdata);
 	else


