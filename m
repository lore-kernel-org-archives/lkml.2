Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0F1GrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:47:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54090 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0F1GrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VUGXI0y2qy0tErz3Zgt2PfsX3AxkFWwQgNbtMNwSXjPKgA49GQ35JwOwK7sAK+NDq9
         wpuqAq7iKNklorBWYeukMtriCGtynb53DefInJt5FKBCfJpF286cYgfSYjWLV/iVEYla
         Fvjz4kxeR+lmMMS9BKFHTFxFiQi1ChtBt+dQc=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Murali Karicheri <mkaricheri@gmail.com>,
       "Nori, Sekhar" <nsekhar@ti.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Alexey Klimov <klimov.linux@gmail.com>,
       Muralidharan Karicheri <m-karicheri2@ti.com>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] davinci: dm365: Added swap between y and c data in isif port.
Date: Mon, 28 Jun 2010 08:47:24 +0200
Message-Id: <1277707645-3438-1-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

    Added the possibility to change the position of y and c
    data in the isif port.
    This patch has been developed against the
    http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
    git tree and tested on bmx board.

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
---
 drivers/media/video/davinci/isif.c |    6 +++++-
 include/media/davinci/isif.h       |    2 ++
 include/media/davinci/vpfe_types.h |    8 ++++++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/isif.c b/drivers/media/video/davinci/isif.c
index 29c29c6..02a8bdb 100644
--- a/drivers/media/video/davinci/isif.c
+++ b/drivers/media/video/davinci/isif.c
@@ -105,6 +105,7 @@ static struct isif_oper_config {
 		.hd_pol = VPFE_PINPOL_POSITIVE,
 		.pix_order = CCDC_PIXORDER_CBYCRY,
 		.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED,
+		.ycswap = YCIN_NOT_SWP,
 	},
 	.bayer = {
 		.pix_fmt = CCDC_PIXFMT_RAW,
@@ -864,6 +865,7 @@ static void isif_setfbaddr(unsigned long addr)
 static int isif_set_hw_if_params(struct vpfe_hw_if_param *params)
 {
 	isif_cfg.if_type = params->if_type;
+	isif_cfg.ycbcr.ycswap = params->ycswap;
 
 	switch (params->if_type) {
 	case VPFE_BT656:
@@ -914,7 +916,9 @@ static int isif_config_ycbcr(void)
 		}
 		modeset |= (VPFE_PINPOL_NEGATIVE << ISIF_VD_POL_SHIFT);
 		regw(3, REC656IF);
-		ccdcfg = ccdcfg | ISIF_DATA_PACK8 | ISIF_YCINSWP_YCBCR;
+		ccdcfg = ccdcfg | ISIF_DATA_PACK8;
+		if (params->ycswap == YCIN_SWP)
+			ccdcfg |= ISIF_YCINSWP_YCBCR;
 		break;
 	case VPFE_BT656_10BIT:
 		if (params->pix_fmt != CCDC_PIXFMT_YCBCR_8BIT) {
diff --git a/include/media/davinci/isif.h b/include/media/davinci/isif.h
index b0b74ad..b123f2c 100644
--- a/include/media/davinci/isif.h
+++ b/include/media/davinci/isif.h
@@ -466,6 +466,8 @@ struct isif_ycbcr_config {
 	enum vpfe_pin_pol hd_pol;
 	/* isif pix order. Only used for ycbcr capture */
 	enum ccdc_pixorder pix_order;
+	/* ccdc data connection. 8 bit ycbcr data bus connection */
+	enum vpfe_data_swap ycswap;
 	/* isif buffer type. Only used for ycbcr capture */
 	enum ccdc_buftype buf_type;
 };
diff --git a/include/media/davinci/vpfe_types.h b/include/media/davinci/vpfe_types.h
index 76fb74b..337c917 100644
--- a/include/media/davinci/vpfe_types.h
+++ b/include/media/davinci/vpfe_types.h
@@ -40,12 +40,20 @@ enum vpfe_hw_if_type {
 	VPFE_BT656_10BIT
 };
 
+/* 8 bit interface can be swapped */
+enum vpfe_data_swap {
+	YCIN_NOT_SWP,
+	YCIN_SWP,
+};
+
 /* interface description */
 struct vpfe_hw_if_param {
 	enum vpfe_hw_if_type if_type;
 	enum vpfe_pin_pol hdpol;
 	enum vpfe_pin_pol vdpol;
+	enum vpfe_data_swap ycswap;
 };
 
+
 #endif
 #endif
-- 
1.7.0.4

