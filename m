Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1ACTEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:04:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37663 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab1ACTEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:04:34 -0500
Date: Mon, 3 Jan 2011 20:04:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110103190413.GA17782@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ben Hutchings (1):
      watchdog: Improve initialisation error message and documentation

Frederic Weisbecker (1):
      perf: Fix callchain hit bad cast on ascii display

Robert Richter (1):
      arch/x86/oprofile/op_model_amd.c: Perform initialisation on a single CPU


 Documentation/kernel-parameters.txt |    2 +-
 arch/x86/oprofile/op_model_amd.c    |   24 ++++++++++++++++--------
 kernel/watchdog.c                   |    3 ++-
 tools/perf/util/hist.c              |    2 +-
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8b61c93..01ece1b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1759,7 +1759,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nousb		[USB] Disable the USB subsystem
 
-	nowatchdog	[KNL] Disable the lockup detector.
+	nowatchdog	[KNL] Disable the lockup detector (NMI watchdog).
 
 	nowb		[ARM]
 
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index a011bcc..7d90d47 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -630,21 +630,29 @@ static int __init_ibs_nmi(void)
 	return 0;
 }
 
-/* initialize the APIC for the IBS interrupts if available */
+/*
+ * check and reserve APIC extended interrupt LVT offset for IBS if
+ * available
+ *
+ * init_ibs() preforms implicitly cpu-local operations, so pin this
+ * thread to its current CPU
+ */
+
 static void init_ibs(void)
 {
-	ibs_caps = get_ibs_caps();
+	preempt_disable();
 
+	ibs_caps = get_ibs_caps();
 	if (!ibs_caps)
-		return;
+		goto out;
 
-	if (__init_ibs_nmi()) {
+	if (__init_ibs_nmi() < 0)
 		ibs_caps = 0;
-		return;
-	}
+	else
+		printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n", ibs_caps);
 
-	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n",
-	       (unsigned)ibs_caps);
+out:
+	preempt_enable();
 }
 
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6e3c41a..5b08215 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -364,7 +364,8 @@ static int watchdog_nmi_enable(int cpu)
 		goto out_save;
 	}
 
-	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
+	printk(KERN_ERR "NMI watchdog disabled for cpu%i: unable to create perf event: %ld\n",
+	       cpu, PTR_ERR(event));
 	return PTR_ERR(event);
 
 	/* success path */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2022e87..76bcc35 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -356,7 +356,7 @@ static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
 
 static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 				     int depth, int depth_mask, int period,
-				     u64 total_samples, int hits,
+				     u64 total_samples, u64 hits,
 				     int left_margin)
 {
 	int i;
