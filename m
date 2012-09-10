Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2IJIvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:51:01 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:45294 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2IJIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBSoFZI7gSGPFoESA5VdkwU
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262492"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 04/20] Staging: ipack: Obtain supported speeds from ID ROM.
Date: Mon, 10 Sep 2012 10:51:42 +0200
Message-Id: <1347267118-9580-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |    6 ++++++
 drivers/staging/ipack/ipack.h |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index b3736c0..521ff55 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -261,15 +261,21 @@ static void ipack_parse_id1(struct ipack_device *dev)
 
 	dev->id_vendor = id[4];
 	dev->id_device = id[5];
+	dev->speed_8mhz = 1;
+	dev->speed_32mhz = (id[7] == 'H');
 }
 
 static void ipack_parse_id2(struct ipack_device *dev)
 {
 	__be16 *id = (__be16 *) dev->id;
+	u16 flags;
 
 	dev->id_vendor = ((be16_to_cpu(id[3]) & 0xff) << 16)
 			 + be16_to_cpu(id[4]);
 	dev->id_device = be16_to_cpu(id[5]);
+	flags = be16_to_cpu(id[10]);
+	dev->speed_8mhz = ((flags & 2) != 0);
+	dev->speed_32mhz = ((flags & 4) != 0);
 }
 
 static int ipack_device_read_id(struct ipack_device *dev)
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 0526613..cb77494 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -79,6 +79,8 @@ struct ipack_device {
 	u32			 id_vendor;
 	u32			 id_device;
 	u8			 id_format;
+	unsigned int		 speed_8mhz:1;
+	unsigned int		 speed_32mhz:1;
 };
 
 /**
-- 
1.7.10.4

