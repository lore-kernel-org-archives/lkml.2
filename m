Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab0GAVDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:03:24 -0400
Received: from kroah.org ([198.145.64.141]:47889 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848Ab0GAUvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:18 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:38 2010
Message-Id: <20100701173438.293755080@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [patch 136/164] eeepc-laptop: check wireless hotplug events
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

commit bc9d24a3aeb1532fc3e234907a8b6d671f7ed68f upstream.

Before we mark the wireless device as unplugged, check PCI config space
to see whether the wireless device is really disabled (and vice versa).
This works around newer models which don't want the hotplug code, where
we end up disabling the wired network device.

My old 701 still works correctly with this.  I can also simulate an
afflicted model by changing the hardcoded PCI bus/slot number in the
driver, and it seems to work nicely (although it is a bit noisy).

In future this type of hotplug support will be implemented by the PCI
core.  The existing blacklist and the new warning message will be
removed at that point.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/eeepc-laptop.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -578,6 +578,8 @@ static void eeepc_rfkill_hotplug(struct
 	struct pci_dev *dev;
 	struct pci_bus *bus;
 	bool blocked = eeepc_wlan_rfkill_blocked(eeepc);
+	bool absent;
+	u32 l;
 
 	if (eeepc->wlan_rfkill)
 		rfkill_set_sw_state(eeepc->wlan_rfkill, blocked);
@@ -591,6 +593,22 @@ static void eeepc_rfkill_hotplug(struct
 			goto out_unlock;
 		}
 
+		if (pci_bus_read_config_dword(bus, 0, PCI_VENDOR_ID, &l)) {
+			pr_err("Unable to read PCI config space?\n");
+			goto out_unlock;
+		}
+		absent = (l == 0xffffffff);
+
+		if (blocked != absent) {
+			pr_warning("BIOS says wireless lan is %s, "
+					"but the pci device is %s\n",
+				blocked ? "blocked" : "unblocked",
+				absent ? "absent" : "present");
+			pr_warning("skipped wireless hotplug as probably "
+					"inappropriate for this model\n");
+			goto out_unlock;
+		}
+
 		if (!blocked) {
 			dev = pci_get_slot(bus, 0);
 			if (dev) {


