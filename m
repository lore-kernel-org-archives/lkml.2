Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0HQH4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:56:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54100 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab0HQH4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=thMqsotLPGddp5l0ws9Wv1kPuwEuOofrBFSG5lI50EEEvzmjeIJwkqP3pcKDLNEeTv
         KeFOHNRsK2gB503i5nW6tuMH/icdjqqViHTRMLrgKnS2DcH1RkSGFBuYi6zzesYRhOk+
         03zeZWCuyI5RV34L6aiJxaZxZroEo0lTTVyLI=
Date: Tue, 17 Aug 2010 10:56:12 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog and
 touch_softlockup_watchdog (v2)
Message-ID: <20100817075612.GA5346@swordfish.minsk.epam.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <1281946970.1926.998.camel@laptop>
 <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
 <20100816140829.GA5225@swordfish.minsk.epam.com>
 <20100817025954.GA12366@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817025954.GA12366@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix: acpi_os_stall calls touch_nmi_watchdog and touch_softlockup_watchdog
with preemption enabled causing 'BUG: using smp_processor_id() in preemptible 
code'.

Patch also removes double smp_processor_id call (smp_processor_id itself and
in __get_cpu_var) in __touch_watchdog.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..cb4f4d4 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -116,13 +116,14 @@ static unsigned long get_sample_period(void)
 static void __touch_watchdog(void)
 {
 	int this_cpu = smp_processor_id();
-
-	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
+	per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);
 }
 
 void touch_softlockup_watchdog(void)
 {
+	preempt_disable();
 	__get_cpu_var(watchdog_touch_ts) = 0;
+	preempt_enable();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -142,7 +143,10 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
+	preempt_disable();
 	__get_cpu_var(watchdog_nmi_touch) = true;
+	preempt_enable();
+
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);

