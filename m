Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0EOVQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:16:31 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41696 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab0EOVQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:16:27 -0400
Date: Sat, 15 May 2010 23:16:21 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Alexey Starikovskiy <astarikovskiy@suse.de>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 11/37] drivers/acpi: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152316030.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/acpi/ec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/acpi/ec.c b/drivers/acpi/ec.c
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1027,10 +1027,9 @@ int __init acpi_ec_ecdt_probe(void)
 		/* Don't trust ECDT, which comes from ASUSTek */
 		if (!EC_FLAGS_VALIDATE_ECDT)
 			goto install;
-		saved_ec = kmalloc(sizeof(struct acpi_ec), GFP_KERNEL);
+		saved_ec = kmemdup(boot_ec, sizeof(struct acpi_ec), GFP_KERNEL);
 		if (!saved_ec)
 			return -ENOMEM;
-		memcpy(saved_ec, boot_ec, sizeof(struct acpi_ec));
 	/* fall through */
 	}
 
