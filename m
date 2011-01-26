Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1AZDF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 22:05:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:60239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1AZDF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 22:05:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,378,1291622400"; 
   d="scan'208";a="379964956"
Date: Wed, 26 Jan 2011 11:03:55 +0800
From: Feng Tang <feng.tang@intel.com>
To: <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/platform: add a wallclock_init func to
 x86_platforms ops
Message-ID: <20110126110355.36ea246b@feng-i7>
In-Reply-To: <20110125153813.4aa1e7cc@lxorguk.ukuu.org.uk>
References: <20110125153813.4aa1e7cc@lxorguk.ukuu.org.uk>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Date: Tue, 25 Jan 2011 16:20:17 +0100 (CET)
> From: Thomas Gleixner <tglx@linutronix.de>
> To: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: x86@kernel.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] x86/platform: add a wallclock_init func to
> x86_platforms ops
> 
> 
> On Tue, 25 Jan 2011, Alan Cox wrote:
> 
> > From: Feng Tang <feng.tang@intel.com>
> > 
> > Some wall clock devices use MMIO based HW register, this new
> > function will give them a chance to do some initialization work
> > before their get/set_time service get called.
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> > 
> >  arch/x86/include/asm/x86_init.h |    2 ++
> >  arch/x86/kernel/setup.c         |    2 ++
> >  arch/x86/kernel/x86_init.c      |    2 ++
> >  3 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > 
> > diff --git a/arch/x86/include/asm/x86_init.h
> > b/arch/x86/include/asm/x86_init.h index 64642ad..f7fa2e7 100644
> > --- a/arch/x86/include/asm/x86_init.h
> > +++ b/arch/x86/include/asm/x86_init.h
> > @@ -138,6 +138,7 @@ struct x86_cpuinit_ops {
> >  /**
> >   * struct x86_platform_ops - platform specific runtime functions
> >   * @calibrate_tsc:		calibrate TSC
> > + * @wallclock_init:		init the wallclock device
> 
> That's a one time called init function, so it should go into
> x86_init_ops.
> 
> Thanks,
> 
> 	tglx
> 

Hi Thomas,

Here is the updated one, if you think it's ok, I'll update the second patch later.

Thanks,
Feng
-------------

>From b305dc1ae5db882ac8ab49248096f96dd16bdd9a Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Wed, 26 Jan 2011 10:41:25 +0800
Subject: [PATCH] x86/platform: add a wallclock_init func to x86_init.timers ops

Some wall clock devices use MMIO based HW register, this new
function will give them a chance to do some initialization work
before their get/set_time service get called, which is usually
called in early kernel boot phase.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/setup.c         |    2 ++
 arch/x86/kernel/x86_init.c      |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 64642ad..643ebf2 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -83,11 +83,13 @@ struct x86_init_paging {
  *				boot cpu
  * @tsc_pre_init:		platform function called before TSC init
  * @timer_init:			initialize the platform timer (default PIT/HPET)
+ * @wallclock_init:		init the wallclock device
  */
 struct x86_init_timers {
 	void (*setup_percpu_clockev)(void);
 	void (*tsc_pre_init)(void);
 	void (*timer_init)(void);
+	void (*wallclock_init)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a25ce88..8b1cd72 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1066,6 +1066,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	x86_init.oem.banner();
 
+	x86_init.timers.wallclock_init();
+
 	mcheck_init();
 
 	local_irq_save(flags);
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ceb2911..c11514e 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -70,6 +70,7 @@ struct x86_init_ops x86_init __initdata = {
 		.setup_percpu_clockev	= setup_boot_APIC_clock,
 		.tsc_pre_init		= x86_init_noop,
 		.timer_init		= hpet_time_init,
+		.wallclock_init		= x86_init_noop,
 	},
 
 	.iommu = {
-- 
1.7.0.4



