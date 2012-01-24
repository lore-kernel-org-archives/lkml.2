Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab2AXCsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:48:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab2AXCsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:32 2012
Message-Id: <20120124023932.773307408@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shaohua.li@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [099/129] intel_idle: fix API misuse
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1839
Lines: 50

From: Shaohua Li <shaohua.li@intel.com>

commit 39a74fdedd1c1461d6fb6d330b5266886513c98f upstream.

smp_call_function() only lets all other CPUs execute a specific function,
while we expect all CPUs do in intel_idle.  Without the fix, we could have
one cpu which has auto_demotion enabled or has no broadcast timer setup.
Usually we don't see impact because auto demotion just harms power and the
intel_idle init is called in CPU 0, where boradcast timer delivers
interrupt, but this still could be a problem.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/idle/intel_idle.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -395,7 +395,7 @@ static int intel_idle_probe(void)
 	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
 		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
 	else {
-		smp_call_function(__setup_broadcast_timer, (void *)true, 1);
+		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
 		register_cpu_notifier(&setup_broadcast_notifier);
 	}
 
@@ -472,7 +472,7 @@ static int intel_idle_cpuidle_driver_ini
 	}
 
 	if (auto_demotion_disable_flags)
-		smp_call_function(auto_demotion_disable, NULL, 1);
+		on_each_cpu(auto_demotion_disable, NULL, 1);
 
 	return 0;
 }
@@ -569,7 +569,7 @@ static void __exit intel_idle_exit(void)
 	cpuidle_unregister_driver(&intel_idle_driver);
 
 	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE) {
-		smp_call_function(__setup_broadcast_timer, (void *)false, 1);
+		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
 		unregister_cpu_notifier(&setup_broadcast_notifier);
 	}
 


