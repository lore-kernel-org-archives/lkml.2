Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab1ERDqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 23:46:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10849 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab1ERDqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 23:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=RQpOGIHRycR1v2G/BBoXeVWrBF9JfyOtgMNc+QY2ZX0/lACjpXUFYnjjVru5aun/vF
         u1MAaRFs7VTe2I5t3H6A==
Date: Tue, 17 May 2011 20:44:31 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4 v2] watchdog: configure nmi watchdog period based on
 watchdog_thresh
Message-ID: <20110518034431.GC11023@google.com>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <1305588901-8141-4-git-send-email-msb@chromium.org>
 <20110517071642.GF22305@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517071642.GF22305@elte.hu>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mandeep Singh Baines <msb@chromium.org> wrote:
> 
> > Before the conversion of the NMI watchdog to perf event, the watchdog
> > timeout was 5 seconds. Now it is 60 seconds. For my particular application,
> > netbooks, 5 seconds was a better timeout. With a short timeout, we
> > catch faults earlier and are able to send back a panic. With a 60 second
> > timeout, the user is unlikely to wait and will instead hit the power
> > button, causing us to lose the panic info.
> 
> That's an interesting observation. Have you been able to measure/observe this 
> effect somehow, or do you presume that users find 60 seconds too long?
> 

Mostly intuition. There is a threshold beyond which the user will hit
the power button. Not sure if its 20 seconds or 20 minutes. My feeling
was that the 1 minute was too long.

For a user experience perspective, a quick reboot also seems like a better
experience than a one minute hang. Our systems boot in 8 seconds and restore
the previous session so a reboot is almost not noticable.

> This would be a concern for upstream as well i guess.
> 
> > This change configures the NMI period based on the watchdog_thresh.
> 
> Hm, our tolerance for the two thresholds is not just human but technical: hard 
> lockup warnings should indeed be triggered after just a few seconds, soft 
> lockups can have false positives under extreme conditions.
> 
> So we generally want a higher threshold for soft lockups than for hard lockups.
> 
> So how about we couple the thresholds with a factor: we make the soft threshold 
> twice the amount of time the hard threshold is? Then we could change the 
> upstream default as well i think: lets change the NMI timeout to 10 seconds 
> (and thus have the soft threshold at 20 seconds). Is 20 seconds short enough 
> for most users to not hit reset?
> 

Agree. Implemented in this version of the patch (v2).

---

Before the conversion of the NMI watchdog to perf event, the watchdog
timeout was 5 seconds. Now it is 60 seconds. For my particular application,
netbooks, 5 seconds was a better timeout. With a short timeout, we
catch faults earlier and are able to send back a panic. With a 60 second
timeout, the user is unlikely to wait and will instead hit the power
button, causing us to lose the panic info.

This change configures the NMI period to watchdog_thresh and sets
the softlockup_thresh to watchdog_thresh * 2. In addition, watchdog_thresh
was reduced to 10 seconds as suggested by Ingo Molnar.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
LKML-Reference: <20110517071642.GF22305@elte.hu>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/hw_nmi.c |    4 ++--
 include/linux/nmi.h           |    2 +-
 kernel/watchdog.c             |   19 +++++++++++++++----
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 5260fe9..d5e57db0 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -19,9 +19,9 @@
 #include <linux/delay.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
-u64 hw_nmi_get_sample_period(void)
+u64 hw_nmi_get_sample_period(int watchdog_thresh)
 {
-	return (u64)(cpu_khz) * 1000 * 60;
+	return (u64)(cpu_khz) * 1000 * watchdog_thresh;
 }
 #endif
 
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 10cbca7..a26fb4a 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -45,7 +45,7 @@ static inline bool trigger_all_cpu_backtrace(void)
 
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
-u64 hw_nmi_get_sample_period(void);
+u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_enabled;
 extern int watchdog_thresh;
 struct ctl_table;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index ea3dfc2..2788fa9 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -28,7 +28,7 @@
 #include <linux/perf_event.h>
 
 int watchdog_enabled = 1;
-int __read_mostly watchdog_thresh = 60;
+int __read_mostly watchdog_thresh = 10;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
@@ -91,6 +91,17 @@ static int __init nosoftlockup_setup(char *str)
 __setup("nosoftlockup", nosoftlockup_setup);
 /*  */
 
+/*
+ * Hard-lockup warnings should be triggered after just a few seconds. Soft-
+ * lockups can have false positives under extreme conditions. So we generally
+ * want a higher threshold for soft lockups than for hard lockups. So we couple
+ * the thresholds with a factor: we make the soft threshold twice the amount of
+ * time the hard threshold is.
+ */
+static int get_softlockup_thresh()
+{
+	return watchdog_thresh * 2;
+}
 
 /*
  * Returns seconds, approximately.  We don't need nanosecond
@@ -110,7 +121,7 @@ static unsigned long get_sample_period(void)
 	 * increment before the hardlockup detector generates
 	 * a warning
 	 */
-	return watchdog_thresh * (NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
@@ -182,7 +193,7 @@ static int is_softlockup(unsigned long touch_ts)
 	unsigned long now = get_timestamp(smp_processor_id());
 
 	/* Warn about unreasonable delays: */
-	if (time_after(now, touch_ts + watchdog_thresh))
+	if (time_after(now, touch_ts + get_softlockup_thresh()))
 		return now - touch_ts;
 
 	return 0;
@@ -359,7 +370,7 @@ static int watchdog_nmi_enable(int cpu)
 
 	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
-	wd_attr->sample_period = hw_nmi_get_sample_period();
+	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
-- 
1.7.3.1

