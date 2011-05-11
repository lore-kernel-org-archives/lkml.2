Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1EKQAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:00:40 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7932 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692Ab1EKQAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:00:38 -0400
X-IronPort-AV: E=Sophos;i="4.64,353,1301889600"; 
   d="scan'208";a="147751239"
From: Ian Campbell <ian.campbell@citrix.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH] acpiphp: assume device is in state D0 after powering on a slot.
Date: Wed, 11 May 2011 17:00:32 +0100
Message-ID: <1305129632-2646-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110511084354.49eee757@jbarnes-desktop>
References: <20110511084354.49eee757@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices which do not support PCI configuration space based power
management may not otherwise be enabled.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 2f67e9b..a70fa89 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -827,6 +827,13 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	acpiphp_set_hpp_values(bus);
 	acpiphp_set_acpi_region(slot);
 	pci_enable_bridges(bus);
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		/* Assume that newly added devices are powered on already. */
+		if (!dev->is_added)
+			dev->current_state = PCI_D0;
+	}
+
 	pci_bus_add_devices(bus);
 
 	list_for_each_entry(func, &slot->funcs, sibling) {
-- 
1.7.2.5

