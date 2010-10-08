Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab0JHUXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:23:22 -0400
Received: from out1.ip04ir2.opaltelecom.net ([62.24.128.240]:13043 "EHLO
	out1.ip04ir2.opaltelecom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655Ab0JHUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:23:21 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2010 16:23:20 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBALIXr0xcB+hA/2dsb2JhbAAH4jGFRwSFCQ
X-IronPort-AV: E=Sophos;i="4.57,305,1283727600"; 
   d="scan'208";a="307204540"
Message-ID: <4CAF7B6C.2050202@talktalk.net>
Date: Fri, 08 Oct 2010 21:13:32 +0100
From: Duncan Simpson <dpsimpson@talktalk.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Firmware loading race condition (+fix)
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a nasty race condition in base/firmware_class.c which
*definitely* affects the bnx2 drivers, and almost certainly also
affects the bnx2x driver. When you load the firmware the first 5
events which happen are:

1. _request_firmware generates uevent which starts hotplug
2. The hotplug script loads the mips firmware
3. unregistering the device generates another uevent
4. _request_firmware removes the device
5. The hotplug script tries to reload the *same* firmware again

Step 5 is the wrong thing. Effects range from kernel null pointer
deference via the device not working due to incorrect firmware to
annoying but harmless error messages. Let it suffice to say I had
some serious hardware with 4 on board bnx2 devices of which at
one reliably does not work (assumming, as was usually the case,
the kernel null pointer dererefence timing was avoided).

My employer wants the fix below to be sent upstream from an email
address which does not allow them to be identified. The fix below
solves the problem by adding DEVSTATUS to the environment which is
0 at step 2 and either 2 or 4, depending on whether the firmware
loading worked or not, at step 5.

The hotplug script has to be changed to only load the firmware is
DEVSTATUS is 0. The patch fixes the simple hotplug script in the
Documentation directory to do this. Please Cc: responses to me
because I do not have sufficient bandwidth to read LKML in addition
to the mail I currently receive.

If your hardware only has one piece of firmware or you use built
in firmware or never experience unfortunate timing you wont
experience this particular bug, which I suspect has been present
for a long time. I think the only multiple firmware drivers are
currently bnx2 and bnx2x.

When the fix is applied all 4 bnx2 interfaces on the box which had
problems all work and can be relied upon to work.

Duncan (-:

diff -ur linux-2.6.35.7/Documentation/firmware_class/hotplug-script linux-2.6.35.7.new/Documentation/firmware_class/hotplug-script
--- linux-2.6.35.7/Documentation/firmware_class/hotplug-script	2010-09-29 02:09:08.000000000 +0100
+++ linux-2.6.35.7.new/Documentation/firmware_class/hotplug-script	2010-10-08 17:20:12.989065696 +0100
@@ -2,13 +2,15 @@

 # Simple hotplug script sample:
 #
-# Both $DEVPATH and $FIRMWARE are already provided in the environment.
-
+# $DEVSTATUS, $DEVPATH and $FIRMWARE are already in the environment.
+	
 HOTPLUG_FW_DIR=/usr/lib/hotplug/firmware/

-echo 1 > /sys/$DEVPATH/loading
-cat $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data
-echo 0 > /sys/$DEVPATH/loading
+if [ $DEVSTATUS -eq 0 ]; then
+    echo 1 > /sys/$DEVPATH/loading
+    cat $HOTPLUG_FW_DIR/$FIRMWARE > /sysfs/$DEVPATH/data
+    echo 0 > /sys/$DEVPATH/loading
+fi

 # To cancel the load in case of error:
 #
diff -ur linux-2.6.35.7/Documentation/firmware_class/README linux-2.6.35.7.new/Documentation/firmware_class/README
--- linux-2.6.35.7/Documentation/firmware_class/README	2010-09-29 02:09:08.000000000 +0100
+++ linux-2.6.35.7.new/Documentation/firmware_class/README	2010-10-08 17:18:40.078685400 +0100
@@ -56,13 +56,15 @@
  Sample/simple hotplug script:
  ============================

-	# Both $DEVPATH and $FIRMWARE are already provided in the environment.
-
+	# $DEVSTATUS, $DEVPATH and $FIRMWARE are already in the environment.
+	
 	HOTPLUG_FW_DIR=/usr/lib/hotplug/firmware/

-	echo 1 > /sys/$DEVPATH/loading
-	cat $HOTPLUG_FW_DIR/$FIRMWARE > /sysfs/$DEVPATH/data
-	echo 0 > /sys/$DEVPATH/loading
+	if [ $DEVSTATUS -eq 0 ]; then
+	    echo 1 > /sys/$DEVPATH/loading
+	    cat $HOTPLUG_FW_DIR/$FIRMWARE > /sysfs/$DEVPATH/data
+	    echo 0 > /sys/$DEVPATH/loading
+	fi

  Random notes:
  ============
@@ -80,6 +82,11 @@
    user contexts to request firmware asynchronously, but can't be called
    in atomic contexts.

+ - after the load has finished or been aborted the script is called
+   with DEVSTATUS either 2 (success) or 4 (aborted/failed). Bad things
+   can happen if you try loading firmware in either case, especially
+   if a device has 2 or more distinct pieces of firmware.
+

  about in-kernel persistence:
  ---------------------------
diff -ur linux-2.6.35.7/drivers/base/firmware_class.c linux-2.6.35.7.new/drivers/base/firmware_class.c
--- linux-2.6.35.7/drivers/base/firmware_class.c	2010-09-29 02:09:08.000000000 +0100
+++ linux-2.6.35.7.new/drivers/base/firmware_class.c	2010-10-08 17:32:16.298766180 +0100
@@ -168,6 +168,8 @@
 		return -ENOMEM;
 	if (add_uevent_var(env, "ASYNC=%d", fw_priv->nowait))
 		return -ENOMEM;
+	if (add_uevent_var(env, "DEVSTATUS=%d", fw_priv->status))
+		return -ENOMEM;

 	return 0;
 }
@@ -227,6 +229,12 @@
 	case 1:
 		mutex_lock(&fw_lock);
 		if (!fw_priv->fw) {
+			dev_err(dev, "%s: unexpected value (1) after loading %s completed.\n", __func__, fw_priv->fw_id);
+			mutex_unlock(&fw_lock);
+			break;
+		}
+		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)!=0) {
+			dev_err(dev, "%s: unexpected value (1) after while %s loading.\n", __func__, fw_priv->fw_id);
 			mutex_unlock(&fw_lock);
 			break;
 		}
@@ -259,6 +267,7 @@
 			fw_priv->page_array_size = 0;
 			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
+			set_bit(FW_STATUS_DONE, &fw_priv->status);
 			clear_bit(FW_STATUS_LOADING, &fw_priv->status);
 			break;
 		}
@@ -565,7 +574,6 @@

 		kobject_uevent(&f_dev->kobj, KOBJ_ADD);
 		wait_for_completion(&fw_priv->completion);
-		set_bit(FW_STATUS_DONE, &fw_priv->status);
 		del_timer_sync(&fw_priv->timeout);
 	} else
 		wait_for_completion(&fw_priv->completion);
