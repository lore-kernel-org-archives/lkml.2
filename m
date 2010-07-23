Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278Ab0GWT7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:59:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43173 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205Ab0GWT7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:59:19 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        Paul Walmsley <paul@pwsan.com>, Sanjeev Premi <premi@ti.com>,
        Ajay Kumar Gupta <ajay.gupta@ti.com>,
        Vikram Pandita <vikram.pandita@ti.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] ARM: omap: move omap_get_config et al. to .init.text
Date: Fri, 23 Jul 2010 21:58:32 +0200
Message-Id: <1279915120-4373-9-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers of these functions live in .init.text, so these can go there,
too.  There they must not be exported anymore, this is no problem though,
as all callers are always built-in.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/plat-omap/common.c             |    6 ++----
 arch/arm/plat-omap/include/plat/board.h |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index 219c01e..3737dae 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -69,17 +69,15 @@ static const void *get_config(u16 tag, size_t len, int skip, size_t *len_out)
 	return kinfo->data;
 }
 
-const void *__omap_get_config(u16 tag, size_t len, int nr)
+const void *__init __omap_get_config(u16 tag, size_t len, int nr)
 {
         return get_config(tag, len, nr, NULL);
 }
-EXPORT_SYMBOL(__omap_get_config);
 
-const void *omap_get_var_config(u16 tag, size_t *len)
+const void *__init omap_get_var_config(u16 tag, size_t *len)
 {
         return get_config(tag, NO_LENGTH_CHECK, 0, len);
 }
-EXPORT_SYMBOL(omap_get_var_config);
 
 /*
  * 32KHz clocksource ... always available, on pretty most chips except
diff --git a/arch/arm/plat-omap/include/plat/board.h b/arch/arm/plat-omap/include/plat/board.h
index 5cd6220..7decf58 100644
--- a/arch/arm/plat-omap/include/plat/board.h
+++ b/arch/arm/plat-omap/include/plat/board.h
@@ -143,14 +143,14 @@ struct omap_board_config_kernel {
 	const void *data;
 };
 
-extern const void *__omap_get_config(u16 tag, size_t len, int nr);
+extern const void *__init __omap_get_config(u16 tag, size_t len, int nr);
 
 #define omap_get_config(tag, type) \
 	((const type *) __omap_get_config((tag), sizeof(type), 0))
 #define omap_get_nr_config(tag, type, nr) \
 	((const type *) __omap_get_config((tag), sizeof(type), (nr)))
 
-extern const void *omap_get_var_config(u16 tag, size_t *len);
+extern const void *__init omap_get_var_config(u16 tag, size_t *len);
 
 extern struct omap_board_config_kernel *omap_board_config;
 extern int omap_board_config_size;
-- 
1.7.1

