Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1G1Xwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:52:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:29705 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab1G1Xo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33352025"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: stefanr@s5r6.in-berlin.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [21/50] firewire: cdev: prevent race between first get_info ioctl
Message-Id: <20110728234425.AA3BF2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

[ upstream commit 93b37905f70083d6143f5f4dba0a45cc64379a62 ]
 and bus reset event queuing

Between open(2) of a /dev/fw* and the first FW_CDEV_IOC_GET_INFO
ioctl(2) on it, the kernel already queues FW_CDEV_EVENT_BUS_RESET events
to be read(2) by the client.  The get_info ioctl is practically always
issued right away after open, hence this condition only occurs if the
client opens during a bus reset, especially during a rapid series of bus
resets.

The problem with this condition is twofold:

  - These bus reset events carry the (as yet undocumented) @closure
    value of 0.  But it is not the kernel's place to choose closures;
    they are privat to the client.  E.g., this 0 value forced from the
    kernel makes it unsafe for clients to dereference it as a pointer to
    a closure object without NULL pointer check.

  - It is impossible for clients to determine the relative order of bus
    reset events from get_info ioctl(2) versus those from read(2),
    except in one way:  By comparison of closure values.  Again, such a
    procedure imposes complexity on clients and reduces freedom in use
    of the bus reset closure.

So, change the ABI to suppress queuing of bus reset events before the
first FW_CDEV_IOC_GET_INFO ioctl was issued by the client.

Note, this ABI change cannot be version-controlled.  The kernel cannot
distinguish old from new clients before the first FW_CDEV_IOC_GET_INFO
ioctl.

We will try to back-merge this change into currently maintained stable/
longterm series, and we only document the new behaviour.  The old
behavior is now considered a kernel bug, which it basically is.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.35.y.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.35.y/drivers/firewire/core-cdev.c
@@ -219,14 +219,11 @@ static int fw_device_op_open(struct inod
 	idr_init(&client->resource_idr);
 	INIT_LIST_HEAD(&client->event_list);
 	init_waitqueue_head(&client->wait);
+	INIT_LIST_HEAD(&client->link);
 	kref_init(&client->kref);
 
 	file->private_data = client;
 
-	mutex_lock(&device->client_list_mutex);
-	list_add_tail(&client->link, &device->client_list);
-	mutex_unlock(&device->client_list_mutex);
-
 	return nonseekable_open(inode, file);
 }
 
@@ -414,15 +411,20 @@ static int ioctl_get_info(struct client 
 	if (ret != 0)
 		return -EFAULT;
 
+	mutex_lock(&client->device->client_list_mutex);
+
 	client->bus_reset_closure = a->bus_reset_closure;
 	if (a->bus_reset != 0) {
 		fill_bus_reset_event(&bus_reset, client);
-		if (copy_to_user(u64_to_uptr(a->bus_reset),
-				 &bus_reset, sizeof(bus_reset)))
-			return -EFAULT;
+		ret = copy_to_user(u64_to_uptr(a->bus_reset),
+				   &bus_reset, sizeof(bus_reset));
 	}
+	if (ret == 0 && list_empty(&client->link))
+		list_add_tail(&client->link, &client->device->client_list);
 
-	return 0;
+	mutex_unlock(&client->device->client_list_mutex);
+
+	return ret ? -EFAULT : 0;
 }
 
 static int add_client_resource(struct client *client,
Index: linux-2.6.35.y/include/linux/firewire-cdev.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/firewire-cdev.h
+++ linux-2.6.35.y/include/linux/firewire-cdev.h
@@ -284,6 +284,9 @@ union fw_cdev_event {
  *		of the bus.  This does not cause a bus reset to happen.
  * @bus_reset_closure: Value of &closure in this and subsequent bus reset events
  * @card:	The index of the card this device belongs to
+ *
+ * As a side effect, reception of %FW_CDEV_EVENT_BUS_RESET events to be read(2)
+ * is started by this ioctl.
  */
 struct fw_cdev_get_info {
 	__u32 version;
