Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2IRL3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:29:07 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59445 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323Ab2IRL3F convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 18 Sep 2012 07:29:05 -0400
Message-Id: <5058771F020000780009C025@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 18 Sep 2012 12:29:03 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-pciback: support wild cards in slot specifications
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Particularly for hiding sets of SR-IOV devices, specifying them all
individually is rather cumbersome. Therefore, allow function and slot
numbers to be replaced by a wildcard character ('*').

Unfortunately this gets complicated by the in-kernel sscanf()
implementation not being really standard conformant - matching of
plain text tails cannot be checked by the caller (a patch to overcome
this will be sent shortly, and a follow-up patch for simplifying the
code is planned to be sent when that fixed went upstream).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xen-pciback/pci_stub.c |   89 ++++++++++++++++++++++++++++++++++---
 1 file changed, 82 insertions(+), 7 deletions(-)

--- 3.6-rc6/drivers/xen/xen-pciback/pci_stub.c
+++ 3.6-rc6-xen-pciback-wildcard/drivers/xen/xen-pciback/pci_stub.c
@@ -897,17 +897,41 @@ static inline int str_to_slot(const char
 			      int *slot, int *func)
 {
 	int err;
+	char wc = '*';
 
 	err = sscanf(buf, " %x:%x:%x.%x", domain, bus, slot, func);
-	if (err == 4)
+	switch (err) {
+	case 3:
+		*func = -1;
+		err = sscanf(buf, " %x:%x:%x.%c", domain, bus, slot, &wc);
+		break;
+	case 2:
+		*slot = *func = -1;
+		err = sscanf(buf, " %x:%x:*.%c", domain, bus, &wc);
+		if (err >= 2)
+			++err;
+		break;
+	}
+	if (err == 4 && wc == '*')
 		return 0;
 	else if (err < 0)
 		return -EINVAL;
 
 	/* try again without domain */
 	*domain = 0;
+	wc = '*';
 	err = sscanf(buf, " %x:%x.%x", bus, slot, func);
-	if (err == 3)
+	switch (err) {
+	case 2:
+		*func = -1;
+		err = sscanf(buf, " %x:%x.%c", bus, slot, &wc);
+		break;
+	case 1:
+		*slot = *func = -1;
+		err = sscanf(buf, " %x:*.%c", bus, &wc) + 1;
+		break;
+	}
+	if (err == 3 && wc == '*')
 		return 0;
 
 	return -EINVAL;
@@ -930,6 +954,19 @@ static int pcistub_device_id_add(int dom
 {
 	struct pcistub_device_id *pci_dev_id;
 	unsigned long flags;
+	int rc = 0;
+
+	if (slot < 0) {
+		for (slot = 0; !rc && slot < 32; ++slot)
+			rc = pcistub_device_id_add(domain, bus, slot, func);
+		return rc;
+	}
+
+	if (func < 0) {
+		for (func = 0; !rc && func < 8; ++func)
+			rc = pcistub_device_id_add(domain, bus, slot, func);
+		return rc;
+	}
 
 	pci_dev_id = kmalloc(sizeof(*pci_dev_id), GFP_KERNEL);
 	if (!pci_dev_id)
@@ -952,15 +989,15 @@ static int pcistub_device_id_add(int dom
 static int pcistub_device_id_remove(int domain, int bus, int slot, int func)
 {
 	struct pcistub_device_id *pci_dev_id, *t;
-	int devfn = PCI_DEVFN(slot, func);
 	int err = -ENOENT;
 	unsigned long flags;
 
 	spin_lock_irqsave(&device_ids_lock, flags);
 	list_for_each_entry_safe(pci_dev_id, t, &pcistub_device_ids,
 				 slot_list) {
-		if (pci_dev_id->domain == domain
-		    && pci_dev_id->bus == bus && pci_dev_id->devfn == devfn) {
+		if (pci_dev_id->domain == domain && pci_dev_id->bus == bus
+		    && (slot < 0 || PCI_SLOT(pci_dev_id->devfn) == slot)
+		    && (func < 0 || PCI_FUNC(pci_dev_id->devfn) == func)) {
 			/* Don't break; here because it's possible the same
 			 * slot could be in the list more than once
 			 */
@@ -1216,6 +1253,10 @@ static ssize_t permissive_add(struct dev
 	err = str_to_slot(buf, &domain, &bus, &slot, &func);
 	if (err)
 		goto out;
+	if (slot < 0 || func < 0) {
+		err = -EINVAL;
+		goto out;
+	}
 	psdev = pcistub_device_find(domain, bus, slot, func);
 	if (!psdev) {
 		err = -ENODEV;
@@ -1297,17 +1338,51 @@ static int __init pcistub_init(void)
 
 	if (pci_devs_to_hide && *pci_devs_to_hide) {
 		do {
+			char wc = '*';
+
 			parsed = 0;
 
 			err = sscanf(pci_devs_to_hide + pos,
 				     " (%x:%x:%x.%x) %n",
 				     &domain, &bus, &slot, &func, &parsed);
-			if (err != 4) {
+			switch (err) {
+			case 3:
+				func = -1;
+				err = sscanf(pci_devs_to_hide + pos,
+					     " (%x:%x:%x.%c) %n",
+					     &domain, &bus, &slot, &wc,
+					     &parsed);
+				break;
+			case 2:
+				slot = func = -1;
+				err = sscanf(pci_devs_to_hide + pos,
+					     " (%x:%x:*.%c) %n",
+					     &domain, &bus, &wc, &parsed) + 1;
+				break;
+			}
+
+			if (err != 4 || wc != '*') {
 				domain = 0;
+				wc = '*';
 				err = sscanf(pci_devs_to_hide + pos,
 					     " (%x:%x.%x) %n",
 					     &bus, &slot, &func, &parsed);
-				if (err != 3)
+				switch (err) {
+				case 2:
+					func = -1;
+					err = sscanf(pci_devs_to_hide + pos,
+						     " (%x:%x.%c) %n",
+						     &bus, &slot, &wc,
+						     &parsed);
+					break;
+				case 1:
+					slot = func = -1;
+					err = sscanf(pci_devs_to_hide + pos,
+						     " (%x:*.%c) %n",
+						     &bus, &wc, &parsed) + 1;
+					break;
+				}
+				if (err != 3 || wc != '*')
 					goto parse_error;
 			}
 


