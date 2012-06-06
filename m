Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2FFVPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:15:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab2FFVPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:15:41 -0400
Date: Wed, 6 Jun 2012 17:15:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] watchdog: reduce "NMI watchdog enabled, takes one hw-pmu
 counter." messages
Message-ID: <20120606211523.GF32472@redhat.com>
References: <20120606180946.GA16566@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606180946.GA16566@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 01:09:46PM -0500, Nathan Zimmer wrote:
>  watchdog: reduces some noise on a large system
>  The printk buffer can be flooded with with redundant
>  "NMI watchdog enabled, takes one hw-pmu counter." messages.
>  It doesn't add any value beyond the first.
> 
>  Note the message needs logged a second time if the watchdog was disabled then
>  reenabled.

Hi Nathan,

Thanks for the patch.  I added something similar to RHEL-6 a while ago
that solved the same problem in a more robust way (I think).  IOW, I dealt
with the watchdog failures too (for virt and bios issues).

It doesn't cover the nmi_disable case like your patch does, but is easy to
add.

I attached it below.  Let me know if this meets your needs or not?

Cheers,
Don

-----------------------------8<-----------------------
From: Don Zickus <dzickus@redhat.com>
Date: Wed, 6 Jun 2012 15:17:19 -0400
Subject: [PATCH] watchdog: quiet down the boot messages

A bunch of bugzillas have complained how noisy the nmi_watchdog is during
boot-up especially with its expected failure cases (like virt and bios
resource contention).

This is my attempt to quiet them down and keep it less confusing for the end
user.  What I did is print the message for cpu0 and save it for future
comparisions.  If future cpus have an identical message as cpu0, then don't
print the redundant info.  However, if a future cpu has a different message,
happily print that loudly.

Before the change, you would see something like:

    ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
    CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
    Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
    ... version:                2
    ... bit width:              40
    ... generic registers:      2
    ... value mask:             000000ffffffffff
    ... max period:             000000007fffffff
    ... fixed-purpose events:   3
    ... event mask:             0000000700000003
    NMI watchdog enabled, takes one hw-pmu counter.
    Booting Node   0, Processors  #1
    NMI watchdog enabled, takes one hw-pmu counter.
     #2
    NMI watchdog enabled, takes one hw-pmu counter.
     #3 Ok.
    NMI watchdog enabled, takes one hw-pmu counter.
    Brought up 4 CPUs
    Total of 4 processors activated (22607.24 BogoMIPS).

After the change, it is simlified to:

    ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
    CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
    Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
    ... version:                2
    ... bit width:              40
    ... generic registers:      2
    ... value mask:             000000ffffffffff
    ... max period:             000000007fffffff
    ... fixed-purpose events:   3
    ... event mask:             0000000700000003
    NMI watchdog enabled, takes one hw-pmu counter.
    Booting Node   0, Processors  #1 #2 #3 Ok.
    Brought up 4 CPUs

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e5e1d85..79ff671 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -377,6 +377,14 @@ static int watchdog_nmi_enable(int cpu)
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
+	/*
+	 * People like the simple clean cpu node info
+	 * on boot.  Simplify the noise from the watchdog
+	 * by only printing messages that are different than
+	 * what cpu0 displayed
+	 */
+	static unsigned long err0 = 0;
+
 	/* is it already setup and enabled? */
 	if (event && event->state > PERF_EVENT_STATE_OFF)
 		goto out;
@@ -390,11 +398,21 @@ static int watchdog_nmi_enable(int cpu)
 
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
+
+	/* save cpu0 error for future comparision */
+	if (!cpu)
+		err0 = (IS_ERR(event) ? PTR_ERR(event) : 0);
+
 	if (!IS_ERR(event)) {
-		pr_info("enabled, takes one hw-pmu counter.\n");
+		/* only print for cpu0 or different than cpu0 */
+		if (!cpu || err0)
+			pr_info("enabled, takes one hw-pmu counter.\n");
 		goto out_save;
 	}
 
+	/* skip displaying the same error again */
+	if ((PTR_ERR(event) == err0) && cpu)
+		return PTR_ERR(event);
 
 	/* vary the KERN level based on the returned errno */
 	if (PTR_ERR(event) == -EOPNOTSUPP)
-- 
1.7.7.6

