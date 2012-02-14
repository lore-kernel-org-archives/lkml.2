Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab2BNDk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:40:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab2BNDkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:11 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=Gihb1u4KezEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=UPm3pfgAAAAA:8 a=meVymXHHAAAA:8 a=iu57WdsQ5xXjiqTCFUwA:9 a=ZqOzGO9ICRuq6nBLeRsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=mOio7EKfaG4A:10 a=jeBq3FmKZ4MA:10 a=WQh05Z7aEuoJH3FBF5kA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034006.895838443@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 4/9] x86/tracing: Denote the power and cpuidle tracepoints as _rcuidle()
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0004-x86-tracing-Denote-the-power-and-cpuidle-tracepoints.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The power and cpuidle tracepoints are called within a rcu_idle_exit()
section, and must be denoted with the _rcuidle() version of the tracepoint.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/process.c    |   24 ++++++++++++------------
 include/trace/events/power.h |    2 ++
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..44eefde 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -377,8 +377,8 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
+		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
+		trace_cpu_idle_rcuidle(1, smp_processor_id());
 		current_thread_info()->status &=3D ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -391,8 +391,8 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |=3D TS_POLLING;
-		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+		trace_power_end_rcuidle(smp_processor_id());
+		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -450,8 +450,8 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 static void mwait_idle(void)
 {
 	if (!need_resched()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
+		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
+		trace_cpu_idle_rcuidle(1, smp_processor_id());
 		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
=20
@@ -461,8 +461,8 @@ static void mwait_idle(void)
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
-		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+		trace_power_end_rcuidle(smp_processor_id());
+		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	} else
 		local_irq_enable();
 }
@@ -474,13 +474,13 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
-	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
-	trace_cpu_idle(0, smp_processor_id());
+	trace_power_start_rcuidle(POWER_CSTATE, 0, smp_processor_id());
+	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-	trace_power_end(smp_processor_id());
-	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+	trace_power_end_rcuidle(smp_processor_id());
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
=20
 /*
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 1bcc2a8..14b3894 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -151,6 +151,8 @@ enum {
    events get removed */
 static inline void trace_power_start(u64 type, u64 state, u64 cpuid) {};
 static inline void trace_power_end(u64 cpuid) {};
+static inline void trace_power_start_rcuidle(u64 type, u64 state, u64 cpui=
d) {};
+static inline void trace_power_end_rcuidle(u64 cpuid) {};
 static inline void trace_power_frequency(u64 type, u64 state, u64 cpuid) {=
};
 #endif /* _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED */
=20
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeWAAoJEIy3vGnGbaoA87cP/2qZ7ZKbVrdFb0uC6gNJ9TOn
08Si/ogmUw8fYjWQbrEiUwWEQHteCH7tY9OEVewP8PiA8AQh9rsg6lWC3P/uBeDi
wrtX61/z7Bqf+4whAByxG7mvRlspLjv6QP6RTR0KmQP9BVLyh9i6ItMTmBZ90z50
B+OooK7HOTvuqFAv47ry9eIt7OmIRZYWkFCt/Mlffh953r5lOK2WN/N3rCBxahrF
PXDAQtfuVEiWm5R4wDs+IK8YKDU+R61KGRg7EqPeOVVlnk9xyYndq0+fmmHJZ63/
CnmhiGZ1COKXrwPIBWcsH07dMRq8akg7vy4qVyhOZMPD029sVMz/DWe6wKcPP07G
2e3RTf0sigTVC3GEzsSuRns8eiQDPJbO+aZU8San/zyV4SyGlTSnradlsSkhqj5Q
gD1sE94Vhscbog8YB8SZqIb82tbH2SvO+ELglED4cV07MIKzYAB1AbBmkZwmkx+p
PK32fzToduZWA2J5F5wKSIodhncunm+yzSR+qLxFBUi/bOn3VGmQ6Kb714l1wBbo
NTwi7m/maJIw7yjMhsUKcOFTOXoPYEJMYr9X5nr5KLVxws2bpvC8QXNnJgmX4n7G
LOYzyQDZhP2bKm0WaGku15IS/PVl9KpzPtE6HwDIW7IvIGluLm/cxIN8wTmVytdu
ngqZhP6HZ5dQkONYz1VI
=bxS7
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
