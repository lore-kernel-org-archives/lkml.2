Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2GJHAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:00:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48060 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2GJHAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:00:33 -0400
MIME-Version: 1.0
Date: Tue, 10 Jul 2012 00:00:31 -0700
Message-ID: <CAH5vBdLJqoB7x_r-8USiduK1tYPrfrXzqhtzGmg8U9VdQHEnEg@mail.gmail.com>
Subject: acpi: remove unused LIST_HEAD(acpi_device_list) && more static analysis
From: cheng renquan <crquan@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just came across this file and found this LIST_HEAD(acpi_device_list)
was referred in early days before 2.6.11 but not in use nowadays,
^1da177e drivers/acpi/scan.c (Linus Torvalds          2005-04-16
15:20:36 -0700   31) static LIST_HEAD(acpi_device_list);

it is expanded to this line of referring itself form so gcc won't emit
a warning,
static struct list_head acpi_device_list = { &(acpi_device_list),
&(acpi_device_list) };

If change to this line of just declaration then it could really cause
a gcc warning:
+static struct list_head acpi_device_list;
drivers/acpi/scan.c:31:25: warning: ‘acpi_device_list’ defined but not
used [-Wunused-variable]

Now I'm guessing the kernel code may have more such dead variables,
at least we could do a globally search to see there are more LIST_HEAD
declaration without a 2nd reference; but does anyone have done this before
or know any existing tools / such static analysis approaches?

Thanks,


===

$ git diff HEAD -- drivers/acpi/scan.c
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 85cbfdc..7d26ae0 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -28,7 +28,7 @@ extern struct acpi_device *acpi_root;

 static const char *dummy_hid = "device";

-static LIST_HEAD(acpi_device_list);
 static LIST_HEAD(acpi_bus_id_list);
 DEFINE_MUTEX(acpi_device_lock);
 LIST_HEAD(acpi_wakeup_device_list);


-- 
Cheng Renquan (程任全)
