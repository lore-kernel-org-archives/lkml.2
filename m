Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0CQJwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:52:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:14623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0CQJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:52:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=KSJ7c5wtQii3e4X9hM+bhUUnzGv+Ez42rSeI0ozOd8kZ1xwM0YFaHnPL8oK5Mbf8c
	eOU3+ZvdPfXg629witzDw==
Message-ID: <4ba0a646.25e2660a.1b25.531c@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 17 Mar 2010 10:40:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: fix bug in AMD per-cpu initialization
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	On AMD processors, we need to allocate a data structure per Northbridge
	to handle certain events.

	On CPU initialization, we need to query the Northbridge id and check
	whether the structure is already allocated or not. We use the
	amd_get_nb_id() function to request the Northbridge identification.

	The recent cleanup of the CPU online/offline initialization introduced
	a bug. AMD cpu initialization is invoked on CPU_UP_PREPARE callback.
	This is before the CPU Northbridge id is calculated. Therefore no
	processor had a Northbridge structure allocated except the boot
	processor. That was causing bogus NB event scheduling.

	This patch uses the CPU_ONLINE callback to initialize the AMD
	Northbridge structure. This way amd_get_nb_id() returns valid
	information.

	The x86_cpu_up() callback was added. Could not call it cpu_online
	because of existing macro.

	Signed-off-by: Stephane Eranian <eranian@google.com>
	
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 978d297..016c25a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -213,6 +213,7 @@ struct x86_pmu {
 	void		(*quirks)(void);
 
 	void		(*cpu_prepare)(int cpu);
+	void		(*cpu_up)(int cpu);
 	void		(*cpu_starting)(int cpu);
 	void		(*cpu_dying)(int cpu);
 	void		(*cpu_dead)(int cpu);
@@ -1342,6 +1343,11 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 			x86_pmu.cpu_starting(cpu);
 		break;
 
+	case CPU_ONLINE:
+		if (x86_pmu.cpu_up)
+			x86_pmu.cpu_up(cpu);
+		break;
+
 	case CPU_DYING:
 		if (x86_pmu.cpu_dying)
 			x86_pmu.cpu_dying(cpu);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 358a8e3..584df49 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -346,6 +346,9 @@ static void amd_pmu_cpu_offline(int cpu)
 
 	cpuhw = &per_cpu(cpu_hw_events, cpu);
 
+	if (!cpuhw->amd_nb)
+		return;
+
 	raw_spin_lock(&amd_nb_lock);
 
 	if (--cpuhw->amd_nb->refcnt == 0)
@@ -379,7 +382,7 @@ static __initconst struct x86_pmu amd_pmu = {
 	.get_event_constraints	= amd_get_event_constraints,
 	.put_event_constraints	= amd_put_event_constraints,
 
-	.cpu_prepare		= amd_pmu_cpu_online,
+	.cpu_up			= amd_pmu_cpu_online,
 	.cpu_dead		= amd_pmu_cpu_offline,
 };
 
