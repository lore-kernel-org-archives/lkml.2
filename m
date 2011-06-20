Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1FTKPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:15:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37188 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab1FTKO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:14:58 -0400
Date: Mon, 20 Jun 2011 11:14:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110620101438.GD2082@n2100.arm.linux.org.uk>
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620095053.GA2082@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 10:50:53AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 02:53:59PM +0530, Santosh Shilimkar wrote:
> > The current ARM CPU hotplug code suffers from couple of race conditions
> > in CPU online path with scheduler.
> > The ARM CPU hotplug code doesn't wait for hot-plugged CPU to be marked
> > active as part of cpu_notify() by the CPU which brought it up before
> > enabling interrupts.
> 
> Hmm, why not just move the set_cpu_online() call before notify_cpu_starting()
> and add the wait after the set_cpu_online() ?

Actually, the race is caused by the CPU being marked online (and therefore
available for the scheduler) but not yet active (the CPU asking this one
to boot hasn't run the online notifiers yet.)

This, I feel, is a fault of generic code.  If the CPU is not ready to have
processes scheduled on it (because migration is not initialized) then we
shouldn't be scheduling processes on the new CPU yet.

In any case, this should close the window by ensuring that we don't receive
an interrupt in the online-but-not-active case.  Can you please test?

 arch/arm/kernel/smp.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 344e52b..e34d750 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -318,9 +318,15 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	smp_store_cpu_info(cpu);
 
 	/*
-	 * OK, now it's safe to let the boot CPU continue
+	 * OK, now it's safe to let the boot CPU continue.  Wait for
+	 * the CPU migration code to notice that the CPU is online
+	 * before we continue.
 	 */
+	local_irq_disable();
 	set_cpu_online(cpu, true);
+	while (!cpumask_test_cpu(cpu, cpu_active_mask))
+		cpu_relax();
+	local_irq_enable();
 
 	/*
 	 * OK, it's off to the idle thread for us

