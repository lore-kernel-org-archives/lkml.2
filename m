Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935579Ab2KATRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:17:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:38876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935144Ab2KATRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:17:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="241495273"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/6] mei: normalize timeouts definitions
Date: Thu,  1 Nov 2012 21:17:14 +0200
Message-Id: <1351797438-26345-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
References: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. The hardware book defines timeouts in seconds
 so we stick to this and define the wrapper function
 mei_secs_to_jiffies  around  msecs_to_jiffies
 to use be used instead multiplying by HZ

2. We add name space prefix MEI_ to all timer defines

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw.h        |   14 +++++++-------
 drivers/misc/mei/init.c      |   18 +++++++++---------
 drivers/misc/mei/interrupt.c |    4 ++--
 drivers/misc/mei/iorw.c      |    8 ++++----
 drivers/misc/mei/main.c      |    2 +-
 drivers/misc/mei/mei_dev.h   |    5 +++++
 drivers/misc/mei/wd.c        |    2 +-
 7 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 9700532..f21721a 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -20,16 +20,16 @@
 #include <linux/uuid.h>
 
 /*
- * Timeouts
+ * Timeouts in Seconds
  */
-#define MEI_INTEROP_TIMEOUT    (HZ * 7)
-#define MEI_CONNECT_TIMEOUT		3	/* at least 2 seconds */
+#define MEI_INTEROP_TIMEOUT         7  /* Timeout on ready message */
+#define MEI_CONNECT_TIMEOUT         3  /* HPS: at least 2 seconds */
 
-#define CONNECT_TIMEOUT        15	/* HPS definition */
-#define INIT_CLIENTS_TIMEOUT   15	/* HPS definition */
+#define MEI_CL_CONNECT_TIMEOUT     15  /* HPS: Client Connect Timeout */
+#define MEI_CLIENTS_INIT_TIMEOUT   15  /* HPS: Clients Enumeration Timeout */
 
