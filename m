Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935942Ab2C3WFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:05:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55333 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965460Ab2C3VQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:16:21 -0400
Message-Id: <20120330194903.772879061@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alok N Kataria <akataria@vmware.com>,
        John Stultz <johnstul@us.ibm.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Alan Cox <alan@linux.intel.com>, John Stultz <john.stultz@linaro.org>
Subject: [ 144/149] x86, tsc: Skip refined tsc calibration on systems with reliable TSC
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Kataria <akataria@vmware.com>

commit 57779dc2b3b75bee05ef5d1ada47f615f7a13932 upstream.

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
[jstultz: Reworked to simply not schedule the refining work,
rather then scheduling the work and bombing out later]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/tsc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -934,6 +934,16 @@ static int __init init_tsc_clocksource(v
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
+
+	/*
+	 * Trust the results of the earlier calibration on systems
+	 * exporting a reliable TSC.
+	 */
+	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
+		clocksource_register_khz(&clocksource_tsc, tsc_khz);
+		return 0;
+	}
+
 	schedule_delayed_work(&tsc_irqwork, 0);
 	return 0;
 }


