Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2E0JRr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 05:17:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41820 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752253Ab2E0JRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 05:17:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18jRMFJwhcjwNuTvW1YWYlyfgZe+9DFqV6Wsjt76J
	lVkXXvSihSJCKj
Message-ID: <1338110259.7678.77.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Sun, 27 May 2012 11:17:39 +0200
In-Reply-To: <1338020834.7747.8.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>
	 <1337926468.5415.48.camel@marge.simpson.net>
	 <1338014259.7302.26.camel@marge.simpson.net>
	 <1338017364.14636.9.camel@twins>
	 <1338020834.7747.8.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 10:27 +0200, Mike Galbraith wrote: 
> Hohum, back to finding out what happened to cpufreq.

Answer: nothing.. in mainline.

I test performance habitually, so just never noticed how bad ondemand
sucks.  In enterprise, I found the below, explaining why cores crank up
fine there, but not in mainline.  Somebody thumped ondemand properly on
it's pointy head.

But, check out the numbers below this, and you can see just how horrible
bouncing is when you add governor latency _on top_ of it. 

---
drivers/cpufreq/cpufreq_ondemand.c |   25 +++++++++++++++++++++++++
1 file changed, 25 insertions(+)

--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -37,6 +37,7 @@
#define MICRO_FREQUENCY_MIN_SAMPLE_RATE (10000)
#define MIN_FREQUENCY_UP_THRESHOLD (11)
#define MAX_FREQUENCY_UP_THRESHOLD (100)
+#define MAX_DEFAULT_SAMPLING_RATE (300 * 1000U)

/*
  * The polling frequency of this governor depends on the capability of
@@ -733,6 +734,30 @@ static int cpufreq_governor_dbs(struct c
max(min_sampling_rate,
    latency * LATENCY_MULTIPLIER);
dbs_tuners_ins.io_is_busy = should_io_be_busy();
+ /*
+ * Cut def_sampling rate to 300ms if it was above,
+ * still consider to not set it above latency
+ * transition * 100
+ */
+ if (dbs_tuners_ins.sampling_rate > MAX_DEFAULT_SAMPLING_RATE) {
+ dbs_tuners_ins.sampling_rate =
+ max(min_sampling_rate, MAX_DEFAULT_SAMPLING_RATE);
+ printk(KERN_INFO "CPUFREQ: ondemand sampling "
+        "rate set to %d ms\n",
+        dbs_tuners_ins.sampling_rate / 1000);
+ }
+ /*
+ * Be conservative in respect to performance.
+ * If an application calculates using two threads
+ * depending on each other, they will be run on several
+ * CPU cores resulting on 50% load on both.
+ * SLED might still want to prefer 80% up_threshold
+ * by default, but we cannot differ that here.
+ */
+ if (num_online_cpus() > 1)
+ dbs_tuners_ins.up_threshold =
+ DEF_FREQUENCY_UP_THRESHOLD / 2;
+
}
mutex_unlock(&dbs_mutex);


patches applied to both trees
patches/remove_irritating_plus.diff
patches/clockevents-Reinstate-the-per-cpu-tick-skew.patch
patches/sched-cgroups-Disallow-attaching-kthreadd
patches/sched-fix-task_groups-list
patches/sched-rt-fix-isolated-CPUs-leaving-root_task_group-indefinitely-throttled.patch
patches/sched-throttle-nohz.patch
patches/sched-domain-flags-proc-handler.patch
patches/sched-fix-Q6600.patch
patches/cpufreq_ondemand_performance_optimise_default_settings.patch

applied only to 3.4.0x
patches/sched-tweak-select_idle_sibling.patch 

tbench 1
3.4.0          351 MB/sec ondemand
               350 MB/sec
               351 MB/sec

3.4.0x         428 MB/sec ondemand
               432 MB/sec
               425 MB/sec
vs 3.4.0       1.22

3.4.0          363 MB/sec performance
               369 MB/sec
               359 MB/sec
               
3.4.0x         432 MB/sec performance
               430 MB/sec
               427 MB/sec
vs 3.4.0       1.18

netperf TCP_RR  1 byte ping/pong (trans/sec)

governor ondemand
                 unbound          bound
3.4.0              72851         128433
                   72347         127301
                   72512         127472
         
3.4.0x            128440         131979
                  128116         132413
                  128366         132004
vs 3.4.0           1.768          1.034
                   ^^^^^ eek!     (hm, why bound improvement?)

governor performance
3.4.0             105199         127140
                  104534         128786
                  104167         127920

3.4.0x            123451         132883
                  128702         132688
                  125653         133005
vs 3.4.0           1.203          1.038
                                  (hm, why bound improvement?)

select_idle_sibling() becomes a proper throughput/latency trade on
Westmere as well, with only modest cost even for worst case load that
does at least a dinky bit of work (TCP_RR == 100% synchronous).

-Mike

