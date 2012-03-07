Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab2CGBcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:32:54 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58605 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab2CGBcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:32:53 -0500
Message-ID: <1331083933.2191.172.camel@work-vm>
Subject: Re: [PATCH] x86, tsc: Skip refined tsc calibration on systems with
 reliable TSC.
From: john stultz <johnstul@us.ibm.com>
To: Alok Kataria <akataria@vmware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, dirk.brandewie@gmail.com,
        alan@linux.intel.com, stable@kernel.org, Dan Hecht <dhecht@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Mar 2012 17:32:13 -0800
In-Reply-To: <1329877195.10380.33.camel@ank32.eng.vmware.com>
References: <1329876964.10380.28.camel@ank32.eng.vmware.com>
	 <1329877195.10380.33.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030701-5806-0000-0000-00001334A0E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 18:19 -0800, Alok Kataria wrote:
> [Oops forgot to copy LKML, now it is, sorry for the duplicates]
> 
> While running the latest Linux as guest under VMware in highly
> over-committed situations, we have seen cases when the refined TSC
> algorithm fails to get a valid tsc_start value in
> tsc_refine_calibration_work from multiple attempts. As a result the
> kernel keeps on scheduling the tsc_irqwork task for later. Subsequently
> after several attempts when it gets a valid start value it goes through
> the refined calibration and either bails out or uses the new results.
> Given that the kernel originally read the TSC frequency from the
> platform, which is the best it can get, I don't think there is much
> value in refining it. 
> 
> So IMO, for systems which get the TSC frequency from the platform we
> should skip the refined tsc algorithm.
>         
> We can use the TSC_RELIABLE cpu cap flag to detect this, right now it is
> set only on VMware and for Moorestown Penwell both of which have there
> own TSC calibration methods.

So this looks ok to me, only one nit below...

> 
> Index: linux-2.6/arch/x86/kernel/tsc.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/tsc.c	2012-02-21 17:31:01.000000000 -0800
> +++ linux-2.6/arch/x86/kernel/tsc.c	2012-02-21 17:39:05.000000000 -0800
> @@ -874,6 +874,13 @@ static void tsc_refine_calibration_work(
>  		goto out;
> 
>  	/*
> +	 * Trust the results of the earlier calibration on systems
> +	 * exporting a reliable TSC.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
> +		goto out;
> +
> +	/*

Instead of dropping out in the function called by the work-queue, why
not just avoid scheduling the work-queue to begin with?

The FEATURE_TSC_RELIABLE isn't something that is set late, and needs the
delay, right?

Here's what I queued up, let me know if it looks ok to you and I'll push
it on to Thomas.

thanks
-john

>From 50cd62f326fa3204763717c9808bdc29ba10512c Mon Sep 17 00:00:00 2001
From: Alok Kataria <akataria@vmware.com>
Date: Tue, 21 Feb 2012 18:19:55 -0800
Subject: [PATCH] x86, tsc: Skip refined tsc calibration on systems with reliable TSC.

While running the latest Linux as guest under VMware in highly
over-committed situations, we have seen cases when the refined TSC
algorithm fails to get a valid tsc_start value in
tsc_refine_calibration_work from multiple attempts. As a result the
kernel keeps on scheduling the tsc_irqwork task for later. Subsequently
after several attempts when it gets a valid start value it goes through
the refined calibration and either bails out or uses the new results.
Given that the kernel originally read the TSC frequency from the
platform, which is the best it can get, I don't think there is much
value in refining it.

So  for systems which get the TSC frequency from the platform we
should skip the refined tsc algorithm.

We can use the TSC_RELIABLE cpu cap flag to detect this, right now it is
set only on VMware and for Moorestown Penwell both of which have there
own TSC calibration methods.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
[jstultz: Reworked to simply not schedule the refining work,
rather then scheduling the work and bombing out later]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/x86/kernel/tsc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a62c201..b7d4d33 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -932,6 +932,14 @@ static int __init init_tsc_clocksource(void)
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
+
+	/*
+	 * Trust the results of the earlier calibration on systems
+	 * exporting a reliable TSC.
+	 */
+	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
+		return 0;
+
 	schedule_delayed_work(&tsc_irqwork, 0);
 	return 0;
 }
-- 
1.7.3.2.146.gca209



