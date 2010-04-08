Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab0DHRRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:17:15 -0400
Received: from tex.lwn.net ([70.33.254.29]:46497 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986Ab0DHRQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:16:54 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 05/16] viafb: Determine type of 2D engine and store it in chip_info
Date: Thu,  8 Apr 2010 11:15:35 -0600
Message-Id: <1270746946-12467-6-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1270746946-12467-1-git-send-email-corbet@lwn.net>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@gnumonks.org>

This will help us for the upcoming support for 2D acceleration using
the M1 engine.

[jc: fixed merge conflicts]
Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
---
 drivers/video/via/chip.h |    8 ++++++++
 drivers/video/via/hw.c   |   15 +++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index 474f428..f799e2c 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -122,9 +122,17 @@ struct lvds_chip_information {
 	int i2c_port;
 };
 
+/* The type of 2D engine */
+enum via_2d_engine {
+	VIA_2D_ENG_H2,
+	VIA_2D_ENG_H5,
+	VIA_2D_ENG_M1,
+};
+
 struct chip_information {
 	int gfx_chip_name;
 	int gfx_chip_revision;
+	enum via_2d_engine twod_engine;
 	struct tmds_chip_information tmds_chip_info;
 	struct lvds_chip_information lvds_chip_info;
 	struct lvds_chip_information lvds_chip_info2;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index f2e4bda..963704e 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2034,6 +2034,21 @@ static void init_gfx_chip_info(struct pci_dev *pdev,
 				CX700_REVISION_700;
 		}
 	}
+
+	/* Determine which 2D engine we have */
+	switch (viaparinfo->chip_info->gfx_chip_name) {
+	case UNICHROME_VX800:
+	case UNICHROME_VX855:
+		viaparinfo->chip_info->twod_engine = VIA_2D_ENG_M1;
+		break;
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M900:
+		viaparinfo->chip_info->twod_engine = VIA_2D_ENG_H5;
+		break;
+	default:
+		viaparinfo->chip_info->twod_engine = VIA_2D_ENG_H2;
+		break;
+	}
 }
 
 static void init_tmds_chip_info(void)
-- 
1.7.0.1

