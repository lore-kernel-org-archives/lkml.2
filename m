Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0F2GSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 02:18:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:48590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0F2GSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:18:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,502,1272870000"; 
   d="scan'208";a="531240235"
Subject: Re: [rfc] Describe events in a structured way via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
In-Reply-To: <20100624173315.GA30403@elte.hu>
References: <20100521094053.GA4658@elte.hu>
	 <AANLkTimf1Z0N9cv2Pu2qTTUscn4utC37zOPelCbqQoPv@mail.gmail.com>
	 <1277110509.18390.28.camel@minggr.sh.intel.com>
	 <1277112858.3618.16.camel@jlt3.sipsolutions.net>
	 <1277187920.4467.3.camel@minggr.sh.intel.com>
	 <1277189971.3637.5.camel@jlt3.sipsolutions.net>
	 <1277191359.5025.4.camel@minggr.sh.intel.com>
	 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
	 <20100624093625.GA26931@elte.hu>
	 <1277396053.3870.16.camel@jlt3.sipsolutions.net>
	 <20100624173315.GA30403@elte.hu>
Content-Type: text/plain
Date: Tue, 29 Jun 2010 14:15:14 +0800
Message-Id: <1277792114.5400.5.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 01:33 +0800, Ingo Molnar wrote:
> * Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > On Thu, 2010-06-24 at 11:36 +0200, Ingo Molnar wrote:
> > 
> > > That's probably best achieved via a TRACE_EVENT() variant, by passing in the 
> > > sysfs location.
> > > 
> > > It might even make sense to make this a part of TRACE_EVENT() itself and make 
> > > 'NULL' the current default, non-sysfs-enumerated behavior. That way we can 
> > > gradually (and non-intrusively) find all the right sysfs places for events.
> > 
> > No, this doesn't work. A lot of events are multi-instance. Say you have an 
> > event for each USB device. This event would have to show up in many places 
> > in sysfs, and each trace_foo() invocation needs to get the struct device 
> > pointer, not just the TRACE_EVENT() definition. Additionally, to 
> > create/destroy the sysfs pieces we need something like init_trace_foo(dev) 
> > and destroy_trace_foo(dev) be called when the sysfs points for the device 
> > should be created/destroyed.
> 
> Yes - but even this could be expressed via TRACE_EVENT(): by giving it a 
> device-specific function pointer and then instantiating individual events from 
> a single, central place in sysfs.
> 
> That is the place where we already know where it ends up in sysfs, and where 
> the event-specific function can match up whether that particular node belongs 
> to it and whether an additional event directory should be created for that 
> particular sysfs node.
> 
> > The TRACE_EVENT() just defines the template, but such multi-instance events 
> > really should be standardised in terms of their struct device (or maybe 
> > kobject).
> > 
> > I think that needs some TRACE_DEVICE_EVENT macro that creates the required 
> > inlines etc, and including the init/destroy that are called when the event 
> > should show up in sysfs.
> > 
> > There's no way you can have the event show up in sysfs at the right spot 
> > with _just_ a TRACE_EVENT macro, since at define time in the header file you 
> > don't even have a valid struct device pointer.
> 
> That would be another possible way to do it - to explicitly create the events 
> directory. It looks a bit simpler as we wouldnt have to touch TRACE_EVENT() 
> and because it directly expresses the 'this node has an events directory' 
> property at the place where we create the device node.

Let me take i915 tracepoints as an example.
Do you mean something like below?

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 423dc90..9e7e4a0 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/perf_event.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
@@ -413,7 +414,17 @@ int i965_reset(struct drm_device *dev, u8 flags)
 static int __devinit
 i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	return drm_get_dev(pdev, ent, &driver);
+	struct kobject *kobj;
+	int ret;
+
+	ret = drm_get_dev(pdev, ent, &driver);
+
+	if (!ret) {
+		kobj = &pdev->dev.kobj;
+		perf_sys_register_tp(kobj, "i915");
+	}
+
+	return ret;
 }
 
 static void
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 716f99b..2a6d834 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1019,6 +1019,8 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+
+extern void perf_sys_register_tp(struct kobject *kobj, char *tp_system);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 403d180..1b85dad 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5877,3 +5877,32 @@ static int __init perf_event_sysfs_init(void)
 				  &perfclass_attr_group);
 }
 device_initcall(perf_event_sysfs_init);
+
+#define for_each_event(event, start, end)			\
+	for (event = start;					\
+	     (unsigned long)event < (unsigned long)end;		\
+	     event++)
+
+extern struct ftrace_event_call __start_ftrace_events[];
+extern struct ftrace_event_call __stop_ftrace_events[];
+
+void perf_sys_register_tp(struct kobject *kobj, char *tp_system)
+{
+	struct ftrace_event_call *call;
+	struct kobject *events_kobj;
+
+	events_kobj = kobject_create_and_add("events", kobj);
+	if (!events_kobj)
+		return;
+
+	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
+		if (call->class->system && !strcmp(call->class->system, tp_system)) {
+
+			/* create events/<tracepoint>  */
+			kobject_create_and_add(call->name, events_kobj);
+
+			/* create events/<tracepoint>/enable, filter, format, id */
+			/* TBD ... */
+		}
+	}
+}


