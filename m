Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2CGHAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 02:00:10 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:48320 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2CGHAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 02:00:08 -0500
Date: Wed, 7 Mar 2012 08:00:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 5/5] s390: Use common fork_idle_from_wq in smpboot
Message-ID: <20120307070000.GA4426@osiris.boeblingen.de.ibm.com>
References: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
 <1331070074-31717-1-git-send-email-venki@google.com>
 <1331070074-31717-6-git-send-email-venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331070074-31717-6-git-send-email-venki@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030707-0542-0000-0000-00000131DE7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 01:41:14PM -0800, Venkatesh Pallipadi wrote:
> Cleanup. Instead of reimplementing fork_idle on wq and idle task caching,
> use fork_idle_from_wq().
> 
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> ---
>  arch/s390/kernel/smp.c |   38 +++++---------------------------------
>  1 files changed, 5 insertions(+), 33 deletions(-)

Your patch won't apply on linux-next because of rather large code changes.
Anyway see below a patch that applies cleanly (and works) on s390.
Thanks for cleaning this up!

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

---
 arch/s390/kernel/smp.c |   36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -83,7 +83,6 @@ enum {
 
 struct pcpu {
 	struct cpu cpu;
-	struct task_struct *idle;	/* idle process for the cpu */
 	struct _lowcore *lowcore;	/* lowcore page(s) for the cpu */
 	unsigned long async_stack;	/* async stack for the cpu */
 	unsigned long panic_stack;	/* panic stack for the cpu */
@@ -724,26 +723,10 @@ static void __cpuinit smp_start_secondar
 	cpu_idle();
 }
 
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit smp_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle;
-
-	c_idle = container_of(work, struct create_idle, work);
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 /* Upping and downing of CPUs */
 int __cpuinit __cpu_up(unsigned int cpu)
 {
-	struct create_idle c_idle;
+	struct task_struct *idle;
 	struct pcpu *pcpu;
 	int rc;
 
@@ -753,22 +736,14 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	if (pcpu_sigp_retry(pcpu, sigp_initial_cpu_reset, 0) !=
 	    sigp_order_code_accepted)
 		return -EIO;
-	if (!pcpu->idle) {
-		c_idle.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done);
-		INIT_WORK_ONSTACK(&c_idle.work, smp_fork_idle);
-		c_idle.cpu = cpu;
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-		if (IS_ERR(c_idle.idle))
-			return PTR_ERR(c_idle.idle);
-		pcpu->idle = c_idle.idle;
-	}
-	init_idle(pcpu->idle, cpu);
+	idle = fork_idle_from_wq(cpu);
+	if (IS_ERR(idle))
+		return PTR_ERR(idle);
 	rc = pcpu_alloc_lowcore(pcpu, cpu);
 	if (rc)
 		return rc;
 	pcpu_prepare_secondary(pcpu, cpu);
-	pcpu_attach_task(pcpu, pcpu->idle);
+	pcpu_attach_task(pcpu, idle);
 	pcpu_start_fn(pcpu, smp_start_secondary, NULL);
 	while (!cpu_online(cpu))
 		cpu_relax();
@@ -855,7 +830,6 @@ void __init smp_prepare_boot_cpu(void)
 	struct pcpu *pcpu = pcpu_devices;
 
 	boot_cpu_address = stap();
-	pcpu->idle = current;
 	pcpu->state = CPU_STATE_CONFIGURED;
 	pcpu->address = boot_cpu_address;
 	pcpu->lowcore = (struct _lowcore *)(unsigned long) store_prefix();

