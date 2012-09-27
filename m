Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2I0Kg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:36:59 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:33408 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2I0Kg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdAEhAgMVcGE4gJt2+RNQOVaZMU
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447813"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 07/17] Staging: ipack: Provide physical memory regions to IPack devices.
Date: Thu, 27 Sep 2012 12:37:31 +0200
Message-Id: <1348742261-28145-7-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

This will allow us to use the regular ioremop functions.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   22 ++++++++++++++++++++++
 drivers/staging/ipack/ipack.h           |    6 ++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 84e1c27..8428e3b 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -28,6 +28,20 @@ static const u16 tpci200_status_error[] = {
 	TPCI200_D_ERROR,
 };
 
+static const size_t tpci200_space_size[IPACK_SPACE_COUNT] = {
+	[IPACK_IO_SPACE]  = TPCI200_IO_SPACE_SIZE,
+	[IPACK_ID_SPACE]  = TPCI200_ID_SPACE_SIZE,
+	[IPACK_INT_SPACE] = TPCI200_INT_SPACE_SIZE,
+	[IPACK_MEM_SPACE] = TPCI200_MEM8_SPACE_SIZE,
+};
+
+static const size_t tpci200_space_interval[IPACK_SPACE_COUNT] = {
+	[IPACK_IO_SPACE]  = TPCI200_IO_SPACE_INTERVAL,
+	[IPACK_ID_SPACE]  = TPCI200_ID_SPACE_INTERVAL,
+	[IPACK_INT_SPACE] = TPCI200_INT_SPACE_INTERVAL,
+	[IPACK_MEM_SPACE] = TPCI200_MEM8_SPACE_INTERVAL,
+};
+
 static struct tpci200_board *check_slot(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200;
@@ -642,6 +656,7 @@ static void tpci200_release_device(struct ipack_device *dev)
 
 static int tpci200_create_device(struct tpci200_board *tpci200, int i)
 {
+	enum ipack_space space;
 	struct ipack_device *dev =
 		kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
 	if (!dev)
@@ -649,6 +664,13 @@ static int tpci200_create_device(struct tpci200_board *tpci200, int i)
 	dev->slot = i;
 	dev->bus = tpci200->info->ipack_bus;
 	dev->release = tpci200_release_device;
+
+	for (space = 0; space < IPACK_SPACE_COUNT; space++) {
+		dev->region[space].start =
+			tpci200->mod_mem[space]
+			+ tpci200_space_interval[space] * i;
+		dev->region[space].size = tpci200_space_size[space];
+	}
 	return ipack_device_register(dev);
 }
 
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index a842eea..43d152a 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -82,6 +82,7 @@ struct ipack_device {
 	struct ipack_addr_space mem_space;
 	struct device dev;
 	void (*release) (struct ipack_device *dev);
+	struct ipack_region      region[IPACK_SPACE_COUNT];
 	u8                      *id;
 	size_t			 id_avail;
 	u32			 id_vendor;
@@ -195,8 +196,9 @@ void ipack_driver_unregister(struct ipack_driver *edrv);
  *
  *	Register a new IPack device ("module" in IndustryPack jargon). The call
  *	is done by the carrier driver.  The carrier should populate the fields
- *	bus and slot of @dev prior to calling this function.  The rest of the
- *	fields will be allocated and populated during registration.
+ *	bus and slot as well as the region array of @dev prior to calling this
+ *	function.  The rest of the fields will be allocated and populated
+ *	during registration.
  *
  *	Return zero on success or error code on failure.
  */
-- 
1.7.10.4

