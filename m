Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2BVC3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:29:45 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:33410 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346Ab2BVC3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:29:44 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 21:29:44 EST
Subject: [PATCH] x86, tsc: Skip refined tsc calibration on systems with
	reliable TSC.
From: Alok Kataria <akataria@vmware.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, dirk.brandewie@gmail.com,
        alan@linux.intel.com, stable@kernel.org, Dan Hecht <dhecht@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1329876964.10380.28.camel@ank32.eng.vmware.com>
References: <1329876964.10380.28.camel@ank32.eng.vmware.com>
Content-Type: text/plain
Date: Tue, 21 Feb 2012 18:19:55 -0800
Message-Id: <1329877195.10380.33.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Oops forgot to copy LKML, now it is, sorry for the duplicates]

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

So IMO, for systems which get the TSC frequency from the platform we
should skip the refined tsc algorithm.
        
We can use the TSC_RELIABLE cpu cap flag to detect this, right now it is
set only on VMware and for Moorestown Penwell both of which have there
own TSC calibration methods.
        
Thanks,
Alok

--

From: Alok N Kataria <akataria@vmware.com>

For systems which get the TSC frequency directly from the platform
and don't go through the native TSC calibration algorithm, we should
trust those values and not try to refine those.

This patch is applicable for kernel from v2.6.38 to current mainline.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org


Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c	2012-02-21 17:31:01.000000000 -0800
+++ linux-2.6/arch/x86/kernel/tsc.c	2012-02-21 17:39:05.000000000 -0800
@@ -874,6 +874,13 @@ static void tsc_refine_calibration_work(
 		goto out;
 
 	/*
+	 * Trust the results of the earlier calibration on systems
+	 * exporting a reliable TSC.
+	 */
+	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
+		goto out;
+
+	/*
 	 * Since the work is started early in boot, we may be
 	 * delayed the first time we expire. So set the workqueue
 	 * again once we know timers are working.


