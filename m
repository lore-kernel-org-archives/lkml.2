Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2IGQpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:45:47 -0400
Received: from fiji.vyatta.com ([76.74.103.50]:35654 "EHLO fiji.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2IGQpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:45:44 -0400
Message-Id: <20120907163437.912797971@vyatta.com>
User-Agent: quilt/0.60-1
Date: Fri, 07 Sep 2012 09:33:14 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linas Vepstas <linasvepstas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] pci: make pci_error_handlers const
References: <20120907163313.614852012@vyatta.com>
Content-Disposition: inline; filename=pci-errhandler-const.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pic_error_handlers is just a function table make it const.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


---
 drivers/pci/pcie/aer/aerdrv.c      |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c |    8 ++++----
 drivers/pci/pcie/portdrv_pci.c     |   10 +++++-----
 include/linux/pci.h                |    2 +-
 include/linux/pcieport_if.h        |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/pci.h	2012-09-07 09:21:37.154557681 -0700
+++ b/include/linux/pci.h	2012-09-07 09:26:01.739900450 -0700
@@ -596,7 +596,7 @@ struct pci_driver {
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
-	struct pci_error_handlers *err_handler;
+	const struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
 };
--- a/include/linux/pcieport_if.h	2012-09-07 09:21:37.154557681 -0700
+++ b/include/linux/pcieport_if.h	2012-09-07 09:26:01.739900450 -0700
@@ -49,7 +49,7 @@ struct pcie_port_service_driver {
 	int (*resume) (struct pcie_device *dev);
 
 	/* Service Error Recovery Handler */
-	struct pci_error_handlers *err_handler;
+	const struct pci_error_handlers *err_handler;
 
 	/* Link Reset Capability - AER service driver specific */
 	pci_ers_result_t (*reset_link) (struct pci_dev *dev);
--- a/drivers/pci/pcie/aer/aerdrv.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/pci/pcie/aer/aerdrv.c	2012-09-07 09:26:01.739900450 -0700
@@ -48,7 +48,7 @@ static pci_ers_result_t aer_error_detect
 static void aer_error_resume(struct pci_dev *dev);
 static pci_ers_result_t aer_root_reset(struct pci_dev *dev);
 
-static struct pci_error_handlers aer_error_handlers = {
+static const struct pci_error_handlers aer_error_handlers = {
 	.error_detected = aer_error_detected,
 	.resume		= aer_error_resume,
 };
--- a/drivers/pci/pcie/aer/aerdrv_core.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/pci/pcie/aer/aerdrv_core.c	2012-09-07 09:26:01.739900450 -0700
@@ -240,7 +240,7 @@ static bool find_source_device(struct pc
 static int report_error_detected(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote;
-	struct pci_error_handlers *err_handler;
+	const struct pci_error_handlers *err_handler;
 	struct aer_broadcast_data *result_data;
 	result_data = (struct aer_broadcast_data *) data;
 
@@ -274,7 +274,7 @@ static int report_error_detected(struct
 static int report_mmio_enabled(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote;
-	struct pci_error_handlers *err_handler;
+	const struct pci_error_handlers *err_handler;
 	struct aer_broadcast_data *result_data;
 	result_data = (struct aer_broadcast_data *) data;
 
@@ -292,7 +292,7 @@ static int report_mmio_enabled(struct pc
 static int report_slot_reset(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote;
-	struct pci_error_handlers *err_handler;
+	const struct pci_error_handlers *err_handler;
 	struct aer_broadcast_data *result_data;
 	result_data = (struct aer_broadcast_data *) data;
 
@@ -309,7 +309,7 @@ static int report_slot_reset(struct pci_
 
 static int report_resume(struct pci_dev *dev, void *data)
 {
-	struct pci_error_handlers *err_handler;
+	const struct pci_error_handlers *err_handler;
 
 	dev->error_state = pci_channel_io_normal;
 
--- a/drivers/pci/pcie/portdrv_pci.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/pci/pcie/portdrv_pci.c	2012-09-07 09:26:01.739900450 -0700
@@ -371,11 +371,11 @@ static const struct pci_device_id port_p
 };
 MODULE_DEVICE_TABLE(pci, port_pci_ids);
 
-static struct pci_error_handlers pcie_portdrv_err_handler = {
-		.error_detected = pcie_portdrv_error_detected,
-		.mmio_enabled = pcie_portdrv_mmio_enabled,
-		.slot_reset = pcie_portdrv_slot_reset,
-		.resume = pcie_portdrv_err_resume,
+static const struct pci_error_handlers pcie_portdrv_err_handler = {
+	.error_detected = pcie_portdrv_error_detected,
+	.mmio_enabled = pcie_portdrv_mmio_enabled,
+	.slot_reset = pcie_portdrv_slot_reset,
+	.resume = pcie_portdrv_err_resume,
 };
 
 static struct pci_driver pcie_portdriver = {


