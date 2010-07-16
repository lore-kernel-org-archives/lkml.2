Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259Ab0GPLMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:12:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965149Ab0GPLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:11:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alexey Starikovskiy <astarikovskiy@suse.de>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 3/7] ACPI: Register EC io ports in /proc/ioports
Date: Fri, 16 Jul 2010 13:11:33 +0200
Message-Id: <1279278697-3694-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1279278697-3694-1-git-send-email-trenn@suse.de>
References: <1279278697-3694-1-git-send-email-trenn@suse.de>
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

