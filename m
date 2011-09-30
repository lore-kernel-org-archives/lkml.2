Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1I3RAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:00:10 -0400
Received: from claw.goop.org ([74.207.240.146]:45667 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1I3RAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:00:09 -0400
Message-ID: <4E85F596.4050704@goop.org>
Date: Fri, 30 Sep 2011 10:00:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] stop_machine: make stop_machine safe and efficient
 to call early
References: <4E85EE1F.7050508@goop.org> <1317400496.4588.54.camel@gandalf.stny.rr.com>
In-Reply-To: <1317400496.4588.54.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 09:34 AM, Steven Rostedt wrote:
> Doesn't interrupts need to be disabled here too? As stop machine
> functions also guarantee that they will not be interrupted by
> interrupts. -- Steve

Good point.

    J

Make stop_machine() safe to call early in boot, before SMP has been
set up, by simply calling the callback function directly if there's
only one CPU online.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index ba5070c..a45b36d 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -485,6 +485,17 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (smdata.num_threads == 1) {
+		unsigned long flags;
+		int ret;
+
+		local_save_flags(flags);
+		ret = (*fn)(data);
+		local_irq_restore(flags);
+
+		return ret;
+	}
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);


