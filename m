Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab1I3Q2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:28:21 -0400
Received: from claw.goop.org ([74.207.240.146]:45590 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1I3Q2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:28:19 -0400
Message-ID: <4E85EE1F.7050508@goop.org>
Date: Fri, 30 Sep 2011 09:28:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC] stop_machine: make stop_machine safe and efficient to
 call early
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index ba5070c..2df15ca 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -485,6 +485,9 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (smdata.num_threads == 1)
+		return (*fn)(data);
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);


