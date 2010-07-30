Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab0G3RWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:22:54 -0400
Received: from kroah.org ([198.145.64.141]:52342 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758927Ab0G3RUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:20:33 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:14 2010
Message-Id: <20100730171514.104320686@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:16:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        Corentin Chary <corentincj@iksaif.net>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [160/165] eeepc-laptop: check wireless hotplug events
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/eeepc-laptop.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -752,6 +752,8 @@ static void eeepc_rfkill_hotplug(void)
 	struct pci_dev *dev;
 	struct pci_bus *bus;
 	bool blocked = eeepc_wlan_rfkill_blocked();
+	bool absent;
+	u32 l;
 
 	if (ehotk->wlan_rfkill)
 		rfkill_set_sw_state(ehotk->wlan_rfkill, blocked);
@@ -765,6 +767,22 @@ static void eeepc_rfkill_hotplug(void)
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


