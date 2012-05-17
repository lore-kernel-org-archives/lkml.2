Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab2EQBS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 21:18:59 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:52927 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2EQBS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 21:18:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1337217536!6646016!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: Add helper macro for comedi usb driver boilerplate
Date: Wed, 16 May 2012 18:18:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205161818.53052.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the module_comedi_usb_driver macro, and the
associated register/unregister functions, which is a
convenience macro for comedi usb driver modules similar
to module_platform_driver. It is intended to be used by
drivers where the init/exit section does nothing but
register/unregister the comedi driver and associated usb
driver. By using this macro it is possible to eliminate
a few lines of boilerplate code per comedi usb driver.

Also, when registering the usb driver check for failure
and unregister the comedi driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/comedidev.h |   19 +++++++++++++++++++
 drivers/staging/comedi/drivers.c   |   27 +++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 92a1199..f7f023c 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -329,6 +329,25 @@ void comedi_pci_driver_unregister(struct comedi_driver *, struct pci_driver *);
 	module_driver(__comedi_driver, comedi_pci_driver_register, \
 			comedi_pci_driver_unregister, &(__pci_driver))
 
+struct usb_driver;
+
+int comedi_usb_driver_register(struct comedi_driver *, struct usb_driver *);
+void comedi_usb_driver_unregister(struct comedi_driver *, struct usb_driver *);
+
+/**
+ * module_comedi_usb_driver() - Helper macro for registering a comedi USB driver
+ * @__comedi_driver: comedi_driver struct
+ * @__usb_driver: usb_driver struct
+ *
+ * Helper macro for comedi USB drivers which do not do anything special
+ * in module init/exit. This eliminates a lot of boilerplate. Each
+ * module may only use this macro once, and calling it replaces
+ * module_init() and module_exit()
+ */
+#define module_comedi_usb_driver(__comedi_driver, __usb_driver) \
+	module_driver(__comedi_driver, comedi_usb_driver_register, \
+			comedi_usb_driver_unregister, &(__usb_driver))
+
 void init_polling(void);
 void cleanup_polling(void);
 void start_polling(struct comedi_device *);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 3a82950..1c3d638 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -1016,3 +1016,30 @@ void comedi_usb_auto_unconfig(struct usb_interface *intf)
 	comedi_auto_unconfig(&intf->dev);
 }
 EXPORT_SYMBOL_GPL(comedi_usb_auto_unconfig);
+
+int comedi_usb_driver_register(struct comedi_driver *comedi_driver,
+		struct usb_driver *usb_driver)
+{
+	int ret;
+
+	ret = comedi_driver_register(comedi_driver);
+	if (ret < 0)
+		return ret;
+
+	ret = usb_register(usb_driver);
+	if (ret < 0) {
+		comedi_driver_unregister(comedi_driver);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(comedi_usb_driver_register);
+
+void comedi_usb_driver_unregister(struct comedi_driver *comedi_driver,
+		struct usb_driver *usb_driver)
+{
+	usb_deregister(usb_driver);
+	comedi_driver_unregister(comedi_driver);
+}
+EXPORT_SYMBOL_GPL(comedi_usb_driver_unregister);
