Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2E2VNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 17:13:11 -0400
Received: from mail.datadirectnet.com ([74.62.46.229]:26015 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755678Ab2E2VNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 17:13:09 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2012 17:13:09 EDT
Message-ID: <4FC53AAA.3060203@ddn.com>
Date: Tue, 29 May 2012 17:07:54 -0400
From: Karandeep Chahal <kchahal@ddn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
CC: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com
Subject: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
Content-Type: multipart/mixed;
	boundary="------------000800000401030407040103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000800000401030407040103
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Subject: [PATCH] Infiniband srp fast failover patch. Currently ib_srp does
  not do anything on receiving a DREQ from the target, it
  only sends a response back. Further it also does not
  monitor port (down) events. I have patched srp to remove
  scsi devices when a port down event is received or if the
  target sends a DREQ. Currently even though the target
  notifies the initiator of its intentions of going away, the
  initiator ignores that information. Later the initiator
  gets upset when the devices "suddenly" disappear resulting
  in srp initiating an error recovery process which takes a
  long time. This caused high failover latencies as compared
  to fibre channel. In my experiments with RHEL 6.0 and 6.2 I
  encountered failover time that exceeded 2 minutes and 20
  seconds (despite tweaking /etc/multipath.conf and
  /sys/block/<>/timeout). With this patch the failover takes
  30 seconds. I have tested this patch with and without a
  switch.

Yours, etc.
Karan


--------------000800000401030407040103
Content-Type: text/x-patch;
	name="0001-Infiniband-srp-fast-failover-patch.-Currently-ib_srp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-Infiniband-srp-fast-failover-patch.-Currently-ib_srp.pa";
	filename*1="tch"

>From 4ebb453ccde59cf0b674bd4a23fb85f4a3333618 Mon Sep 17 00:00:00 2001
From: Karandeep Chahal <kchahal@ddn.com>
Date: Tue, 29 May 2012 16:48:20 -0400
Subject: [PATCH] Infiniband srp fast failover patch. Currently ib_srp does
 not do anything on receiving a DREQ from the target, it
 only sends a response back. Further it also does not
 monitor port (down) events. I have patched srp to remove
 scsi devices when a port down event is received or if the
 target sends a DREQ. Currently even though the target
 notifies the initiator of its intentions of going away, the
 initiator ignores that information. Later the initiator
 gets upset when the devices "suddenly" disappear resulting
 in srp initiating an error recovery process which takes a
 long time. This caused high failover latencies as compared
 to fibre channel. In my experiments with RHEL 6.0 and 6.2 I
 encountered failover time that exceeded 2 minutes and 20
 seconds (despite tweaking /etc/multipath.conf and
 /sys/block/<>/timeout). With this patch the failover takes
 30 seconds. I have tested this patch with and without a
 switch.


Signed-off-by: Karandeep Chahal <kchahal@ddn.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   64 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bcbf22e..088215b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1524,6 +1524,37 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 	}
 }
 
+static void srp_mark_all_devices_dead(int port_num, struct srp_device *srp_dev,
+				    struct ib_cm_id *cm_id)
+{
+	struct srp_host *host, *tmp_host;
+	struct srp_target_port *target;
+
+	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
+		/*
+		 * Mark all target ports as removed, so we stop queueing
+		 * commands and don't try to reconnect.
+		 */
+		if ((port_num != -1) && (port_num != host->port))
+			continue;
+
+		spin_lock(&host->target_lock);
+		list_for_each_entry(target, &host->target_list, list) {
+			if (!cm_id || (target->cm_id == cm_id)) {
+
+				shost_printk(KERN_WARNING, target->scsi_host,
+				     PFX "Removing all scsi devices\n");
+				spin_lock_irq(&target->lock);
+				target->state = SRP_TARGET_DEAD;
+				INIT_WORK(&target->work, srp_remove_work);
+				queue_work(ib_wq, &target->work);
+				spin_unlock_irq(&target->lock);
+			}
+		}
+		spin_unlock(&host->target_lock);
+	}
+}
+
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 {
 	struct srp_target_port *target = cm_id->context;
@@ -1555,6 +1586,8 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
+		srp_mark_all_devices_dead(-1, target->srp_host->srp_dev,
+				     cm_id);
 		break;
 
 	case IB_CM_TIMEWAIT_EXIT:
@@ -2284,6 +2317,31 @@ free_host:
 	return NULL;
 }
 
+static void srp_event_handler(struct ib_event_handler *handler,
+				    struct ib_event *event)
+{
+	struct srp_device *srp_dev;
+
+	switch (event->event) {
+
+	case IB_EVENT_DEVICE_FATAL:
+	case IB_EVENT_PORT_ERR:
+		srp_dev = container_of(handler, struct srp_device,
+				    event_handler);
+
+		printk(KERN_INFO PFX "%s port %d down detected\n",
+				    srp_dev->dev->name,
+				    event->element.port_num);
+
+		srp_mark_all_devices_dead(event->element.port_num,
+				    srp_dev, NULL);
+		break;
+
+	default:
+		break;
+	}
+}
+
 static void srp_add_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
@@ -2366,6 +2424,10 @@ static void srp_add_one(struct ib_device *device)
 
 	ib_set_client_data(device, &srp_client, srp_dev);
 
+	INIT_IB_EVENT_HANDLER(&srp_dev->event_handler, device,
+				    srp_event_handler);
+	ib_register_event_handler(&srp_dev->event_handler);
+
 	goto free_attr;
 
 err_pd:
@@ -2387,6 +2449,8 @@ static void srp_remove_one(struct ib_device *device)
 
 	srp_dev = ib_get_client_data(device, &srp_client);
 
+	ib_unregister_event_handler(&srp_dev->event_handler);
+
 	list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list, list) {
 		device_unregister(&host->dev);
 		/*
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 020caf0..e0737a1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -97,6 +97,7 @@ struct srp_device {
 	struct ib_pd	       *pd;
 	struct ib_mr	       *mr;
 	struct ib_fmr_pool     *fmr_pool;
+	struct ib_event_handler event_handler;
 	u64			fmr_page_mask;
 	int			fmr_page_size;
 	int			fmr_max_size;
-- 
1.7.7.6


--------------000800000401030407040103--
