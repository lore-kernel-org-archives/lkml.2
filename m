Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1JJMdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:33:14 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46258 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab1JJMdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:33:11 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
To: rjw@sisk.pl
Cc: srivatsa.bhat@linux.vnet.ibm.com, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, tj@kernel.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date: Mon, 10 Oct 2011 18:03:03 +0530
Message-ID: <20111010123242.15067.48238.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow cpu hotplug online operation and suspend/hibernate to run in
parallel. If suspend/hibernate has already started, fail the cpu online
operation.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..bc8c7d4 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,6 +15,7 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
+#include <linux/suspend.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -366,6 +367,14 @@ int __cpuinit cpu_up(unsigned int cpu)
 	}
 #endif
 
+	/*
+	 * Prevent cpu online and suspend/hibernate (including freezer)
+	 * operations from running in parallel. Fail cpu online if suspend or
+	 * hibernate has already started.
+	 */
+	if (!trylock_pm_sleep())
+		return -EBUSY;
+
 	cpu_maps_update_begin();
 
 	if (cpu_hotplug_disabled) {
@@ -377,6 +386,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 
 out:
 	cpu_maps_update_done();
+	unlock_pm_sleep();
 	return err;
 }
 

