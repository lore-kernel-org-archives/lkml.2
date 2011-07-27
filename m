Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1G0REY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:04:24 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:33138 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754914Ab1G0REW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:04:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5farToAVM1ljiO1zkzOrrQ5Mvb7uaWIT1Hf50KMySpRxX0F
 Fh.vdAP9RzHTZpA2juitH9MSMWa7iAhsp7lqgbr8zAZasDBppNbt7lMKePVs
 uKvT_c6abapJEXwaT7PCA.hikt18Q4VrElxbn_jsd4hWGbMk6vO2VLrY.r6N
 edCqxyy58l7rwV3PA2mUBVZ1orJQtwTjDLoKNsR..q4kMHaqv0jgPxVrQ0rr
 l6OJUjqCv9LcXYJpcwS5VtSuW1RuZYoCZ8E6Qyo.BTNAe2mpX4qeUFqo4jQb
 BcPQ.wkUvPtHY1W3DsgIRjy5NzwxMTcoH52v.kzgIId7ue2KQ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 27 Jul 2011 12:04:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <1311784149.5890.181.camel@twins>
Message-ID: <alpine.DEB.2.00.1107271155410.13058@router.home>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home>  <1311768693.24752.488.camel@twins> <1311771677.24752.495.camel@twins>  <alpine.DEB.2.00.1107270916240.9418@router.home>  <1311783617.5890.179.camel@twins>
 <1311784149.5890.181.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Peter Zijlstra wrote:

> Also things like the below hunk are just plain ugly and obfuscate the
> code to safe one load at best. I'm sorely tempted to revert such crap.
>
> @@ -1468,14 +1465,12 @@ static void x86_pmu_start_txn(struct pmu *pmu)
>   */
>  static void x86_pmu_cancel_txn(struct pmu *pmu)
>  {
> -       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> -
> -       cpuc->group_flag &= ~PERF_EVENT_TXN;
> +       __this_cpu_and(cpu_hw_events.group_flag, ~PERF_EVENT_TXN);
>         /*
>          * Truncate the collected events.
>          */
> -       cpuc->n_added -= cpuc->n_txn;
> -       cpuc->n_events -= cpuc->n_txn;
> +       __this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
> +       __this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
>         perf_pmu_enable(pmu);
>  }

Yea that is pretty ugly and went overboard. Too many segment
overrides there. The following patch will make that easier to read. We
could also remove the whole hunk. __this_cpu ops there only causes the
generation of simple xadds avoiding register operations.

---
 arch/x86/kernel/cpu/perf_event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c	2011-07-27 11:59:35.000000000 -0500
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c	2011-07-27 12:03:41.000000000 -0500
@@ -1612,12 +1612,14 @@ static void x86_pmu_start_txn(struct pmu
  */
 static void x86_pmu_cancel_txn(struct pmu *pmu)
 {
+	int x = __this_cpu_read(cpu_hw_events.n_txn);
+
 	__this_cpu_and(cpu_hw_events.group_flag, ~PERF_EVENT_TXN);
 	/*
 	 * Truncate the collected events.
 	 */
-	__this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
-	__this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
+	__this_cpu_sub(cpu_hw_events.n_added, x);
+	__this_cpu_sub(cpu_hw_events.n_events, x);
 	perf_pmu_enable(pmu);
 }





