Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1LLR2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:28:37 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46135
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753593Ab1LLR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:28:33 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 2/4] Drivers: hv: Make the vmbus driver unloadable
Date: Mon, 12 Dec 2011 09:29:17 -0800
Message-Id: <1323710959-29655-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323710959-29655-1-git-send-email-kys@microsoft.com>
References: <1323710931-29616-1-git-send-email-kys@microsoft.com>
 <1323710959-29655-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that the vmbus driver can be made unloadable. Make it
unloadable.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel_mgmt.c |   11 +++++++++++
 drivers/hv/hv.c           |    3 +++
 drivers/hv/hyperv_vmbus.h |    1 +
 drivers/hv/vmbus_drv.c    |   11 +++++++++++
 4 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index b91af50..36484db 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -223,6 +223,17 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 	vmbus_device_unregister(channel->device_obj);
 }
 
+void vmbus_free_channels(void)
+{
+	struct vmbus_channel *channel;
+
+	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
+		vmbus_device_unregister(channel->device_obj);
+		kfree(channel->device_obj);
+		free_channel(channel);
+	}
+}
+
 /*
  * vmbus_process_offer - Process the offer by creating a channel/device
  * associated with this offer
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 0fb100e..f8a77d0 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -237,6 +237,9 @@ void hv_cleanup(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 
+	/* Reset our OS id */
+	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
+
 	kfree(hv_context.signal_event_buffer);
 	hv_context.signal_event_buffer = NULL;
 	hv_context.signal_event_param = NULL;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 0aee112..6d7d286 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -611,6 +611,7 @@ void vmbus_device_unregister(struct hv_device *device_obj);
 
 struct vmbus_channel *relid2channel(u32 relid);
 
+void vmbus_free_channels(void);
 
 /* Connection interface */
 
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 0c048dd..aafee6b 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -779,8 +779,19 @@ cleanup:
 	return ret;
 }
 
+static void __exit vmbus_exit(void)
+{
+
+	free_irq(irq, hv_acpi_dev);
+	vmbus_free_channels();
+	bus_unregister(&hv_bus);
+	hv_cleanup();
+	acpi_bus_unregister_driver(&vmbus_acpi_driver);
+}
+
 
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 
 module_init(hv_acpi_init);
+module_exit(vmbus_exit);
-- 
1.7.4.1

