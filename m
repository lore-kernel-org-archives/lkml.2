Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab0DVT4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:56:49 -0400
Received: from kroah.org ([198.145.64.141]:40803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab0DVT2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:31 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:14 2010
Message-Id: <20100422190914.277347553@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [077/197] eeepc-laptop: dmi blacklist to disable pci hotplug code
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 10ae4b5663ff3092553bfbd867e7bd474ce6c553 upstream.

This is a short term workaround for Eeepc 1005HA.

refs: <http://bugzilla.kernel.org/show_bug.cgi?id=14570>

[bwh: Backported to 2.6.32]

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/eeepc-laptop.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -137,6 +137,7 @@ struct eeepc_hotk {
 	u32 cm_supported;		/* the control methods supported
 					   by this BIOS */
 	bool cpufv_disabled;
+	bool hotplug_disabled;
 	uint init_flag;			/* Init flags */
 	u16 event_count[128];		/* count for each event */
 	struct input_dev *inputdev;
@@ -614,6 +615,10 @@ static void eeepc_dmi_check(void)
 {
 	const char *model;
 
+	model = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!model)
+		return;
+
 	/*
 	 * Blacklist for setting cpufv (cpu speed).
 	 *
@@ -633,17 +638,24 @@ static void eeepc_dmi_check(void)
 	 * substring matching.  We don't want to affect the "701SD"
 	 * and "701SDX" models, because they do support S.H.E.
 	 */
-
-	model = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!model)
-		return;
-
 	if (strcmp(model, "701") == 0 || strcmp(model, "702") == 0) {
 		ehotk->cpufv_disabled = true;
 		pr_info("model %s does not officially support setting cpu "
 			"speed\n", model);
 		pr_info("cpufv disabled to avoid instability\n");
 	}
+
+	/*
+	 * Blacklist for wlan hotplug
+	 *
+	 * Eeepc 1005HA doesn't work like others models and don't need the
+	 * hotplug code. In fact, current hotplug code seems to unplug another
+	 * device...
+	 */
+	if (strcmp(model, "1005HA") == 0) {
+		ehotk->hotplug_disabled = true;
+		pr_info("wlan hotplug disabled\n");
+	}
 }
 
 static void cmsg_quirk(int cm, const char *name)
@@ -1177,6 +1189,9 @@ static int eeepc_rfkill_init(struct devi
 	if (result && result != -ENODEV)
 		goto exit;
 
+	if (ehotk->hotplug_disabled)
+		return 0;
+
 	result = eeepc_setup_pci_hotplug();
 	/*
 	 * If we get -EBUSY then something else is handling the PCI hotplug -


