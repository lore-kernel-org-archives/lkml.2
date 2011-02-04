Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1BDIXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 03:23:25 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40234 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1BDIXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 03:23:21 -0500
From: pavan_savoy@ti.com
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/7] drivers:misc: ti-st: fix error codes
Date: Fri,  4 Feb 2011 02:23:11 -0600
Message-Id: <1296807795-5408-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1296807795-5408-3-git-send-email-pavan_savoy@ti.com>
References: <1296807795-5408-1-git-send-email-pavan_savoy@ti.com>
 <1296807795-5408-2-git-send-email-pavan_savoy@ti.com>
 <1296807795-5408-3-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

set-right the error codes that the shared transport driver
returns.
Instead of magic numbers like -1, return relevant codes such as
ETIMEDOUT or EIO, EAGAIN when wait times out or uart write bytes don't
match expected value or when registration fails and needs to be
attempted again.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_core.c |   31 ++++++++++++++-----------------
 drivers/misc/ti-st/st_kim.c  |   18 +++++++++---------
 drivers/misc/ti-st/st_ll.c   |    2 +-
 3 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 84d73c5..79d2dc3 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -65,7 +65,7 @@ int st_int_write(struct st_data_s *st_gdata,
 	struct tty_struct *tty;
 	if (unlikely(st_gdata == NULL || st_gdata->tty == NULL)) {
 		pr_err("tty unavailable to perform write");
-		return -1;
+		return -EINVAL;
 	}
 	tty = st_gdata->tty;
 #ifdef VERBOSE
@@ -124,9 +124,15 @@ void st_reg_complete(struct st_data_s *st_gdata, char err)
 	pr_info(" %s ", __func__);
 	for (i = 0; i < ST_MAX_CHANNELS; i++) {
 		if (likely(st_gdata != NULL && st_gdata->list[i] != NULL &&
-			   st_gdata->list[i]->reg_complete_cb != NULL))
+			   st_gdata->list[i]->reg_complete_cb != NULL)) {
 			st_gdata->list[i]->reg_complete_cb
 				(st_gdata->list[i]->priv_data, err);
+			pr_info("protocol %d's cb sent %d\n", i, err);
+			if (err) { /* cleanup registered protocol */
+				st_gdata->protos_registered--;
+				st_gdata->list[i] = NULL;
+			}
+		}
 	}
 }
 
@@ -457,15 +463,7 @@ long st_register(struct st_proto_s *new_proto)
 	if (st_gdata == NULL || new_proto == NULL || new_proto->recv == NULL
 	    || new_proto->reg_complete_cb == NULL) {
 		pr_err("gdata/new_proto/recv or reg_complete_cb not ready");
-		if (st_gdata == NULL)
-			pr_err("error 1\n");
-		if (new_proto == NULL)
-			pr_err("error 2\n");
-		if (new_proto->recv == NULL)
-			pr_err("error 3\n");
-		if (new_proto->reg_complete_cb == NULL)
-			pr_err("erro 4\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	if (new_proto->chnl_id >= ST_MAX_CHANNELS) {
@@ -512,10 +510,9 @@ long st_register(struct st_proto_s *new_proto)
 			if ((st_gdata->protos_registered != ST_EMPTY) &&
 			    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
 				pr_err(" KIM failure complete callback ");
-				st_reg_complete(st_gdata, -1);
+				st_reg_complete(st_gdata, err);
 			}
-
-			return -1;
+			return -EINVAL;
 		}
 
 		/* the chnl_id might require other gpios to be toggled
@@ -634,14 +631,14 @@ long st_write(struct sk_buff *skb)
 	if (unlikely(skb == NULL || st_gdata == NULL
 		|| st_gdata->tty == NULL)) {
 		pr_err("data/tty unavailable to perform write");
-		return -1;
+		return -EINVAL;
 	}
 #ifdef DEBUG			/* open-up skb to read the 1st byte */
 	chnl_id = skb->data[0];
 	if (unlikely(st_gdata->list[chnl_id] == NULL)) {
 		pr_err(" chnl_id %d not registered, and writing? ",
 			   chnl_id);
-		return -1;
+		return -EINVAL;
 	}
 #endif
 	pr_debug("%d to be written", skb->len);
@@ -829,7 +826,7 @@ int st_core_init(struct st_data_s **core_data)
 		err = tty_unregister_ldisc(N_TI_WL);
 		if (err)
 			pr_err("unable to un-register ldisc");
-		return -1;
+		return err;
 	}
 	*core_data = st_gdata;
 	return 0;
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index a7fda81..ccc46a7 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -201,13 +201,13 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 	INIT_COMPLETION(kim_gdata->kim_rcvd);
 	if (4 != st_int_write(kim_gdata->core_data, read_ver_cmd, 4)) {
 		pr_err("kim: couldn't write 4 bytes");
-		return -1;
+		return -EIO;
 	}
 
 	if (!wait_for_completion_timeout
 	    (&kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME))) {
 		pr_err(" waiting for ver info- timed out ");
-		return -1;
+		return -ETIMEDOUT;
 	}
 
 	version =
