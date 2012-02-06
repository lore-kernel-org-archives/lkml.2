Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2BFQR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:17:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50966 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2BFQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:17:25 -0500
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com,
        Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] ACPI: ec: Do request_region outside WARN()
Date: Mon,  6 Feb 2012 08:17:08 -0800
Message-Id: <1328545032-21373-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN() is not supposed to have side effects, so move the request_regions
outside.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/acpi/ec.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index b19a18d..3268dcf 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -812,10 +812,10 @@ static int acpi_ec_add(struct acpi_device *device)
 		first_ec = ec;
 	device->driver_data = ec;
 
-	WARN(!request_region(ec->data_addr, 1, "EC data"),
-	     "Could not request EC data io port 0x%lx", ec->data_addr);
-	WARN(!request_region(ec->command_addr, 1, "EC cmd"),
-	     "Could not request EC cmd io port 0x%lx", ec->command_addr);
+	ret = !!request_region(ec->data_addr, 1, "EC data");
+	WARN(!ret, "Could not request EC data io port 0x%lx", ec->data_addr);
+	ret = !!request_region(ec->command_addr, 1, "EC cmd");
+	WARN(!ret, "Could not request EC cmd io port 0x%lx", ec->command_addr);
 
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
-- 
1.7.7

