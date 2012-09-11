Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2IKLjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:39:07 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:55378 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab2IKLek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBSoaJM3gSGPA4ESA5VdkwU
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505329"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 04/20] Staging: ipack: Obtain supported speeds from ID ROM.
Date: Tue, 11 Sep 2012 13:34:57 +0200
Message-Id: <1347363313-17094-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
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
index af47772..c36ba9e 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -262,15 +262,21 @@ static void ipack_parse_id1(struct ipack_device *dev)
 
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
+	dev->speed_8mhz = !!(flags & 2);
+	dev->speed_32mhz = !!(flags & 4);
 }
 
 static int ipack_device_read_id(struct ipack_device *dev)
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index a133304..89af9e4 100644
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

