Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab2CCPh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 10:37:59 -0500
Received: from b-mail.com.ua ([195.68.202.242]:59865 "EHLO b-mail.com.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab2CCPh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 10:37:58 -0500
X-Greylist: delayed 1343 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Mar 2012 10:37:58 EST
From: Mikhail Zolotaryov <lebon@lebon.org.ua>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikhail Zolotaryov <lebon@lebon.org.ua>
Subject: [PATCH 1/1] PCI: pciehp: Fast presence change handling
Date: Sat,  3 Mar 2012 17:13:33 +0200
Message-Id: <1330787613-24170-1-git-send-email-lebon@lebon.org.ua>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device is being removed and re-connected back fast enough (for
instance, due to the endpoint reset) the kernel is unable to handle a series
of resulting presence change events properly, the output is (twice):
   pciehp_check_link_status: lnk_status = 3011
   Device 0000:02:00.0 already exists at 0000:02:00, cannot hot-add
As a consequence, memory mappings are not enabled so the device is no
longer operating.

It should be a mistake to handle the Presence Detect function the same way
as the Attention Button: for the first the slot provides a current status
information (PCI_EXP_SLTSTA: Presence Detect State) together with a change
event itself (PCI_EXP_SLTSTA: Presence Detect Changed), the second is only
an event (Slot Status: Attention Button Pressed). As a consequence the
Attention Button handling should be based on the current slot power status
(existing implementation), the Presence Detect should rely on the register
data from ISR.

Another problem involved is a race condition requesting the
pciehp_power_thread work: instead of POWEROFF_STATE, POWERON_STATE sequence
execution it tries to run POWERON_STATE change twice - the shared variable
(slot status) is used to deliver the request. The solution is to separate
the latest slot status information from the power work request itself.

Both changes are required to make the presence change handled properly.

Signed-off-by: Mikhail Zolotaryov <lebon@lebon.org.ua>
---
 drivers/pci/hotplug/pciehp_ctrl.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 27f4429..4552244 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -276,6 +276,7 @@ static int remove_board(struct slot *p_slot)
 struct power_work_info {
 	struct slot *p_slot;
 	struct work_struct work;
+	u8 statereq;
 };
 
 /**
@@ -292,7 +293,7 @@ static void pciehp_power_thread(struct work_struct *work)
 	struct slot *p_slot = info->p_slot;
 
 	mutex_lock(&p_slot->lock);
-	switch (p_slot->state) {
+	switch (info->statereq) {
 	case POWEROFF_STATE:
 		mutex_unlock(&p_slot->lock);
 		ctrl_dbg(p_slot->ctrl,
@@ -301,14 +302,18 @@ static void pciehp_power_thread(struct work_struct *work)
 			 p_slot->ctrl->pcie->port->subordinate->number);
 		pciehp_disable_slot(p_slot);
 		mutex_lock(&p_slot->lock);
-		p_slot->state = STATIC_STATE;
+		/* Change to static only if request matches latest slot state */
+		if (p_slot->state == info->statereq)
+			p_slot->state = STATIC_STATE;
 		break;
 	case POWERON_STATE:
 		mutex_unlock(&p_slot->lock);
 		if (pciehp_enable_slot(p_slot) && PWR_LED(p_slot->ctrl))
 			pciehp_green_led_off(p_slot);
 		mutex_lock(&p_slot->lock);
-		p_slot->state = STATIC_STATE;
+		/* Change to static only if request matches latest slot state */
+		if (p_slot->state == info->statereq)
+			p_slot->state = STATIC_STATE;
 		break;
 	default:
 		break;
@@ -335,10 +340,10 @@ void pciehp_queue_pushbutton_work(struct work_struct *work)
 	mutex_lock(&p_slot->lock);
 	switch (p_slot->state) {
 	case BLINKINGOFF_STATE:
-		p_slot->state = POWEROFF_STATE;
+		info->statereq = p_slot->state = POWEROFF_STATE;
 		break;
 	case BLINKINGON_STATE:
-		p_slot->state = POWERON_STATE;
+		info->statereq = p_slot->state = POWERON_STATE;
 		break;
 	default:
 		kfree(info);
@@ -419,9 +424,8 @@ static void handle_button_press_event(struct slot *p_slot)
 /*
  * Note: This function must be called with slot->lock held
  */
-static void handle_surprise_event(struct slot *p_slot)
+static void handle_surprise_event(struct slot *p_slot, int poweroff)
 {
-	u8 getstatus;
 	struct power_work_info *info;
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
@@ -433,11 +437,10 @@ static void handle_surprise_event(struct slot *p_slot)
 	info->p_slot = p_slot;
 	INIT_WORK(&info->work, pciehp_power_thread);
 
-	pciehp_get_adapter_status(p_slot, &getstatus);
-	if (!getstatus)
-		p_slot->state = POWEROFF_STATE;
+	if (poweroff)
+		info->statereq = p_slot->state = POWEROFF_STATE;
 	else
-		p_slot->state = POWERON_STATE;
+		info->statereq = p_slot->state = POWERON_STATE;
 
 	queue_work(pciehp_wq, &info->work);
 }
@@ -466,7 +469,10 @@ static void interrupt_event_handler(struct work_struct *work)
 		if (!HP_SUPR_RM(ctrl))
 			break;
 		ctrl_dbg(ctrl, "Surprise Removal\n");
-		handle_surprise_event(p_slot);
+		if (info->event_type == INT_PRESENCE_OFF)
+			handle_surprise_event(p_slot, 1);
+		else
+			handle_surprise_event(p_slot, 0);
 		break;
 	default:
 		break;
-- 
1.7.3.4

