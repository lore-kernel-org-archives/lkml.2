Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2KKPiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:38:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:12053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab2KKPiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:38:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,757,1344236400"; 
   d="scan'208";a="217934061"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 6/7] mei: use link and unlink terms for connecting ME and HOST client
Date: Sun, 11 Nov 2012 17:38:03 +0200
Message-Id: <1352648284-8838-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
References: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. rename mei_me_cl_update_filext to mei_me_cl_link
2. rename mei_remove_client_from_file_list to mei_me_cl_unlink

Code style, documenation, and usage of both function is updated

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c  |    4 +-
 drivers/misc/mei/init.c    |   67 +++++++++++++++++++++-----------------------
 drivers/misc/mei/iorw.c    |   16 +----------
 drivers/misc/mei/main.c    |    6 ++--
 drivers/misc/mei/mei_dev.h |    4 +-
 drivers/misc/mei/wd.c      |    8 ++--
 6 files changed, 44 insertions(+), 61 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 7416241..095d059 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -73,10 +73,10 @@ void mei_amthif_host_init(struct mei_device *dev)
 	dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
 
 	/* find ME amthi client */
-	i = mei_me_cl_update_filext(dev, &dev->iamthif_cl,
+	i = mei_me_cl_link(dev, &dev->iamthif_cl,
 			    &mei_amthi_guid, MEI_IAMTHIF_HOST_CLIENT_ID);
 	if (i < 0) {
-		dev_dbg(&dev->pdev->dev, "failed to find iamthif client.\n");
+		dev_info(&dev->pdev->dev, "failed to find iamthif client.\n");
 		return;
 	}
 
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 85b6520..4fcb0bb 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -281,12 +281,10 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 			cl_pos->timer_count = 0;
 		}
 		/* remove entry if already in list */
-		dev_dbg(&dev->pdev->dev, "list del iamthif and wd file list.\n");
-		mei_remove_client_from_file_list(dev,
-				dev->wd_cl.host_client_id);
+		dev_dbg(&dev->pdev->dev, "remove iamthif and wd from the file list.\n");
+		mei_me_cl_unlink(dev, &dev->wd_cl);
 
-		mei_remove_client_from_file_list(dev,
-				dev->iamthif_cl.host_client_id);
+		mei_me_cl_unlink(dev, &dev->iamthif_cl);
 
 		mei_amthif_reset_params(dev);
 		dev->extra_write_index = 0;
@@ -520,17 +518,20 @@ int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *cuuid)
 
 
 /**
- * mei_me_cl_update_filext - searches for ME client guid
- *                       sets client_id in mei_file_private if found
+ * mei_me_cl_link - create link between host and me clinet and add
+ *   me_cl to the list
+ *
  * @dev: the device structure
- * @cl: private file structure to set client_id in
- * @cuuid: searched uuid of ME client
- * @client_id: id of host client to be set in file private structure
+ * @cl: link between me and host client assocated with opened file descriptor
+ * @cuuid: uuid of ME client
+ * @client_id: id of the host client
  *
- * returns ME client index
+ * returns ME client index if ME client
+ *	-EINVAL on incorrect values
+ *	-ENONET if client not found
  */
-int mei_me_cl_update_filext(struct mei_device *dev, struct mei_cl *cl,
-				const uuid_le *cuuid, u8 host_cl_id)
+int mei_me_cl_link(struct mei_device *dev, struct mei_cl *cl,
+			const uuid_le *cuuid, u8 host_cl_id)
 {
 	int i;
 
@@ -550,6 +551,24 @@ int mei_me_cl_update_filext(struct mei_device *dev, struct mei_cl *cl,
 
 	return -ENOENT;
 }
+/**
+ * mei_me_cl_unlink - remove me_cl from the list
+ *
+ * @dev: the device structure
+ * @host_client_id: host client id to be removed
+ */
+void mei_me_cl_unlink(struct mei_device *dev, struct mei_cl *cl)
+{
+	struct mei_cl *pos, *next;
+	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
+		if (cl->host_client_id == pos->host_client_id) {
+			dev_dbg(&dev->pdev->dev, "remove host client = %d, ME client = %d\n",
+					pos->host_client_id, pos->me_client_id);
+			list_del_init(&pos->link);
+			break;
+		}
+	}
+}
 
 /**
  * mei_alloc_file_private - allocates a private file structure and sets it up.
@@ -642,25 +661,3 @@ free:
 	return rets;
 }
 
-/**
- * mei_remove_client_from_file_list -
- *	removes file private data from device file list
- *
- * @dev: the device structure
- * @host_client_id: host client id to be removed
- */
-void mei_remove_client_from_file_list(struct mei_device *dev,
-				       u8 host_client_id)
-{
-	struct mei_cl *cl_pos = NULL;
-	struct mei_cl *cl_next = NULL;
-	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
-		if (host_client_id == cl_pos->host_client_id) {
-			dev_dbg(&dev->pdev->dev, "remove host client = %d, ME client = %d\n",
-					cl_pos->host_client_id,
-					cl_pos->me_client_id);
-			list_del_init(&cl_pos->link);
-			break;
-		}
-	}
-}
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index cf11076..eb93a1b 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -171,8 +171,6 @@ int mei_ioctl_connect_client(struct file *file,
 	struct mei_cl_cb *cb;
 	struct mei_client *client;
 	struct mei_cl *cl;
-	struct mei_cl *cl_pos = NULL;
-	struct mei_cl *cl_next = NULL;
 	long timeout = mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT);
 	int i;
 	int err;
