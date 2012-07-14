Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2GNQoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 12:44:16 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:17419
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060Ab2GNQnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 12:43:19 -0400
X-IronPort-AV: E=Sophos;i="4.77,584,1336341600"; 
   d="scan'208";a="150655454"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Scott Murray <scott@spiteful.org>
Cc: kernel-janitors@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] drivers/pci/hotplug/cpci_hotplug_core.c: ensure a consistent return value in error case
Date: Sat, 14 Jul 2012 18:43:03 +0200
Message-Id: <1342284188-19176-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1342284188-19176-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1342284188-19176-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Typically, the return value desired for the failure of a function with an
integer return value is a negative integer.  In these cases, the return
value is sometimes a negative integer and sometimes 0, due to a subsequent
initialization of the return variable within the loop.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

//<smpl>
@r exists@
identifier ret;
position p;
constant C;
expression e1,e3,e4;
statement S;
@@

ret = -C
... when != ret = e3
    when any
if@p (...) S
... when any
if (\(ret != 0\|ret < 0\|ret > 0\) || ...) { ... return ...; }
... when != ret = e3
    when any
*if@p (...)
{
  ... when != ret = e4
  return ret;
}
//</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/pci/hotplug/cpci_hotplug_core.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index 3fadf2f..2b4c412 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -225,7 +225,7 @@ cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
 	char name[SLOT_NAME_SIZE];
-	int status = -ENOMEM;
+	int status;
 	int i;
 
 	if (!(controller && bus))
@@ -237,18 +237,24 @@ cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
 	 */
 	for (i = first; i <= last; ++i) {
 		slot = kzalloc(sizeof (struct slot), GFP_KERNEL);
-		if (!slot)
+		if (!slot) {
+			status = -ENOMEM;
 			goto error;
+		}
 
 		hotplug_slot =
 			kzalloc(sizeof (struct hotplug_slot), GFP_KERNEL);
-		if (!hotplug_slot)
+		if (!hotplug_slot) {
+			status = -ENOMEM;
 			goto error_slot;
+		}
 		slot->hotplug_slot = hotplug_slot;
 
 		info = kzalloc(sizeof (struct hotplug_slot_info), GFP_KERNEL);
-		if (!info)
+		if (!info) {
+			status = -ENOMEM;
 			goto error_hpslot;
+		}
 		hotplug_slot->info = info;
 
 		slot->bus = bus;

