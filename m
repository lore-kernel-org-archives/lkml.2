Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0GAPDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:03:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:50886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab0GAPCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:02:54 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       Thomas Renninger <trenn@suse.de>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 3/6] ACPI: Register EC io ports in /proc/ioports
Date: Thu,  1 Jul 2010 17:02:47 +0200
Message-Id: <1277996570-2686-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1277996570-2686-1-git-send-email-trenn@suse.de>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Formerly these have been exposed through /proc/..
Better register them where all IO ports should get registered
and scream loud if someone else claims to use them.

EC data and command port typically should show up like this
then:
...
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC command
  0070-0071 : rtc0
...

Signed-off-by: Thomas Renninger <trenn@suse.de>

CC: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
CC: linux-acpi@vger.kernel.org
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: platform-driver-x86@vger.kernel.org

Index: linux-2.6.34-master/drivers/acpi/ec.c
===================================================================
---
 drivers/acpi/ec.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 4b6759f..f95fa9f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -927,10 +927,18 @@ ec_parse_io_ports(struct acpi_resource *resource, void *context)
 	 * the second address region returned is the status/command
 	 * port.
 	 */
-	if (ec->data_addr == 0)
+	if (ec->data_addr == 0) {
 		ec->data_addr = resource->data.io.minimum;
-	else if (ec->command_addr == 0)
+		WARN(!request_region(ec->data_addr, 1, "EC data"),
+		     "Could not request EC data io port %lu",
+		     ec->data_addr);
+	}
+	else if (ec->command_addr == 0) {
 		ec->command_addr = resource->data.io.minimum;
+		WARN(!request_region(ec->command_addr, 1, "EC command"),
+		     "Could not request EC command io port %lu",
+		     ec->command_addr);
+	}
 	else
 		return AE_CTRL_TERMINATE;
 
-- 
1.6.3