@@ -229,21 +227,9 @@ int mei_ioctl_connect_client(struct file *file,
 			goto end;
 		}
 		clear_bit(cl->host_client_id, dev->host_clients_map);
-		list_for_each_entry_safe(cl_pos, cl_next,
-					 &dev->file_list, link) {
-			if (mei_cl_cmp_id(cl, cl_pos)) {
-				dev_dbg(&dev->pdev->dev,
-					"remove file private data node host"
-				    " client = %d, ME client = %d.\n",
-				    cl_pos->host_client_id,
-				    cl_pos->me_client_id);
-				list_del(&cl_pos->link);
-			}
+		mei_me_cl_unlink(dev, cl);
 
-		}
-		dev_dbg(&dev->pdev->dev, "free file private data memory.\n");
 		kfree(cl);
-
 		cl = NULL;
 		file->private_data = &dev->iamthif_cl;
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 2cc1ebb..251aaff 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -227,7 +227,7 @@ static int mei_release(struct inode *inode, struct file *file)
 		clear_bit(cl->host_client_id, dev->host_clients_map);
 		dev->open_handle_count--;
 	}
-	mei_remove_client_from_file_list(dev, cl->host_client_id);
+	mei_me_cl_unlink(dev, cl);
 
 	/* free read cb */
 	cb = NULL;
@@ -913,8 +913,8 @@ static void __devexit mei_remove(struct pci_dev *pdev)
 
 	/* remove entry if already in list */
 	dev_dbg(&pdev->dev, "list del iamthif and wd file list.\n");
-	mei_remove_client_from_file_list(dev, dev->wd_cl.host_client_id);
-	mei_remove_client_from_file_list(dev, dev->iamthif_cl.host_client_id);
+	mei_me_cl_unlink(dev, &dev->wd_cl);
+	mei_me_cl_unlink(dev, &dev->iamthif_cl);
 
 	dev->iamthif_current_cb = NULL;
 	dev->me_clients_num = 0;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index dad85f3..aaee666 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -301,12 +301,12 @@ int mei_hw_init(struct mei_device *dev);
 int mei_task_initialize_clients(void *data);
 int mei_initialize_clients(struct mei_device *dev);
 int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl);
-void mei_remove_client_from_file_list(struct mei_device *dev, u8 host_client_id);
 void mei_allocate_me_clients_storage(struct mei_device *dev);
 
 
-int mei_me_cl_update_filext(struct mei_device *dev, struct mei_cl *cl,
+int mei_me_cl_link(struct mei_device *dev, struct mei_cl *cl,
 			const uuid_le *cguid, u8 host_client_id);
+void mei_me_cl_unlink(struct mei_device *dev, struct mei_cl *cl);
 int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *cuuid);
 int mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
 
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 4fc2b3d..636409f 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -62,6 +62,7 @@ static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
  */
 int mei_wd_host_init(struct mei_device *dev)
 {
+	int id;
 	mei_cl_init(&dev->wd_cl, dev);
 
 	/* look for WD client and connect to it */
@@ -69,12 +70,11 @@ int mei_wd_host_init(struct mei_device *dev)
 	dev->wd_timeout = MEI_WD_DEFAULT_TIMEOUT;
 	dev->wd_state = MEI_WD_IDLE;
 
-	/* find ME WD client */
-	mei_me_cl_update_filext(dev, &dev->wd_cl,
+	/* Connect WD ME client to the host client */
+	id = mei_me_cl_link(dev, &dev->wd_cl,
 				&mei_wd_guid, MEI_WD_HOST_CLIENT_ID);
 
-	dev_dbg(&dev->pdev->dev, "wd: check client\n");
-	if (MEI_FILE_CONNECTING != dev->wd_cl.state) {
+	if (id < 0) {
 		dev_info(&dev->pdev->dev, "wd: failed to find the client\n");
 		return -ENOENT;
 	}
-- 
1.7.4.4

