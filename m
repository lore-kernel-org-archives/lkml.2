Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0FIIpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:45:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44738 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab0FIIpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:45:42 -0400
From: naveen_jain@ti.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pavan_savoy@ti.com, Naveen Jain <naveen_jain@ti.com>
Subject: [PATCH 1/2] drivers:staging: ti-st: cleanup sysfs code
Date: Wed,  9 Jun 2010 03:45:32 -0500
Message-Id: <1276073133-17711-1-git-send-email-naveen_jain@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Jain <naveen_jain@ti.com>

Remove the older way of communicating with user-space
daemon UIM.
The older way involved creating of a new kobj and pid
sysfs file under it, and sending signal using that pid.

Now we communicate via rfkill to user-space UIM.

Background: UIM is the user-space daemon which upon
notification from ldisc driver, opens the tty, sets
default baud and then installs (tiocsetd) the ldisc.

Signed-off-by: Naveen Jain <naveen_jain@ti.com>
---
 drivers/staging/ti-st/st_kim.c |   49 +++++-----------------------------------
 drivers/staging/ti-st/st_kim.h |    4 ---
 2 files changed, 6 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index 98cbabb..cfba5f8 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -55,7 +55,6 @@ static struct platform_driver kim_platform_driver = {
 		   },
 };
 
-#ifndef LEGACY_RFKILL_SUPPORT
 static ssize_t show_pid(struct device *dev, struct device_attribute
 			*attr, char *buf);
 static ssize_t store_pid(struct device *dev, struct device_attribute
@@ -80,12 +79,11 @@ static struct attribute *uim_attrs[] = {
 static struct attribute_group uim_attr_grp = {
 	.attrs = uim_attrs,
 };
-#else
+
 static int kim_toggle_radio(void*, bool);
 static const struct rfkill_ops kim_rfkill_ops = {
 	.set_block = kim_toggle_radio,
 };
-#endif	/* LEGACY_RFKILL_SUPPORT */
 
 /* strings to be used for rfkill entries and by
  * ST Core to be used for sysfs debug entry
@@ -436,13 +434,11 @@ long st_kim_start(void)
 	pr_info(" %s", __func__);
 
 	do {
-#ifdef LEGACY_RFKILL_SUPPORT
 		/* TODO: this is only because rfkill sub-system
 		 * doesn't send events to user-space if the state
 		 * isn't changed
 		 */
 		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
-#endif
 		/* Configure BT nShutdown to HIGH state */
 		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
 		mdelay(5);	/* FIXME: a proper toggle */
@@ -450,7 +446,7 @@ long st_kim_start(void)
 		mdelay(100);
 		/* re-initialize the completion */
 		INIT_COMPLETION(kim_gdata->ldisc_installed);
-#ifndef LEGACY_RFKILL_SUPPORT
+#if 0 /* older way of signalling user-space UIM */
 		/* send signal to UIM */
 		err = kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 0);
 		if (err != 0) {
@@ -458,10 +454,9 @@ long st_kim_start(void)
 			err = ST_ERR_FAILURE;
 			continue;
 		}
-#else
+#endif
 		/* unblock and send event to UIM via /dev/rfkill */
 		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 0);
-#endif
 		/* wait for ldisc to be installed */
 		err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
 				msecs_to_jiffies(LDISC_TIME));
@@ -491,17 +486,16 @@ long st_kim_stop(void)
 	long err = ST_SUCCESS;
 
 	INIT_COMPLETION(kim_gdata->ldisc_installed);
-#ifndef LEGACY_RFKILL_SUPPORT
+#if 0 /* older way of signalling user-space UIM */
 	/* send signal to UIM */
 	err = kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 1);
 	if (err != 0) {
 		pr_err("sending SIGUSR2 to uim failed %ld", err);
 		return ST_ERR_FAILURE;
 	}
-#else
+#endif
 	/* set BT rfkill to be blocked */
 	err = rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
-#endif
 
 	/* wait for ldisc to be un-installed */
 	err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
@@ -523,7 +517,6 @@ long st_kim_stop(void)
 /**********************************************************************/
 /* functions called from subsystems */
 
-#ifndef LEGACY_RFKILL_SUPPORT
 /* called when sysfs entry is written to */
 static ssize_t store_pid(struct device *dev, struct device_attribute
 			 *devattr, char *buf, size_t count)