-#define IAMTHIF_STALL_TIMER		12	/* seconds */
-#define IAMTHIF_READ_TIMER		10000	/* ms */
+#define MEI_IAMTHIF_STALL_TIMER    12  /* HPS */
+#define MEI_IAMTHIF_READ_TIMER     10  /* HPS */
 
 /*
  * Internal Clients Number
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 1f13eb9..e6951ec 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -184,7 +184,8 @@ int mei_hw_init(struct mei_device *dev)
 	if (!dev->recvd_msg) {
 		mutex_unlock(&dev->device_lock);
 		err = wait_event_interruptible_timeout(dev->wait_recvd_msg,
-			dev->recvd_msg, MEI_INTEROP_TIMEOUT);
+			dev->recvd_msg,
+			mei_secs_to_jiffies(MEI_INTEROP_TIMEOUT));
 		mutex_lock(&dev->device_lock);
 	}
 
@@ -381,7 +382,7 @@ void mei_host_start_message(struct mei_device *dev)
 		mei_reset(dev, 1);
 	}
 	dev->init_clients_state = MEI_START_MESSAGE;
-	dev->init_clients_timer = INIT_CLIENTS_TIMEOUT;
+	dev->init_clients_timer = MEI_CLIENTS_INIT_TIMEOUT;
 	return ;
 }
 
@@ -414,7 +415,7 @@ void mei_host_enum_clients_message(struct mei_device *dev)
 		mei_reset(dev, 1);
 	}
 	dev->init_clients_state = MEI_ENUM_CLIENTS_MESSAGE;
-	dev->init_clients_timer = INIT_CLIENTS_TIMEOUT;
+	dev->init_clients_timer = MEI_CLIENTS_INIT_TIMEOUT;
 	return;
 }
 
@@ -502,7 +503,7 @@ int mei_host_client_properties(struct mei_device *dev)
 			return -EIO;
 		}
 
-		dev->init_clients_timer = INIT_CLIENTS_TIMEOUT;
+		dev->init_clients_timer = MEI_CLIENTS_INIT_TIMEOUT;
 		dev->me_client_index = b;
 		return 1;
 	}
@@ -621,7 +622,7 @@ void mei_host_init_iamthif(struct mei_device *dev)
 		dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
 		dev->iamthif_cl.host_client_id = 0;
 	} else {
-		dev->iamthif_cl.timer_count = CONNECT_TIMEOUT;
+		dev->iamthif_cl.timer_count = MEI_CONNECT_TIMEOUT;
 	}
 }
 
@@ -658,9 +659,8 @@ struct mei_cl *mei_cl_allocate(struct mei_device *dev)
  */
 int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
 {
-	int rets, err;
-	long timeout = 15;	/* 15 seconds */
 	struct mei_cl_cb *cb;
+	int rets, err;
 
 	if (!dev || !cl)
 		return -ENODEV;
@@ -690,8 +690,8 @@ int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
 	mutex_unlock(&dev->device_lock);
 
 	err = wait_event_timeout(dev->wait_recvd_msg,
-		 (MEI_FILE_DISCONNECTED == cl->state),
-		 timeout * HZ);
+			MEI_FILE_DISCONNECTED == cl->state,
+			mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 
 	mutex_lock(&dev->device_lock);
 	if (MEI_FILE_DISCONNECTED == cl->state) {
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 5c65bac..248f581 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -269,7 +269,7 @@ static int _mei_irq_thread_iamthif_read(struct mei_device *dev, s32 *slots)
 	dev->iamthif_flow_control_pending = false;
 	dev->iamthif_msg_buf_index = 0;
 	dev->iamthif_msg_buf_size = 0;
-	dev->iamthif_stall_timer = IAMTHIF_STALL_TIMER;
+	dev->iamthif_stall_timer = MEI_IAMTHIF_STALL_TIMER;
 	dev->mei_host_buffer_is_empty = mei_hbuf_is_empty(dev);
 	return 0;
 }
@@ -1379,7 +1379,7 @@ void mei_timer(struct work_struct *work)
 	if (dev->iamthif_timer) {
 
 		timeout = dev->iamthif_timer +
-				msecs_to_jiffies(IAMTHIF_READ_TIMER);
+			mei_secs_to_jiffies(MEI_IAMTHIF_READ_TIMER);
 
 		dev_dbg(&dev->pdev->dev, "dev->iamthif_timer = %ld\n",
 				dev->iamthif_timer);
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index 541c157..8026cbf 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -173,7 +173,7 @@ int mei_ioctl_connect_client(struct file *file,
 	struct mei_cl *cl;
 	struct mei_cl *cl_pos = NULL;
 	struct mei_cl *cl_next = NULL;
-	long timeout = CONNECT_TIMEOUT;
+	long timeout = mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT);
 	int i;
 	int err;
 	int rets;
@@ -291,8 +291,7 @@ int mei_ioctl_connect_client(struct file *file,
 	mutex_unlock(&dev->device_lock);
 	err = wait_event_timeout(dev->wait_recvd_msg,
 			(MEI_FILE_CONNECTED == cl->state ||
-			 MEI_FILE_DISCONNECTED == cl->state),
-			timeout * HZ);
+			 MEI_FILE_DISCONNECTED == cl->state), timeout);
 
 	mutex_lock(&dev->device_lock);
 	if (MEI_FILE_CONNECTED == cl->state) {
@@ -415,7 +414,8 @@ int amthi_read(struct mei_device *dev, struct file *file,
 	dev->iamthif_timer = 0;
 
 	if (cb) {
-		timeout = cb->read_time + msecs_to_jiffies(IAMTHIF_READ_TIMER);
+		timeout = cb->read_time +
+			mei_secs_to_jiffies(MEI_IAMTHIF_READ_TIMER);
 		dev_dbg(&dev->pdev->dev, "amthi timeout = %lud\n",
 				timeout);
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 7a03d77..659727a 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -567,7 +567,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 		if (write_cb) {
 			timeout = write_cb->read_time +
-					msecs_to_jiffies(IAMTHIF_READ_TIMER);
+				mei_secs_to_jiffies(MEI_IAMTHIF_READ_TIMER);
 
 			if (time_after(jiffies, timeout) ||
 			    cl->reading_state == MEI_READ_COMPLETE) {
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 6adcb3f..32c951a 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -270,6 +270,11 @@ struct mei_device {
 	bool iamthif_canceled;
 };
 
+static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
+{
+	return msecs_to_jiffies(sec * MSEC_PER_SEC);
+}
+
 
 /*
  * mei init function prototypes
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index d96c537..8edb054 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -85,7 +85,7 @@ int mei_wd_host_init(struct mei_device *dev)
 		dev->wd_cl.host_client_id = 0;
 		return -EIO;
 	}
-	dev->wd_cl.timer_count = CONNECT_TIMEOUT;
+	dev->wd_cl.timer_count = MEI_CONNECT_TIMEOUT;
 
 	return 0;
 }
-- 
1.7.4.4

