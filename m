Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0JLCOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 22:14:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55517 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750Ab0JLCOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 22:14:06 -0400
Date: Tue, 12 Oct 2010 13:13:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the oprofile tree with the tip tree
Message-Id: <20101012131359.5ade7129.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Today's linux-next merge of the oprofile tree got a conflict in
kernel/perf_event.c between commit
33696fc0d141bbbcb12f75b69608ea83282e3117 ("perf: Per PMU disable") from
the tip tree and commit 84c7991059c9c4530cc911137c5bf508a41ed129 ("perf:
New helper function for pmu name") from the oprofile tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/perf_event.c
index 64507ea,fc51268..0000000
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@@ -61,38 -67,41 +61,43 @@@ int sysctl_perf_event_sample_rate __rea
  
  static atomic64_t perf_event_id;
  
 -/*
 - * Lock for (sysadmin-configurable) event reservations:
 - */
 -static DEFINE_SPINLOCK(perf_resource_lock);
 +void __weak perf_event_print_debug(void)	{ }
  
 -/*
 - * Architecture provided APIs - weak aliases:
 - */
 -extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
 +void perf_pmu_disable(struct pmu *pmu)
  {
 -	return NULL;
 +	int *count = this_cpu_ptr(pmu->pmu_disable_count);
 +	if (!(*count)++)
 +		pmu->pmu_disable(pmu);
  }
  
 -void __weak hw_perf_disable(void)		{ barrier(); }
 -void __weak hw_perf_enable(void)		{ barrier(); }
 -
 -void __weak perf_event_print_debug(void)	{ }
 -
+ extern __weak const char *perf_pmu_name(void)
+ {
+ 	return "pmu";
+ }
+ 
 -static DEFINE_PER_CPU(int, perf_disable_count);
 -
 -void perf_disable(void)
 +void perf_pmu_enable(struct pmu *pmu)
  {
 -	if (!__get_cpu_var(perf_disable_count)++)
 -		hw_perf_disable();
 +	int *count = this_cpu_ptr(pmu->pmu_disable_count);
 +	if (!--(*count))
 +		pmu->pmu_enable(pmu);
  }
  
 -void perf_enable(void)
 +static DEFINE_PER_CPU(struct list_head, rotation_list);
 +
 +/*
 + * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
 + * because they're strictly cpu affine and rotate_start is called with IRQs
 + * disabled, while rotate_context is called from IRQ context.
 + */
 +static void perf_pmu_rotate_start(struct pmu *pmu)
  {
 -	if (!--__get_cpu_var(perf_disable_count))
 -		hw_perf_enable();
 +	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 +	struct list_head *head = &__get_cpu_var(rotation_list);
 +
 +	WARN_ON(!irqs_disabled());
 +
 +	if (list_empty(&cpuctx->rotation_list))
 +		list_add(&cpuctx->rotation_list, head);
  }
  
  static void get_ctx(struct perf_event_context *ctx)
