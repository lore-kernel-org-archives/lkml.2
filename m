Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0E0QcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:32:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37406 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab0E0QcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:32:20 -0400
Date: Thu, 27 May 2010 18:32:15 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
       platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/11] drivers/platform/x86: Eliminate a NULL pointer
 dereference
In-Reply-To: <201005270921.43049.dmitry.torokhov@gmail.com>
Message-ID: <Pine.LNX.4.64.1005271831520.5422@ask.diku.dk>
References: <Pine.LNX.4.64.1005271436460.5422@ask.diku.dk>
 <201005270921.43049.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Give different error messages if device_enum is NULL or if its type field
has the wrong value.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/platform/x86/sony-laptop.c  |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 1387c5f..a47fd4e 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1196,9 +1196,13 @@ static void sony_nc_rfkill_setup(struct acpi_device *device)
 	}
 
 	device_enum = (union acpi_object *) buffer.pointer;
-	if (!device_enum || device_enum->type != ACPI_TYPE_BUFFER) {
-		printk(KERN_ERR "Invalid SN06 return object 0x%.2x\n",
-				device_enum->type);
+	if (!device_enum) {
+		pr_err("Invalid SN06 return object\n");
+		goto out_no_enum;
+	}
+	if (device_enum->type != ACPI_TYPE_BUFFER) {
+		pr_err("Invalid SN06 return object type 0x%.2x\n",
+		       device_enum->type);
 		goto out_no_enum;
 	}
 
