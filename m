Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab1JYJvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:51:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53338 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1JYJtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:49:03 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 4/7] amp/omap: add a remoteproc driver
Date: Tue, 25 Oct 2011 11:48:23 +0200
Message-Id: <1319536106-25802-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319536106-25802-1-git-send-email-ohad@wizery.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a remoteproc driver for OMAP4, so we can boot the dual-M3 "Ducati"
and DSP subsystems.

Use the omap_device_* API to control the hardware state, and utilize
the OMAP mailbox to interrupt the remote processor when a new message
is pending (the mailbox payload is used to tell it which virtqueue was
the message placed in).

Conversely, when an inbound mailbox message arrives, tell the remoteproc
core which virtqueue is triggered.

Later we will also use the mailbox payload to signal omap-specific
events like remote crashes (which will be used to trigger remoteproc
recovery) and power management transitions. At that point we will also
extend the remoteproc core to support this.

Based on (but now quite far from) work done by Fernando Guzman Lugo
<fernando.lugo@ti.com> and Hari Kanigeri <h-kanigeri2@ti.com>.

Designed with Brian Swetland <swetland@google.com>.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/plat-omap/include/plat/remoteproc.h |   56 ++++++
 drivers/amp/remoteproc/Kconfig               |   21 +++
 drivers/amp/remoteproc/Makefile              |    4 +-
 drivers/amp/remoteproc/omap_remoteproc.c     |  248 ++++++++++++++++++++++++++
 drivers/amp/remoteproc/omap_remoteproc.h     |   69 +++++++
 5 files changed, 397 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/plat/remoteproc.h
 create mode 100644 drivers/amp/remoteproc/omap_remoteproc.c
 create mode 100644 drivers/amp/remoteproc/omap_remoteproc.h

diff --git a/arch/arm/plat-omap/include/plat/remoteproc.h b/arch/arm/plat-omap/include/plat/remoteproc.h
new file mode 100644
index 0000000..8bfefde
--- /dev/null
+++ b/arch/arm/plat-omap/include/plat/remoteproc.h
@@ -0,0 +1,56 @@
+/*
+ * Remote Processor - omap-specific bits
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _PLAT_REMOTEPROC_H
+#define _PLAT_REMOTEPROC_H
+
+struct rproc_ops;
+struct platform_device;
+
+/*
+ * struct omap_rproc_pdata - omap remoteproc's platform data
+ * @name: the remoteproc's name
+ * @oh_name: omap hwmod device
+ * @oh_name_opt: optional, secondary omap hwmod device
+ * @firmware: name of firmware file to load
+ * @mbox_name: name of omap mailbox device to use with this rproc
+ * @ops: start/stop rproc handlers
+ * @device_enable: omap-specific handler for enabling a device
+ * @device_shutdown: omap-specific handler for shutting down a device
+ */
+struct omap_rproc_pdata {
+	const char *name;
+	const char *oh_name;
+	const char *oh_name_opt;
+	const char *firmware;
+	const char *mbox_name;
+	const struct rproc_ops *ops;
+	int (*device_enable) (struct platform_device *pdev);
+	int (*device_shutdown) (struct platform_device *pdev);
+};
+
+#if defined(CONFIG_OMAP_REMOTEPROC) || defined(CONFIG_OMAP_REMOTEPROC_MODULE)
+
+void __init omap_rproc_reserve_cma(void);
+
+#else
+
+void __init omap_rproc_reserve_cma(void)
+{
+}
+
+#endif
+
+#endif /* _PLAT_REMOTEPROC_H */
diff --git a/drivers/amp/remoteproc/Kconfig b/drivers/amp/remoteproc/Kconfig
index b250b15..78ebff9 100644
--- a/drivers/amp/remoteproc/Kconfig
+++ b/drivers/amp/remoteproc/Kconfig
@@ -1,3 +1,24 @@
 # REMOTEPROC gets selected by whoever wants it
 config REMOTEPROC
 	tristate
