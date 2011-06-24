Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1FXQtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:49:15 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:38227 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab1FXQtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:49:11 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 1/2] USB: EHCI: Move sysfs related bits into ehci-sysfs.c
Date: Fri, 24 Jun 2011 20:48:07 +0400
Message-Id: <2a537d4dffef27cc7839eb19889eaa035edd44f9.1308933456.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc3
In-Reply-To: <cover.1308933456.git.kirr@mns.spb.ru>
References: <cover.1308933456.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1308933456.git.kirr@mns.spb.ru>
References: <cover.1308933456.git.kirr@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only sysfs attr implemented so far is "companion" from ehci-hub.c,
but in the next patch we are going to add another sysfs file, so prior
to that let's structure things and move already-in-there sysfs code to
separate file.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/usb/host/ehci-hcd.c   |    5 +-
 drivers/usb/host/ehci-hub.c   |   75 --------------------------------
 drivers/usb/host/ehci-sysfs.c |   94 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+), 77 deletions(-)
 create mode 100644 drivers/usb/host/ehci-sysfs.c

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index e18862c..8306155 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -336,6 +336,7 @@ static void ehci_work(struct ehci_hcd *ehci);
 #include "ehci-mem.c"
 #include "ehci-q.c"
 #include "ehci-sched.c"
+#include "ehci-sysfs.c"
 
 /*-------------------------------------------------------------------------*/
 
@@ -520,7 +521,7 @@ static void ehci_stop (struct usb_hcd *hcd)
 	ehci_reset (ehci);
 	spin_unlock_irq(&ehci->lock);
 
-	remove_companion_file(ehci);
+	remove_sysfs_files(ehci);
 	remove_debug_files (ehci);
 
 	/* root hub is shut down separately (first, when possible) */
@@ -754,7 +755,7 @@ static int ehci_run (struct usb_hcd *hcd)
 	 * since the class device isn't created that early.
 	 */
 	create_debug_files(ehci);
-	create_companion_file(ehci);
+	create_sysfs_files(ehci);
 
 	return 0;
 }
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index ea6184b..d9e8d71 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -471,29 +471,6 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 
 /*-------------------------------------------------------------------------*/
 
-/* Display the ports dedicated to the companion controller */
-static ssize_t show_companion(struct device *dev,
-			      struct device_attribute *attr,
-			      char *buf)
-{
-	struct ehci_hcd		*ehci;
-	int			nports, index, n;
-	int			count = PAGE_SIZE;
-	char			*ptr = buf;
-
-	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
-	nports = HCS_N_PORTS(ehci->hcs_params);
-
-	for (index = 0; index < nports; ++index) {
-		if (test_bit(index, &ehci->companion_ports)) {
-			n = scnprintf(ptr, count, "%d\n", index + 1);
-			ptr += n;
-			count -= n;
-		}
-	}
-	return ptr - buf;
-}
-
 /*
  * Sets the owner of a port
  */
@@ -528,58 +505,6 @@ static void set_owner(struct ehci_hcd *ehci, int portnum, int new_owner)
 	}
 }
 
-/*
- * Dedicate or undedicate a port to the companion controller.
- * Syntax is "[-]portnum", where a leading '-' sign means
- * return control of the port to the EHCI controller.
- */
-static ssize_t store_companion(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct ehci_hcd		*ehci;
-	int			portnum, new_owner;
-
-	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
-	new_owner = PORT_OWNER;		/* Owned by companion */
-	if (sscanf(buf, "%d", &portnum) != 1)
-		return -EINVAL;
-	if (portnum < 0) {
-		portnum = - portnum;
-		new_owner = 0;		/* Owned by EHCI */
-	}
-	if (portnum <= 0 || portnum > HCS_N_PORTS(ehci->hcs_params))
-		return -ENOENT;
-	portnum--;
-	if (new_owner)
-		set_bit(portnum, &ehci->companion_ports);
-	else
-		clear_bit(portnum, &ehci->companion_ports);
-	set_owner(ehci, portnum, new_owner);
-	return count;
-}
-static DEVICE_ATTR(companion, 0644, show_companion, store_companion);
-
-static inline int create_companion_file(struct ehci_hcd *ehci)
-{
-	int	i = 0;
-
-	/* with integrated TT there is no companion! */
-	if (!ehci_is_TDI(ehci))
-		i = device_create_file(ehci_to_hcd(ehci)->self.controller,
-				       &dev_attr_companion);
-	return i;
-}
-
-static inline void remove_companion_file(struct ehci_hcd *ehci)
-{
-	/* with integrated TT there is no companion! */
-	if (!ehci_is_TDI(ehci))
-		device_remove_file(ehci_to_hcd(ehci)->self.controller,
-				   &dev_attr_companion);
-}
-
-
 /*-------------------------------------------------------------------------*/
 
 static int check_reset_complete (
diff --git a/drivers/usb/host/ehci-sysfs.c b/drivers/usb/host/ehci-sysfs.c
new file mode 100644
index 0000000..347c8cb
--- /dev/null
+++ b/drivers/usb/host/ehci-sysfs.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2001-2004 by David Brownell
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* this file is part of ehci-hcd.c */
+
+
+/* Display the ports dedicated to the companion controller */
+static ssize_t show_companion(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct ehci_hcd		*ehci;
+	int			nports, index, n;
+	int			count = PAGE_SIZE;
+	char			*ptr = buf;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	nports = HCS_N_PORTS(ehci->hcs_params);
+
+	for (index = 0; index < nports; ++index) {
+		if (test_bit(index, &ehci->companion_ports)) {
+			n = scnprintf(ptr, count, "%d\n", index + 1);
+			ptr += n;
+			count -= n;
+		}
+	}
+	return ptr - buf;
+}
+
+/*
+ * Dedicate or undedicate a port to the companion controller.
+ * Syntax is "[-]portnum", where a leading '-' sign means
+ * return control of the port to the EHCI controller.
+ */
+static ssize_t store_companion(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct ehci_hcd		*ehci;
+	int			portnum, new_owner;
+
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
+	new_owner = PORT_OWNER;		/* Owned by companion */
+	if (sscanf(buf, "%d", &portnum) != 1)
+		return -EINVAL;
+	if (portnum < 0) {
+		portnum = - portnum;
+		new_owner = 0;		/* Owned by EHCI */
+	}
+	if (portnum <= 0 || portnum > HCS_N_PORTS(ehci->hcs_params))
+		return -ENOENT;
+	portnum--;
+	if (new_owner)
+		set_bit(portnum, &ehci->companion_ports);
+	else
+		clear_bit(portnum, &ehci->companion_ports);
+	set_owner(ehci, portnum, new_owner);
+	return count;
+}
+static DEVICE_ATTR(companion, 0644, show_companion, store_companion);
+
+static inline int create_sysfs_files(struct ehci_hcd *ehci)
+{
+	int	i = 0;
+
+	/* with integrated TT there is no companion! */
+	if (!ehci_is_TDI(ehci))
+		i = device_create_file(ehci_to_hcd(ehci)->self.controller,
+				       &dev_attr_companion);
+	return i;
+}
+
+static inline void remove_sysfs_files(struct ehci_hcd *ehci)
+{
+	/* with integrated TT there is no companion! */
+	if (!ehci_is_TDI(ehci))
+		device_remove_file(ehci_to_hcd(ehci)->self.controller,
+				   &dev_attr_companion);
+}
-- 
1.7.6.rc3

