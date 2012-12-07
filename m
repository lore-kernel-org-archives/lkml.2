Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2LHAJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:09:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2LHAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:09:03 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bWMJEInSIPkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=IsWhn5XDXJcA:10 a=kP7GwGC0Mzm_Np_U0tsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121207235615.206108556@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 07 Dec 2012 18:56:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC][PATCH RT 0/4] sched/rt: Lower rq lock contention latencies on many CPU boxes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been debugging large latencies on a 40 core box and found a major
cause due to the thundering herd like grab of the rq lock due to the
pull_rt_task() logic.

Basically, if a large number of CPUs were to lower its priority roughly
the same time, they would all trigger a pull. If there happens to be
only one CPU available to get a task, all CPUs doing the pull will try
to grab it. In doing so, they will all contend on the rq lock of
the overloaded CPU. Only one CPU will succeed in pulling the task
and unfortunately, there's no quick way to know which, as it's dependent
on the affinitiy of the task that needs to be pulled, and to look at that,
we need to grab its rq lock!

Instead of having the pull logic grab the rq locks and do the work to
switch the task over to the pulling CPU, this patch series (well patch
#3) has the pulling CPU send an IPI to the overloaded CPU and that
CPU will do the push instead. The push logic uses the cpupri.c code
to quickly find the best CPU to offload the overloaded RT task to, so
it makes it quite efficient to do this.

Retrieving multiple IPIs has a much lower overhead than all the CPUs
grabbing the rq lock.

The other three patches are fixes/enhancements to the push/pull code
that I found while doing the debugging of the latencies.

Note, although this patch series is made for the -rt patch, the issues
apply to mainline as well. But because -rt has the migrate_disable() code,
this patch series is tailored to that. But if we can vet this out in
-rt, all this code should make its way quickly to mainline.

I tested this code out, but it probably needs some clean up and definitely
more comments. I'm only posting this as an RFC for now to get feedback
on the idea.

Thanks!

-- Steve


