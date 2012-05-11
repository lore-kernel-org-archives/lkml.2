Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161015Ab2EKRIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:08:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:26229 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab2EKRIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:08:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1336756076!5235492!43
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: Add helper macro for comedi pci driver boilerplate
Date: Fri, 11 May 2012 10:07:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205111007.46754.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the module_comedi_pci_driver macro, and the
associated register/unregister functions, which is a
convenience macro for comedi pci driver modules similar
to module_platform_driver. It is intended to be used by
drivers where the init/exit section does nothing but
register/unregister the comedi driver and associated pci
driver. By using this macro it is possible to eliminate
a few lines of boilerplate code per comedi pci driver.

Also, when registering the pci driver check for failure
and unregister the comedi driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 8828609..92a1199 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -310,6 +310,25 @@ int comedi_driver_unregister(struct comedi_driver *);
 	module_driver(__comedi_driver, comedi_driver_register, \
 			comedi_driver_unregister)
 
+struct pci_driver;
+
+int comedi_pci_driver_register(struct comedi_driver *, struct pci_driver *);
+void comedi_pci_driver_unregister(struct comedi_driver *, struct pci_driver *);
+
+/**
+ * module_comedi_pci_driver() - Helper macro for registering a comedi PCI driver
+ * @__comedi_driver: comedi_driver struct
+ * @__pci_driver: pci_driver struct
+ *
+ * Helper macro for comedi PCI drivers which do not do anything special
+ * in module init/exit. This eliminates a lot of boilerplate. Each
+ * module may only use this macro once, and calling it replaces
+ * module_init() and module_exit()
+ */
+#define module_comedi_pci_driver(__comedi_driver, __pci_driver) \
+	module_driver(__comedi_driver, comedi_pci_driver_register, \
+			comedi_pci_driver_unregister, &(__pci_driver))
+
 void init_polling(void);
 void cleanup_polling(void);
 void start_polling(struct comedi_device *);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 49681a1..7071109 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -950,6 +950,34 @@ void comedi_pci_auto_unconfig(struct pci_dev *pcidev)
 }
 EXPORT_SYMBOL_GPL(comedi_pci_auto_unconfig);
 
+int comedi_pci_driver_register(struct comedi_driver *comedi_driver,
+		struct pci_driver *pci_driver)
+{
+	int ret;
+
+	ret = comedi_driver_register(comedi_driver);
+	if (ret < 0)
+		return ret;
+
+	pci_driver->name = comedi_driver->driver_name;
+	ret = pci_register_driver(pci_driver);
+	if (ret < 0) {
+		comedi_driver_unregister(comedi_driver);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(comedi_pci_driver_register);
+
+void comedi_pci_driver_unregister(struct comedi_driver *comedi_driver,
+		struct pci_driver *pci_driver)
+{
+	pci_unregister_driver(pci_driver);
+	comedi_driver_unregister(comedi_driver);
+}
+EXPORT_SYMBOL(comedi_pci_driver_unregister);
+
 static int comedi_old_usb_auto_config(struct usb_interface *intf,
 				      struct comedi_driver *driver)
 {
