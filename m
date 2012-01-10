Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab2AJXCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:02:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934290Ab2AJXCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:02:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:03 2012
Message-Id: <20120110215603.804702931@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [26/49] drivers: hv: Dont OOPS when you cannot init vmbus
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit cf6a2eacbcb2593b5b91d0817915c4f0464bb534 upstream.

The hv vmbus driver was causing an OOPS since it was trying to register drivers
on top of the bus even if initialization of the bus has failed for some
reason (such as the odd chance someone would run a hv enabled kernel in a
non-hv environment).

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hv/vmbus_drv.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -62,6 +62,14 @@ struct hv_device_info {
 	struct hv_dev_port_info outbound;
 };
 
+static int vmbus_exists(void)
+{
+	if (hv_acpi_dev == NULL)
+		return -ENODEV;
+
+	return 0;
+}
+
 
 static void get_channel_info(struct hv_device *device,
 			     struct hv_device_info *info)
@@ -590,6 +598,10 @@ int __vmbus_driver_register(struct hv_dr
 
 	pr_info("registering driver %s\n", hv_driver->name);
 
+	ret = vmbus_exists();
+	if (ret < 0)
+		return ret;
+
 	hv_driver->driver.name = hv_driver->name;
 	hv_driver->driver.owner = owner;
 	hv_driver->driver.mod_name = mod_name;
@@ -614,6 +626,9 @@ void vmbus_driver_unregister(struct hv_d
 {
 	pr_info("unregistering driver %s\n", hv_driver->name);
 
+	if (!vmbus_exists())
+		return;
+
 	driver_unregister(&hv_driver->driver);
 
 }
@@ -776,6 +791,7 @@ static int __init hv_acpi_init(void)
 
 cleanup:
 	acpi_bus_unregister_driver(&vmbus_acpi_driver);
+	hv_acpi_dev = NULL;
 	return ret;
 }
 


