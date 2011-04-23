Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1DWQ3L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:29:11 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35033 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1DWQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:07 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 04/18] x86, mce: Have MCE persistent event off by default for now
Date: Sat, 23 Apr 2011 18:28:06 +0200
Message-Id: <1303576100-425-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Since this is a pretty new functionality and since it affects all x86,
we want to have it off by default for now, in case something goes awry.
You can always enable it by supplying "ras" on your kernel command line.

Also, depending on whether it is enabled or not, we emit the tracepoint
from a different place in the code to pick up any decoded info.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 arch/x86/include/asm/mce.h          |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c    |   32 ++++++++++++++++++++++++++++++--
 drivers/edac/mce_amd.c              |    5 +++++
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cc85a92..f09438a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2165,6 +2165,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/blockdev/ramdisk.txt.
 
+	ras		[X86] Enable RAS daemon supporting functionality.
+
 	rcupdate.blimit=	[KNL,BOOT]
 			Set maximum number of finished RCU callbacks to process
 			in one batch.
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 81f5545..8872af9 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -131,6 +131,7 @@ extern struct atomic_notifier_head x86_mce_decoder_chain;
 
 extern int mce_disabled;
 extern int mce_p5_enabled;
+extern int ras;
 
 #ifdef CONFIG_X86_MCE
 int mcheck_init(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9589ebf..54b411f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -59,6 +59,8 @@ static DEFINE_MUTEX(mce_read_mutex);
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(mce_record);
+
 int mce_disabled __read_mostly;
 
 #define MISC_MCELOG_MINOR	227
@@ -86,6 +88,7 @@ static int			mce_dont_log_ce		__read_mostly;
 int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
+int				ras			__read_mostly;
 
 struct mce_bank                *mce_banks		__read_mostly;
 
@@ -105,6 +108,7 @@ static int			cpu_missing;
  */
 ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
 EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
+EXPORT_SYMBOL_GPL(ras);
 
 static int default_decode_mce(struct notifier_block *nb, unsigned long val,
 			       void *data)
@@ -163,8 +167,9 @@ void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
 
-	/* Emit the trace record: */
-	trace_mce_record(mce);
+	if (!ras)
+		/* Emit the trace record: */
+		trace_mce_record(mce);
 
 	mce->finished = 0;
 	wmb();
@@ -1721,6 +1726,19 @@ static int __init mcheck_enable(char *str)
 }
 __setup("mce", mcheck_enable);
 
+static int __init ras_enable(char *str)
+{
+	/*
+	 * We enable the persistent event only if "ras" is supplied on the
+	 * command line. We still can add further options to parameter later.
+	 */
+	ras = 1;
+
+	return 0;
+}
+
+__setup("ras", ras_enable);
+
 int __init mcheck_init(void)
 {
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
@@ -2081,6 +2099,9 @@ static int mce_enable_perf_event_on_cpu(int cpu)
 	struct mce_tp_desc *d = &per_cpu(mce_event, cpu);
 	int err = -EINVAL;
 
+	if (!ras)
+		return 0;
+
 	d->event = perf_enable_persistent_event(&pattr, cpu, MCE_BUF_PAGES);
 	if (IS_ERR(d->event)) {
 		printk(KERN_ERR "MCE: Error enabling event on cpu %d\n", cpu);
@@ -2105,6 +2126,10 @@ ret:
 static void mce_disable_perf_event_on_cpu(int cpu)
 {
 	struct mce_tp_desc *d = &per_cpu(mce_event, cpu);
+
+	if (!ras)
+		return;
+
 	debugfs_remove(d->debugfs_entry);
 	perf_disable_persistent_event(d->event, cpu);
 }
@@ -2113,6 +2138,9 @@ static __init int mcheck_init_persistent_event(void)
 {
 	int cpu, err = 0;
 
+	if (!ras)
+		return -EBUSY;
+
 	get_online_cpus();
 
 	pattr.config = event_mce_record.event.type;
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 795cfbc..e329335 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1,5 +1,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <asm/mce.h>
+#include <trace/events/mce.h>
 
 #include "mce_amd.h"
 
@@ -829,6 +831,9 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 
 	amd_decode_err_code(m->status & 0xffff);
 
+	if (ras)
+		trace_mce_record(m);
+
 	return NOTIFY_STOP;
 }
 EXPORT_SYMBOL_GPL(amd_decode_mce);
-- 
1.7.4.rc2

