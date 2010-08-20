Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab0HTC6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 22:58:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab0HTC6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 22:58:43 -0400
Date: Thu, 19 Aug 2010 22:57:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Len Brown <len.brown@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Andy Grover <andy.grover@oracle.com>
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100820025749.GB4879@redhat.com>
References: <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
 <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
 <20100817092407.GB12022@swordfish.minsk.epam.com>
 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
 <20100817103948.GA5352@swordfish.minsk.epam.com>
 <20100817131320.GX4879@redhat.com>
 <20100818024802.GA24748@nowhere>
 <20100818130156.43a183d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818130156.43a183d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 01:01:56PM -0700, Andrew Morton wrote:
> The surprise new requirement that touch_nmi_watchdog() be called from
> non-preemptible code does seem to make sense IMO.  It's hard to see why
> anyone would be touching the watchdog unless he's spinning in irqs-off
> code.  Except, of course, when we have a utility function which can be
> called from wither irqs-on or irqs-off: acpi_os_stall().
> 
> That being said, it's not good to introduce new API requirements by
> accident!  An audit of all callers should first be performed, at least.
> 
> 
> The surprise new requirement that touch_softlockup_watchdog() be called
> from non-preemptible code doesn't make sense IMO.  If I have a piece of
> code in the kernel which I expect to sit in TASK_UNINTERRUPTIBLE state
> for three minutes waiting for my egg to boil, I should be able to do
> that and I should be able to touch the softlockup detector without
> needing to go non-preemptible.

Ok, so here is my patch that syncs the touch_*_watchdog back in line with
the old semantics.  Hopefully this will undo any harm I caused.

------------cut -->---------------------------

>From b372e821c804982438db090db6b4a2f753c78091 Mon Sep 17 00:00:00 2001
From: Don Zickus <dzickus@redhat.com>
Date: Thu, 19 Aug 2010 22:48:26 -0400
Subject: [PATCH] [lockup detector] sync touch_*_watchdog back to old semantics

During my rewrite, the semantics of touch_nmi_watchdog and
touch_softlockup_watchdog changed enough to break some drivers
(mostly over preemptable regions).

This change brings those touch_*_watchdog functions back in line
to how they used to work.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..99e35a2 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -122,7 +122,7 @@ static void __touch_watchdog(void)
 
 void touch_softlockup_watchdog(void)
 {
-	__get_cpu_var(watchdog_touch_ts) = 0;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -142,7 +142,14 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	__get_cpu_var(watchdog_nmi_touch) = true;
+	if (watchdog_enabled) {
+		unsigned cpu;
+
+		for_each_present_cpu(cpu) {
+			if (per_cpu(watchdog_nmi_touch, cpu) != true)
+				per_cpu(watchdog_nmi_touch, cpu) = true;
+		}
+	}
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
@@ -430,6 +437,9 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
+	/* if any cpu succeeds, watchdog is considered enabled for the system */
+	watchdog_enabled = 1;
+
 	return 0;
 }
 
@@ -452,9 +462,6 @@ static void watchdog_disable(int cpu)
 		per_cpu(softlockup_watchdog, cpu) = NULL;
 		kthread_stop(p);
 	}
-
-	/* if any cpu succeeds, watchdog is considered enabled for the system */
-	watchdog_enabled = 1;
 }
 
 static void watchdog_enable_all_cpus(void)
-- 
1.7.2.1