@@ -257,7 +257,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 		     (kim_gdata->fw_entry->size == 0))) {
 		pr_err(" request_firmware failed(errno %ld) for %s", err,
 			   bts_scr_name);
-		return -1;
+		return -EINVAL;
 	}
 	ptr = (void *)kim_gdata->fw_entry->data;
 	len = kim_gdata->fw_entry->size;
@@ -292,7 +292,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 					   ((struct bts_action *)ptr)->size);
 			if (unlikely(err < 0)) {
 				release_firmware(kim_gdata->fw_entry);
-				return -1;
+				return err;
 			}
 			if (!wait_for_completion_timeout
 			    (&kim_gdata->kim_rcvd,
@@ -301,7 +301,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 				    (" response timeout during fw download ");
 				/* timed out */
 				release_firmware(kim_gdata->fw_entry);
-				return -1;
+				return -ETIMEDOUT;
 			}
 			break;
 		case ACTION_DELAY:	/* sleep */
@@ -436,7 +436,7 @@ long st_kim_start(void *kim_data)
 			pr_info("ldisc_install = 0");
 			sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
 					NULL, "install");
-			err = -1;
+			err = -ETIMEDOUT;
 			continue;
 		} else {
 			/* ldisc installed now */
@@ -482,7 +482,7 @@ long st_kim_stop(void *kim_data)
 			msecs_to_jiffies(LDISC_TIME));
 	if (!err) {		/* timeout */
 		pr_err(" timed out waiting for ldisc to be un-installed");
-		return -1;
+		return -ETIMEDOUT;
 	}
 
 	/* By default configure BT nShutdown to LOW state */
@@ -642,7 +642,7 @@ static int kim_probe(struct platform_device *pdev)
 	status = st_core_init(&kim_gdata->core_data);
 	if (status != 0) {
 		pr_err(" ST core init failed");
-		return -1;
+		return -EIO;
 	}
 	/* refer to itself */
 	kim_gdata->core_data->kim_data = kim_gdata;
@@ -704,7 +704,7 @@ static int kim_probe(struct platform_device *pdev)
 	if (IS_ERR(kim_debugfs_dir)) {
 		pr_err(" debugfs entries creation failed ");
 		kim_debugfs_dir = NULL;
-		return -1;
+		return -EIO;
 	}
 
 	debugfs_create_file("version", S_IRUGO, kim_debugfs_dir,
diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
index 2bda8de..f72de6b 100644
--- a/drivers/misc/ti-st/st_ll.c
+++ b/drivers/misc/ti-st/st_ll.c
@@ -130,7 +130,7 @@ unsigned long st_ll_sleep_state(struct st_data_s *st_data,
 		break;
 	default:
 		pr_err(" unknown input/state ");
-		return -1;
+		return -EINVAL;
 	}
 	return 0;
 }
-- 
1.6.3.3

