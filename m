Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1BARwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:52:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61154 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1BARwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=odINw7VrQy6F5zr7gZ5JaxYoaVvvihteuf2wE1IWjosefCBG9pG8U5DiEy9DG8eGb/
         lj0aaWZqdhFZIK1mMz9gFAcLdWbPMdWJS37vzs+ZMJJcMdSxDGvqYswZpInOQEIRyNxf
         3c4KgB6QRbsh9lfaeVySYzw6gYyaz+ICA+FqY=
Message-ID: <4D484853.9020409@gmail.com>
Date: Tue, 01 Feb 2011 20:52:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU
 0.
References: <20110201162703.2284.qmail@science.horizon.com>
In-Reply-To: <20110201162703.2284.qmail@science.horizon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 07:27 PM, George Spelvin wrote:
> Since upgrading to -rc2 (-rc3 is compiling right now), I've been getting
> complaints at irregular intervals.  This didn't used to happen with 2.6.37.
> 
...
> Should I bisect this, or does someone know what might be happening?
> 
> Thank you!
> 

 I fear it's known issue at moment, we're trying to resolve it. There is
an option -- to disable nmi_watchdog (nmi_watchdog=0 boot option).

 But if you have a will or would like to help debug the problem -- mind to
try the patch below? Note the patch is ugly at moment and must *not* be
running on non-P4 system (and I only compile-tested it so no guarantees
at all, and I've CC'ed a couple of people as well)

    Cyrill

---
 arch/x86/kernel/cpu/perf_event.c    |   12 +++++++++++-
 arch/x86/kernel/cpu/perf_event_p4.c |    8 +++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -1075,7 +1075,17 @@ static void x86_pmu_start(struct perf_ev

 	cpuc->events[idx] = event;
 	__set_bit(idx, cpuc->active_mask);
-	__set_bit(idx, cpuc->running);
+	if (1) {
+		/* running mask is shared across a core */
+		int leader_cpu;
+		struct cpu_hw_events *leader_cpuc;
+
+		leader_cpu	= cpumask_first(__get_cpu_var(cpu_sibling_map));
+		leader_cpuc	= &per_cpu(cpu_hw_events, leader_cpu);
+
+		__set_bit(idx, leader_cpuc->running);
+	} else
+		__set_bit(idx, cpuc->running);
 	x86_pmu.enable(event);
 	perf_event_update_userpage(event);
 }
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -907,8 +907,14 @@ static int p4_pmu_handle_irq(struct pt_r
 		int overflow;

 		if (!test_bit(idx, cpuc->active_mask)) {
+			int leader_cpu;
+			struct cpu_hw_events *leader_cpuc;
+
+			leader_cpu	= cpumask_first(__get_cpu_var(cpu_sibling_map));
+			leader_cpuc	= &per_cpu(cpu_hw_events, leader_cpu);
+
 			/* catch in-flight IRQs */
-			if (__test_and_clear_bit(idx, cpuc->running))
+			if (__test_and_clear_bit(idx, leader_cpuc->running))
 				handled++;
 			continue;
 		}

