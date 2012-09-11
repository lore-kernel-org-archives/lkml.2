Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2IKLgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:36:33 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:43407 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759258Ab2IKLer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IhAQUjBAsBNBIQJQImAgJXBhOIFKhokzeBIY8DgRIDlV2TBQ
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505388"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 16/20] Staging: ipack: unregister devices when uninstall the carrier device.
Date: Tue, 11 Sep 2012 13:35:09 +0200
Message-Id: <1347363313-17094-17-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find the IP modules that are plugged to the carrier and unregister them.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 26dc976..c83f015 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -229,8 +229,20 @@ struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
 }
 EXPORT_SYMBOL_GPL(ipack_bus_register);
 
+static int ipack_unregister_bus_member(struct device *dev, void *data)
+{
+	struct ipack_device *idev = to_ipack_dev(dev);
+	struct ipack_bus_device *bus = data;
+
+	if (idev->bus_nr == bus->bus_nr)
+		ipack_device_unregister(idev);
+
+	return 1;
+}
+
 int ipack_bus_unregister(struct ipack_bus_device *bus)
 {
+	bus_for_each_dev(&ipack_bus_type, NULL, bus, ipack_unregister_bus_member);
 	ida_simple_remove(&ipack_ida, bus->bus_nr);
 	kfree(bus);
 	return 0;
-- 
1.7.10.4

