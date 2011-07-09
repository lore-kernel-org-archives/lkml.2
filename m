Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1GIOne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:43:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39376 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1GIOnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:43:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 Jul 2011 16:43:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: cdev: prevent race between first get_info ioctl
 and bus reset event queuing
Message-ID: <20110709164322.2deb2f36@stein>
In-Reply-To: <20110709164226.519a81fe@stein>
References: <20110709164226.519a81fe@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Between open(2) of a /dev/fw* and the first FW_CDEV_IOC_GET_INFO
ioctl(2) on it, the kernel already queues FW_CDEV_EVENT_BUS_RESET events
to be read(2) by the client.  The get_info ioctl is practically always
issued right away after open, hence this condition only occurs if the
client opens during a bus reset, especially during a rapid series of bus
resets.

The problem with this condition is two-fold:

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
---
 drivers/firewire/core-cdev.c  |   18 ++++++++++--------
 include/linux/firewire-cdev.h |    3 +++
 2 files changed, 13 insertions(+), 8 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -253,14 +253,11 @@ static int fw_device_op_open(struct inod
 	init_waitqueue_head(&client->wait);
 	init_waitqueue_head(&client->tx_flush_wait);
 	INIT_LIST_HEAD(&client->phy_receiver_link);
+	INIT_LIST_HEAD(&client->link);
 	kref_init(&client->kref);
 
 	file->private_data = client;
 
-	mutex_lock(&device->client_list_mutex);
-	list_add_tail(&client->link, &device->client_list);
-	mutex_unlock(&device->client_list_mutex);
-
 	return nonseekable_open(inode, file);
 }
 
@@ -451,15 +448,20 @@ static int ioctl_get_info(struct client
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
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -475,6 +475,9 @@ union fw_cdev_event {
  *		of the bus.  This does not cause a bus reset to happen.
  * @bus_reset_closure: Value of &closure in this and subsequent bus reset events
  * @card:	The index of the card this device belongs to
+ *
+ * As a side effect, reception of %FW_CDEV_EVENT_BUS_RESET events to be read(2)
+ * is started by this ioctl.
  */
 struct fw_cdev_get_info {
 	__u32 version;


-- 
Stefan Richter
-=====-==-== -=== -=--=
http://arcgraph.de/sr/