+
+config OMAP_REMOTEPROC
+	tristate "OMAP remoteproc support"
+	depends on ARCH_OMAP4
+	select OMAP_IOMMU
+	select REMOTEPROC
+	select OMAP_MBOX_FWK
+	select RPMSG
+	default m
+	help
+	  Say y here to support OMAP's remote processors (dual M3
+	  and DSP on OMAP4) via the remote processor framework.
+
+	  Currently only supported on OMAP4.
+
+	  Usually you want to say y here, in order to enable multimedia
+	  use-cases to run on your platform (multimedia codecs are
+	  offloaded to remote DSP processors using this framework).
+
+	  It's safe to say n here if you're not interested in multimedia
+	  offloading or just want a bare minimum kernel.
\ No newline at end of file
diff --git a/drivers/amp/remoteproc/Makefile b/drivers/amp/remoteproc/Makefile
index 0a24a3b..c948081 100644
--- a/drivers/amp/remoteproc/Makefile
+++ b/drivers/amp/remoteproc/Makefile
@@ -5,4 +5,6 @@
 obj-$(CONFIG_REMOTEPROC)		+= remoteproc.o
 remoteproc-y				:= remoteproc_core.o
 remoteproc-y				+= remoteproc_debugfs.o
-remoteproc-y				+= remoteproc_rpmsg.o
\ No newline at end of file
+remoteproc-y				+= remoteproc_rpmsg.o
+
+obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
\ No newline at end of file
diff --git a/drivers/amp/remoteproc/omap_remoteproc.c b/drivers/amp/remoteproc/omap_remoteproc.c
new file mode 100644
index 0000000..79573c9
--- /dev/null
+++ b/drivers/amp/remoteproc/omap_remoteproc.c
@@ -0,0 +1,248 @@
+/*
+ * OMAP Remote Processor driver
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Ohad Ben-Cohen <ohad@wizery.com>
+ * Brian Swetland <swetland@google.com>
+ * Fernando Guzman Lugo <fernando.lugo@ti.com>
+ * Mark Grosen <mgrosen@ti.com>
+ * Suman Anna <s-anna@ti.com>
+ * Hari Kanigeri <h-kanigeri2@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/amp/remoteproc.h>
+
+#include <plat/mailbox.h>
+#include <plat/remoteproc.h>
+
+#include "omap_remoteproc.h"
+#include "remoteproc_internal.h"
+
+/**
+ * struct omap_rproc - omap remote processor state
+ * @mbox: omap mailbox handle
+ * @nb: notifier block that will be invoked on inbound mailbox messages
+ * @rproc: rproc handle
+ */
+struct omap_rproc {
+	struct omap_mbox *mbox;
+	struct notifier_block nb;
+	struct rproc *rproc;
+};
+
+/**
+ * omap_rproc_mbox_callback() - inbound mailbox message handler
+ * @this: notifier block
+ * @index: unused
+ * @data: mailbox payload
+ *
+ * This handler is invoked by omap's mailbox driver whenever a mailbox
+ * message is received. Usually, the mailbox payload simply contains
+ * the index of the virtqueue that is kicked by the remote processor,
+ * and we let remoteproc core handle it.
+ *
+ * In addition to virtqueue indices, we also have some out-of-band values
+ * that indicates different events. Those values are deliberately very
+ * big so they don't coincide with virtqueue indices.
+ */
+static int omap_rproc_mbox_callback(struct notifier_block *this,
+					unsigned long index, void *data)
+{
+	mbox_msg_t msg = (mbox_msg_t) data;
+	struct omap_rproc *oproc = container_of(this, struct omap_rproc, nb);
+	struct device *dev = oproc->rproc->dev;
+	const char *name = oproc->rproc->name;
+
+	dev_dbg(dev, "mbox msg: 0x%x\n", msg);
+
+	switch (msg) {
+	case RP_MBOX_CRASH:
+		/* just log this for now. later, we'll also do recovery */
+		dev_err(dev, "omap rproc %s crashed\n", name);
+		break;
+	case RP_MBOX_ECHO_REPLY:
+		dev_info(dev, "received echo reply from %s\n", name);
+		break;
+	default:
+		/* ignore vq indices which are too large to be valid */
+		if (msg >= 2) {
+			dev_warn(dev, "invalid mbox msg: 0x%x\n", msg);
+			break;
+		}
+
+		/*
+		 * At this point, 'msg' contains the index of the vring
+		 * which was just triggered.
+		 */
+		if (rproc_vq_interrupt(oproc->rproc, msg) == IRQ_NONE)
+			dev_dbg(dev, "no message was found in vqid %d\n", msg);
+	}
+
+	return NOTIFY_DONE;
+}
+
+/* kick a virtqueue */
+static void omap_rproc_kick(struct rproc *rproc, int vqid)
+{
+	struct omap_rproc *oproc = rproc->priv;
+	int ret;
+
+	/* send the index of the triggered virtqueue in the mailbox payload */
+	ret = omap_mbox_msg_send(oproc->mbox, vqid);
+	if (ret)
+		dev_err(rproc->dev, "omap_mbox_msg_send failed: %d\n", ret);
+}
+
+/*
+ * Power up the remote processor.
+ *
+ * This function will be invoked only after the firmware for this rproc
+ * was loaded, parsed successfully, and all of its resource requirements
+ * were met.
+ */
+static int omap_rproc_start(struct rproc *rproc)
+{
+	struct omap_rproc *oproc = rproc->priv;
+	struct platform_device *pdev = to_platform_device(rproc->dev);
+	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
+	int ret;
+
+	oproc->nb.notifier_call = omap_rproc_mbox_callback;
+
+	/* every omap rproc is assigned a mailbox instance for messaging */
+	oproc->mbox = omap_mbox_get(pdata->mbox_name, &oproc->nb);
+	if (IS_ERR(oproc->mbox)) {
+		ret = PTR_ERR(oproc->mbox);
+		dev_err(rproc->dev, "omap_mbox_get failed: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * Ping the remote processor. this is only for sanity-sake;
+	 * there is no functional effect whatsoever.
+	 *
+	 * Note that the reply will _not_ arrive immediately: this message
+	 * will wait in the mailbox fifo until the remote processor is booted.
+	 */
+	ret = omap_mbox_msg_send(oproc->mbox, RP_MBOX_ECHO_REQUEST);
+	if (ret) {
+		dev_err(rproc->dev, "omap_mbox_get failed: %d\n", ret);
+		goto put_mbox;
+	}
+
+	ret = pdata->device_enable(pdev);
+	if (ret) {
+		dev_err(rproc->dev, "omap_device_enable failed: %d\n", ret);
+		goto put_mbox;
+	}
+
+	return 0;
+
+put_mbox:
+	omap_mbox_put(oproc->mbox, &oproc->nb);
+	return ret;
+}
+
+/* power off the remote processor */
+static int omap_rproc_stop(struct rproc *rproc)
+{
+	struct platform_device *pdev = to_platform_device(rproc->dev);
+	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
+	struct omap_rproc *oproc = rproc->priv;
+	int ret;
+
+	ret = pdata->device_shutdown(pdev);
+	if (ret)
+		return ret;
+
+	omap_mbox_put(oproc->mbox, &oproc->nb);
+
+	return 0;
+}
+
+static struct rproc_ops omap_rproc_ops = {
+	.start		= omap_rproc_start,
+	.stop		= omap_rproc_stop,
+	.kick		= omap_rproc_kick,
+};
+
+static int __devinit omap_rproc_probe(struct platform_device *pdev)
+{
+	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
+	struct omap_rproc *oproc;
+	struct rproc *rproc;
+	int ret;
+
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(pdev->dev.parent, "dma_set_coherent_mask: %d\n", ret);
+		return ret;
+	}
+
+	rproc = rproc_alloc(&pdev->dev, pdata->name, &omap_rproc_ops,
+				pdata->firmware, sizeof(*oproc));
+	if (!rproc)
+		return -ENOMEM;
+
+	oproc = rproc->priv;
+	oproc->rproc = rproc;
+
+	platform_set_drvdata(pdev, rproc);
+
+	ret = rproc_register(rproc);
+	if (ret)
+		goto free_rproc;
+
+	return 0;
+
+free_rproc:
+	rproc_free(rproc);
+	return ret;
+}
+
+static int __devexit omap_rproc_remove(struct platform_device *pdev)
+{
+	struct rproc *rproc = platform_get_drvdata(pdev);
+
+	return rproc_unregister(rproc);
+}
+
+static struct platform_driver omap_rproc_driver = {
+	.probe = omap_rproc_probe,
+	.remove = __devexit_p(omap_rproc_remove),
+	.driver = {
+		.name = "omap-rproc",
+		.owner = THIS_MODULE,
+	},
+};
+
+/* most of the below will go when module_platform_driver is merged */
+static int __init omap_rproc_init(void)
+{
+	return platform_driver_register(&omap_rproc_driver);
+}
+module_init(omap_rproc_init);
+
+static void __exit omap_rproc_exit(void)
+{
+	platform_driver_unregister(&omap_rproc_driver);
+}
+module_exit(omap_rproc_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("OMAP Remote Processor control driver");
diff --git a/drivers/amp/remoteproc/omap_remoteproc.h b/drivers/amp/remoteproc/omap_remoteproc.h
new file mode 100644
index 0000000..f6d2036
--- /dev/null
+++ b/drivers/amp/remoteproc/omap_remoteproc.h
@@ -0,0 +1,69 @@
+/*
+ * Remote processor messaging
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * * Redistributions of source code must retain the above copyright
+ *   notice, this list of conditions and the following disclaimer.
+ * * Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the
+ *   distribution.
+ * * Neither the name Texas Instruments nor the names of its
+ *   contributors may be used to endorse or promote products derived
+ *   from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _OMAP_RPMSG_H
+#define _OMAP_RPMSG_H
+
+/*
+ * enum - Predefined Mailbox Messages
+ *
+ * @RP_MBOX_READY: informs the M3's that we're up and running. this is
+ * part of the init sequence sent that the M3 expects to see immediately
+ * after it is booted.
+ *
+ * @RP_MBOX_PENDING_MSG: informs the receiver that there is an inbound
+ * message waiting in its own receive-side vring. please note that currently
+ * this message is optional: alternatively, one can explicitly send the index
+ * of the triggered virtqueue itself. the preferred approach will be decided
+ * as we progress and experiment with those two different approaches.
+ *
+ * @RP_MBOX_CRASH: this message is sent if BIOS crashes
+ *
+ * @RP_MBOX_ECHO_REQUEST: a mailbox-level "ping" message.
+ *
+ * @RP_MBOX_ECHO_REPLY: a mailbox-level reply to a "ping"
+ *
+ * @RP_MBOX_ABORT_REQUEST: a "please crash" request, used for testing the
+ * recovery mechanism (to some extent).
+ */
+enum omap_rp_mbox_messages {
+	RP_MBOX_READY		= 0xFFFFFF00,
+	RP_MBOX_PENDING_MSG	= 0xFFFFFF01,
+	RP_MBOX_CRASH		= 0xFFFFFF02,
+	RP_MBOX_ECHO_REQUEST	= 0xFFFFFF03,
+	RP_MBOX_ECHO_REPLY	= 0xFFFFFF04,
+	RP_MBOX_ABORT_REQUEST	= 0xFFFFFF05,
+};
+
+#endif /* _OMAP_RPMSG_H */
-- 
1.7.5.4

