Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0CXOxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:53:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60118 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab0CXOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:53:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=rRAZH+tpOE4ruiWTh7hwVdzsCAqsZjYViMhPlyuYQnGf8xd9Fz/Pz/ot0Ir4l5LAd
	eu+fonb79MR52/LoAee2A==
Message-ID: <4baa2770.1090cc0a.5d93.076c@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 24 Mar 2010 15:45:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, hpa@zytor.com,
       tglx@linutronix.de, manfred@colorfullife.com
Subject: [PATCH] perf_events: fix bug in AMD per-cpu initialization
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Crap, you're right, either notify_cpu_starting() is done too early or
> smp_store_cpu_info() is done too late.
> 
> Since smp_store_cpu_info() relies on the result of calibrate_delay() we
> can't easily change that order, but since there really isn't any other
> CPU_STARTING user in tree (I appear to have created the first?!) we can
> easily move that notifier thing later.
> 
> (What's up with that IRQ-enable over calibrate_delay(), can't we simply
> enable the NMI watchdog later?)
> 
> So I guess something like the below should work:

The patch does work for me. I made two small modifications by
adding amd_has_nb() such that the correct checking is for on amd_nb.

	Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index a61e54b..6204739 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -137,6 +137,13 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 	return (hwc->config & 0xe0) == 0xe0;
 }
 
+static inline int amd_has_nb(struct cpu_hw_events *cpuc)
+{
+	struct amd_nb *nb = cpuc->amd_nb;
+
+	return nb && nb->nb_id != -1;
+}
+
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 				      struct perf_event *event)
 {
@@ -147,7 +154,7 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 	/*
 	 * only care about NB events
 	 */
-	if (!(nb && amd_is_nb_event(hwc)))
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
 		return;
 
 	/*
@@ -214,7 +221,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	/*
 	 * if not NB event or no NB, then no constraints
 	 */
-	if (!(nb && amd_is_nb_event(hwc)))
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
 		return &unconstrained;
 
 	/*