@@ -551,8 +544,6 @@ static ssize_t show_list(struct device *dev, struct device_attribute
 	return strlen(buf);
 }
 
-#else /* LEGACY_RFKILL_SUPPORT */
-
 /* function called from rfkill subsystem, when someone from
  * user space would write 0/1 on the sysfs entry
  * /sys/class/rfkill/rfkill0,1,3/state
@@ -580,8 +571,6 @@ static int kim_toggle_radio(void *data, bool blocked)
 	return ST_SUCCESS;
 }
 
-#endif	/* LEGACY_RFKILL_SUPPORT */
-
 void st_kim_ref(struct st_data_s **core_data)
 {
 	*core_data = kim_gdata->core_data;
@@ -639,30 +628,12 @@ static int kim_probe(struct platform_device *pdev)
 			return status;
 		}
 	}
-#ifndef LEGACY_RFKILL_SUPPORT
-	/* pdev to contain BT, FM and GPS enable/N-Shutdown GPIOs
-	 * execute request_gpio, set output direction
-	 */
-	kim_gdata->kim_kobj = kobject_create_and_add("uim", NULL);
-	/* create the sysfs entry for UIM to put in pid */
-	if (sysfs_create_group(kim_gdata->kim_kobj, &uim_attr_grp)) {
-		pr_err(" sysfs entry creation failed");
-		kobject_put(kim_gdata->kim_kobj);
-		/* free requested GPIOs and fail probe */
-		for (proto = ST_BT; proto < ST_MAX; proto++) {
-			if (gpios[proto] != -1)
-				gpio_free(gpios[proto]);
-		}
-		return -1;	/* fail insmod */
-	}
-	pr_info(" sysfs entry created ");
-#endif
 	/* get reference of pdev for request_firmware
 	 */
 	kim_gdata->kim_pdev = pdev;
 	init_completion(&kim_gdata->kim_rcvd);
 	init_completion(&kim_gdata->ldisc_installed);
-#ifdef LEGACY_RFKILL_SUPPORT
+
 	for (proto = 0; (proto < ST_MAX) && (gpios[proto] != -1); proto++) {
 		/* TODO: should all types be rfkill_type_bt ? */
 		kim_gdata->rf_protos[proto] = proto;
@@ -685,7 +656,6 @@ static int kim_probe(struct platform_device *pdev)
 		}
 		pr_info("rfkill entry created for %ld", gpios[proto]);
 	}
-#endif
 	return ST_SUCCESS;
 }
 
@@ -701,18 +671,11 @@ static int kim_remove(struct platform_device *pdev)
 		 * nShutdown gpio from the system
 		 */
 		gpio_free(gpios[proto]);
-#ifdef LEGACY_RFKILL_SUPPORT
 		rfkill_unregister(kim_gdata->rfkill[proto]);
 		rfkill_destroy(kim_gdata->rfkill[proto]);
 		kim_gdata->rfkill[proto] = NULL;
-#endif
 	}
 	pr_info("kim: GPIO Freed");
-#ifndef LEGACY_RFKILL_SUPPORT
-	/* delete the sysfs entries */
-	sysfs_remove_group(kim_gdata->kim_kobj, &uim_attr_grp);
-	kobject_put(kim_gdata->kim_kobj);
-#endif
 	kim_gdata->kim_pdev = NULL;
 	st_core_exit(kim_gdata->core_data);
 	return ST_SUCCESS;
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
index ff3270e..49c42ae 100644
--- a/drivers/staging/ti-st/st_kim.h
+++ b/drivers/staging/ti-st/st_kim.h
@@ -48,7 +48,6 @@
  * devices are created for the 3 gpios
  * that ST has requested
  */
-#define LEGACY_RFKILL_SUPPORT
 /*
  * header file for ST provided by KIM
  */
@@ -60,15 +59,12 @@ struct kim_data_s {
 	char resp_buffer[30];
 	const struct firmware *fw_entry;
 	long gpios[ST_MAX];
-	struct kobject *kim_kobj;
 /* used by kim_int_recv to validate fw response */
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
-#ifdef LEGACY_RFKILL_SUPPORT
 	struct rfkill *rfkill[ST_MAX];
 	enum proto_type rf_protos[ST_MAX];
-#endif
 	struct st_data_s *core_data;
 };
 
-- 
1.5.6.3

