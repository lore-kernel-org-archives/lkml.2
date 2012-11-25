Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2KYOyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 09:54:25 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:36418 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab2KYOyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 09:54:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, "Svahn, Kai" <kai.svahn@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] platform / ACPI: Attach/detach ACPI PM during probe/remove/shutdown
Date: Sun, 25 Nov 2012 15:58:14 +0100
Message-ID: <6227446.8xPtqi6yHi@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1672179.qgDUs0YdYu@vostro.rjw.lan>
References: <1672179.qgDUs0YdYu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Drivers usually expect that the devices they are supposed to handle
will be operational when their .probe() routines are called, but that
need not be the case on some ACPI-based systems with ACPI-based
device enumeration where the BIOSes don't put devices into D0 by
default.  To work around this problem it is sufficient to change
bus type .probe() routines to ensure that devices will be powered
on before the drivers' .probe() routines run (and their .remove()
and .shutdown() routines accordingly).

Modify platform_drv_probe() to run acpi_dev_pm_attach() for devices
whose ACPI handles are present, so that ACPI power management is used
to change their power states and change their power states to D0
before driver probing.  Analogously, modify platform_drv_remove() and
platform_drv_shutdown() to call acpi_dev_pm_detach() for those
devices, so that they are not subject to ACPI PM any more.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/platform.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux/drivers/base/platform.c
===================================================================
--- linux.orig/drivers/base/platform.c
+++ linux/drivers/base/platform.c
@@ -484,8 +484,16 @@ static int platform_drv_probe(struct dev
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
+	int ret;
 
-	return drv->probe(dev);
+	if (ACPI_HANDLE(_dev))
+		acpi_dev_pm_attach(_dev, true);
+
+	ret = drv->probe(dev);
+	if (ret && ACPI_HANDLE(_dev))
+		acpi_dev_pm_detach(_dev, true);
+
+	return ret;
 }
 
 static int platform_drv_probe_fail(struct device *_dev)
@@ -497,8 +505,13 @@ static int platform_drv_remove(struct de
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
+	int ret;
+
+	ret = drv->remove(dev);
+	if (ACPI_HANDLE(_dev))
+		acpi_dev_pm_detach(_dev, true);
 
-	return drv->remove(dev);
+	return ret;
 }
 
 static void platform_drv_shutdown(struct device *_dev)
@@ -507,6 +520,8 @@ static void platform_drv_shutdown(struct
 	struct platform_device *dev = to_platform_device(_dev);
 
 	drv->shutdown(dev);
+	if (ACPI_HANDLE(_dev))
+		acpi_dev_pm_detach(_dev, true);
 }
 
 /**

