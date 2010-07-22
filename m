Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab0GVLOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:14:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:25726 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097Ab0GVLON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:14:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="640711818"
Subject: [RFC][PATCH v1 08/15] perf: export tracepoint events via sysfs:
 kvm and kvm_mmu
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 19:14:28 +0800
Message-ID: <1279797268.20942.89.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm and kvm_mmu tracepoint events are exported like below,

/sys/devices/system/kvm/kvm0/events/
|-- kvm_ack_irq
|   |-- config
|   `-- type
....
....
|-- kvm_mmu_get_page
|   |-- config
|   `-- type
....
....
---
 virt/kvm/kvm_main.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f032806..0acb4f6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -46,6 +46,7 @@
 #include <linux/srcu.h>
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
+#include <linux/perf_event.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -2178,6 +2179,18 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_vcpu_put(vcpu);
 }
 
+static void kvm_sys_add_tp(struct kobject *kvm_kobj)
+{
+	struct kobject *events_kobj;
+
+	events_kobj = perf_sys_create_events_dir(kvm_kobj);
+	if (!events_kobj)
+		return;
+
+	perf_sys_add_tp_events(events_kobj, "kvm");
+	perf_sys_add_tp_events(events_kobj, "kvm_mmu");
+}
+
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
@@ -2227,6 +2240,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		goto out_free_4;
 
+	kvm_sys_add_tp(&kvm_sysdev.kobj);
+
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
 		vcpu_align = __alignof__(struct kvm_vcpu);



