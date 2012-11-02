Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab2KBQoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:44:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47483 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2KBQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:44:13 -0400
Date: Fri, 2 Nov 2012 12:44:09 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xen/hypercall: fix hypercall fallback code for very
 old hypervisors
Message-ID: <20121102164409.GB27213@konrad-lan.dumpdata.com>
References: <1351519698-11069-1-git-send-email-konrad.wilk@oracle.com>
 <1351519698-11069-2-git-send-email-konrad.wilk@oracle.com>
 <20121030154450.GA3000@phenom.dumpdata.com>
 <5090F5AA02000078000A5A0B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090F5AA02000078000A5A0B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 08:55:54AM +0000, Jan Beulich wrote:
> >>> On 30.10.12 at 16:44, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Mon, Oct 29, 2012 at 10:08:17AM -0400, Konrad Rzeszutek Wilk wrote:
> >> From: Jan Beulich <jbeulich@suse.com>
> >> 
> >> While copying the argument structures in HYPERVISOR_event_channel_op()
> >> and HYPERVISOR_physdev_op() into the local variable is sufficiently
> >> safe even if the actual structure is smaller than the container one,
> >> copying back eventual output values the same way isn't: This may
> >> collide with on-stack variables (particularly "rc") which may change
> >> between the first and second memcpy() (i.e. the second memcpy() could
> >> discard that change).
> >> 
> >> Move the fallback code into out-of-line functions, and handle all of
> >> the operations known by this old a hypervisor individually: Some don't
> >> require copying back anything at all, and for the rest use the
> >> individual argument structures' sizes rather than the container's.
> >> 
> >> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >> [v2: Reduce #define/#undef usage in HYPERVISOR_physdev_op_compat().]
> >> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > And it looks like I get 
> > 
> > ERROR: "HYPERVISOR_event_channel_op_compat" [drivers/xen/xen-evtchn.ko] 
> > undefined!
> > 
> > when I build xen-evtchn as module. Jan did you encounter this issue on 
> > 2.6.18?
> 
> No - the event channel driver there can't be built as a module, and
> for the forward ported kernels I apparently never tried to build with
> a compat setting of 3.0.2 or less (and I didn't care that much either
> because the oldest we're actually concerned about is 3.0.4 to cover
> some of those very old EC2 systems; I'll add the export at the right
> point nevertheless).

Ok, ended up with this version which I was thinking to for v3.7-rc5:


>From 4ae4c7658a7c0501521c422d618038587c3edeca Mon Sep 17 00:00:00 2001
From: Jan Beulich <jbeulich@suse.com>
Date: Fri, 19 Oct 2012 15:25:37 -0400
Subject: [PATCH] xen/hypercall: fix hypercall fallback code for very old
 hypervisors

While copying the argument structures in HYPERVISOR_event_channel_op()
and HYPERVISOR_physdev_op() into the local variable is sufficiently
safe even if the actual structure is smaller than the container one,
copying back eventual output values the same way isn't: This may
collide with on-stack variables (particularly "rc") which may change
between the first and second memcpy() (i.e. the second memcpy() could
discard that change).

Move the fallback code into out-of-line functions, and handle all of
the operations known by this old a hypervisor individually: Some don't
require copying back anything at all, and for the rest use the
individual argument structures' sizes rather than the container's.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
[v2: Reduce #define/#undef usage in HYPERVISOR_physdev_op_compat().]
[v3: Fix compile errors when modules use said hypercalls]
[v4: Add xen_ prefix to the HYPERCALL_..]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/hypercall.h | 21 ++++------
 drivers/xen/Makefile                 |  2 +-
 drivers/xen/fallback.c               | 81 ++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 15 deletions(-)
 create mode 100644 drivers/xen/fallback.c

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 59c226d..4055421 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -359,18 +359,14 @@ HYPERVISOR_update_va_mapping(unsigned long va, pte_t new_val,
 		return _hypercall4(int, update_va_mapping, va,
 				   new_val.pte, new_val.pte >> 32, flags);
 }
+extern int __must_check xen_HYPERVISOR_event_channel_op_compat(int, void *);
 
 static inline int
 HYPERVISOR_event_channel_op(int cmd, void *arg)
 {
 	int rc = _hypercall2(int, event_channel_op, cmd, arg);
-	if (unlikely(rc == -ENOSYS)) {
-		struct evtchn_op op;
-		op.cmd = cmd;
-		memcpy(&op.u, arg, sizeof(op.u));
-		rc = _hypercall1(int, event_channel_op_compat, &op);
-		memcpy(arg, &op.u, sizeof(op.u));
-	}
+	if (unlikely(rc == -ENOSYS))
+		rc = xen_HYPERVISOR_event_channel_op_compat(cmd, arg);
 	return rc;
 }
 
@@ -386,17 +382,14 @@ HYPERVISOR_console_io(int cmd, int count, char *str)
 	return _hypercall3(int, console_io, cmd, count, str);
 }
 
+extern int __must_check xen_HYPERVISOR_physdev_op_compat(int, void *);
+
 static inline int
 HYPERVISOR_physdev_op(int cmd, void *arg)
 {
 	int rc = _hypercall2(int, physdev_op, cmd, arg);
-	if (unlikely(rc == -ENOSYS)) {
-		struct physdev_op op;
-		op.cmd = cmd;
-		memcpy(&op.u, arg, sizeof(op.u));
-		rc = _hypercall1(int, physdev_op_compat, &op);
-		memcpy(arg, &op.u, sizeof(op.u));
-	}
+	if (unlikely(rc == -ENOSYS))
+		rc = xen_HYPERVISOR_physdev_op_compat(cmd, arg);
 	return rc;
 }
 
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 0e863703..46de6cd 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -2,7 +2,7 @@ ifneq ($(CONFIG_ARM),y)
 obj-y	+= manage.o balloon.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
-obj-y	+= grant-table.o features.o events.o
+obj-y	+= grant-table.o features.o events.o fallback.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
diff --git a/drivers/xen/fallback.c b/drivers/xen/fallback.c
new file mode 100644
index 0000000..b29ce32
--- /dev/null
+++ b/drivers/xen/fallback.c
@@ -0,0 +1,81 @@
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/bug.h>
+#include <linux/export.h>
+#include <asm/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+int xen_HYPERVISOR_event_channel_op_compat(int cmd, void *arg)
+{
+	struct evtchn_op op;
+	int rc;
+
+	op.cmd = cmd;
+	memcpy(&op.u, arg, sizeof(op.u));
+	rc = _hypercall1(int, event_channel_op_compat, &op);
+
+	switch (cmd) {
+	case EVTCHNOP_close:
+	case EVTCHNOP_send:
+	case EVTCHNOP_bind_vcpu:
+	case EVTCHNOP_unmask:
+		/* no output */
+		break;
+
+#define COPY_BACK(eop) \
+	case EVTCHNOP_##eop: \
+		memcpy(arg, &op.u.eop, sizeof(op.u.eop)); \
+		break
+
+	COPY_BACK(bind_interdomain);
+	COPY_BACK(bind_virq);
+	COPY_BACK(bind_pirq);
+	COPY_BACK(status);
+	COPY_BACK(alloc_unbound);
+	COPY_BACK(bind_ipi);
+#undef COPY_BACK
+
+	default:
+		WARN_ON(rc != -ENOSYS);
+		break;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(xen_HYPERVISOR_event_channel_op_compat);
+
+int xen_HYPERVISOR_physdev_op_compat(int cmd, void *arg)
+{
+	struct physdev_op op;
+	int rc;
+
+	op.cmd = cmd;
+	memcpy(&op.u, arg, sizeof(op.u));
+	rc = _hypercall1(int, physdev_op_compat, &op);
+
+	switch (cmd) {
+	case PHYSDEVOP_IRQ_UNMASK_NOTIFY:
+	case PHYSDEVOP_set_iopl:
+	case PHYSDEVOP_set_iobitmap:
+	case PHYSDEVOP_apic_write:
+		/* no output */
+		break;
+
+#define COPY_BACK(pop, fld) \
+	case PHYSDEVOP_##pop: \
+		memcpy(arg, &op.u.fld, sizeof(op.u.fld)); \
+		break
+
+	COPY_BACK(irq_status_query, irq_status_query);
+	COPY_BACK(apic_read, apic_op);
+	COPY_BACK(ASSIGN_VECTOR, irq_op);
+#undef COPY_BACK
+
+	default:
+		WARN_ON(rc != -ENOSYS);
+		break;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(xen_HYPERVISOR_physdev_op_compat);
-- 
1.7.11.7

