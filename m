Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0ICVF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:05:57 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49311 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753430Ab0ICVFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:05:55 -0400
Date: Fri, 3 Sep 2010 14:05:54 -0700
From: Arthur Kepner <akepner@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Subject: [RFC/PATCH] notify user-level IRQ balancer when kernel assigns IRQ
	affinity
Message-ID: <20100903210554.GO2464@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We've run into situations where a CPU runs out of interrupt 
vectors, because all the interrupts are getting the default 
affinity (and the interrupt balancer hasn't yet run).

The following emits a netlink message whenever an interrupt 
is given a default CPU affinity. A user-level IRQ balancer 
can use those messages to decide if, and how to reassign 
affinities. This should allow us to avoid running out of 
vectors on any particular CPU (or at least make it far less 
likely).

I know this needs work, but would like to get comments on 
the idea before doing more coding and testing.


Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

diff --git a/arch/Kconfig b/arch/Kconfig
index 4877a8c..65c79c7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -158,4 +158,15 @@ config HAVE_PERF_EVENTS_NMI
 	  subsystem.  Also has support for calculating CPU cycle events
 	  to determine how many clock cycles in a given period.
 
+config NOTIFY_USER_IRQ_BALANCER
+	bool "Notify user-level IRQ balancer (EXPERIMENTAL)"
+	default n
+	depends on NET && X86
+	help
+	  When the kernel sets a default CPU affinity for an interrupt, 
+          emit a notification message over a netlink socket so that a 
+          user-level IRQ balancer may re-balance IRQs the way it prefers.
+
+	  If unsure, say N.
+
 source "kernel/gcov/Kconfig"
diff --git a/include/linux/irq_notify.h b/include/linux/irq_notify.h
new file mode 100644
index 0000000..b1bbdee
--- /dev/null
+++ b/include/linux/irq_notify.h
@@ -0,0 +1,33 @@
+#ifndef __IRQ_NOTIFY_H
+#define __IRQ_NOTIFY_H
+
+enum {
+	IRQ_NOTIFY_TYPE_UNSPEC,
+	IRQ_NOTIFY_TYPE_NOTICE,
+	__IRQ_NOTIFY_TYPE_MAX,
+};
+
+#define IRQ_NOTIFY_TYPE_MAX (__IRQ_NOTIFY_TYPE_MAX - 1)
+
+enum {
+	IRQ_NOTIFY_CMD_ATTR_UNSPEC,
+	IRQ_NOTIFY_CMD_ATTR_IRQ,
+	__IRQ_NOTIFY_CMD_ATTR_MAX,
+};
+
+#define IRQ_NOTIFY_CMD_ATTR_MAX (__IRQ_NOTIFY_CMD_ATTR_MAX - 1)
+
+#define IRQ_NOTIFY_GNL_NAME "IRQ_NOTIFY"
+#define IRQ_NOTIFY_GNL_VERSION 1
+
+#define IRQ_NOTIFY_GRP_ID 1
+
+#ifdef CONFIG_NOTIFY_USER_IRQ_BALANCER
+extern int irq_notify(int);
+#else
+static inline int irq_notify(int)
+{
+}
+#endif /* CONFIG_NOTIFY_USER_IRQ_BALANCER */
+
+#endif /* __IRQ_NOTIFY_H */
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 7d04780..b74c75e 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_NUMA_IRQ_DESC) += numa_migrate.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
+obj-$(CONFIG_NOTIFY_USER_IRQ_BALANCER) += irq_notify.o
diff --git a/kernel/irq/irq_notify.c b/kernel/irq/irq_notify.c
new file mode 100644
index 0000000..35c7627
--- /dev/null
+++ b/kernel/irq/irq_notify.c
@@ -0,0 +1,103 @@
+/* 
+ * irq_notify.c - send notification via netlink when the kernel sets
+ *                the default affinity of an IRQ
+ * 
+ * Copyright (C) Arthur Kepner, SGI 2010
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
+#include <linux/irq_notify.h>
+
+MODULE_AUTHOR("Arthur Kepner <akepner@sgi.com>");
+MODULE_DESCRIPTION("notify userland when default irq affinity is assigned");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.1");
+
+static int irq_notify_family_registered;
+
+static struct genl_family irq_notify_family = {
+	.id		= GENL_ID_GENERATE,
+	.name		= IRQ_NOTIFY_GNL_NAME,
+	.version	= IRQ_NOTIFY_GNL_VERSION,
+	.maxattr	= IRQ_NOTIFY_CMD_ATTR_MAX,
+};
+
+static const struct nla_policy irq_notify_policy[IRQ_NOTIFY_CMD_ATTR_MAX+1] = {
+        [IRQ_NOTIFY_CMD_ATTR_IRQ]  = { .type = NLA_U32 },
+};
+
+int irq_notify(int irq)
+{
+	struct sk_buff *skb;
+	void *hdr;
+	int ret;
+
+	if (!irq_notify_family_registered)
+		return -EINVAL;
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+
+	if (skb == NULL)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(skb, 0, 0, &irq_notify_family, 0, 
+			  IRQ_NOTIFY_TYPE_NOTICE);
+
+	if (hdr == NULL) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	ret = nla_put(skb, IRQ_NOTIFY_CMD_ATTR_IRQ, sizeof(u32), &irq);
+	if (ret < 0)
+		goto fail;
+
+	genlmsg_end(skb, hdr);
+
+	return genlmsg_multicast(skb, 0, IRQ_NOTIFY_GRP_ID, GFP_KERNEL);
+
+fail:
+	nlmsg_free(skb);
+	return ret;
+}
+EXPORT_SYMBOL(irq_notify);
+
+static __init int irq_notify_init(void)
+{
+	int ret = 0;
+
+	ret = genl_register_family(&irq_notify_family);
+	if (ret)
+		goto out;
+
+	printk(KERN_CRIT "%s: family registered\n", IRQ_NOTIFY_GNL_NAME);
+
+	irq_notify_family_registered = 1;
+out:
+	return ret;
+}
+module_init(irq_notify_init);
+
+
+static __exit void irq_notify_exit(void)
+{
+	genl_unregister_family(&irq_notify_family);
+	printk(KERN_CRIT "%s: family unregistered\n", IRQ_NOTIFY_GNL_NAME);
+}
+module_exit(irq_notify_exit);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c3003e9..2fa65e2 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/irq_notify.h>
 
 #include "internals.h"
 
@@ -178,6 +179,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
 	desc->chip->set_affinity(irq, desc->affinity);
+	irq_notify(irq);
 
 	return 0;
 }
