Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab1GaEhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 00:37:18 -0400
Received: from mail.perches.com ([173.55.12.10]:4395 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1GaEhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 00:37:13 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org
Subject: [PATCH] [media] tda18271: Use printk extension %pV
Date: Sat, 30 Jul 2011 21:37:10 -0700
Message-Id: <7d652e92c65b5cf1495492bd1e56eca6a7c9d2dd.1312087002.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deduplicate printk formats to save ~20KB text.

$ size drivers/media/common/tuners/tda18271*o.*
   text	   data	    bss	    dec	    hex	filename
  10747	     56	   1920	  12723	   31b3	drivers/media/common/tuners/tda18271-common.o.new
  18889	     56	   3112	  22057	   5629	drivers/media/common/tuners/tda18271-common.o.old
  20561	    204	   4264	  25029	   61c5	drivers/media/common/tuners/tda18271-fe.o.new
  31093	    204	   6000	  37297	   91b1	drivers/media/common/tuners/tda18271-fe.o.old
   3681	   6760	    440	  10881	   2a81	drivers/media/common/tuners/tda18271-maps.o.new
   5631	   6760	    680	  13071	   330f	drivers/media/common/tuners/tda18271-maps.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/common/tuners/tda18271-common.c |   32 ++++++++++++++++----
 drivers/media/common/tuners/tda18271-priv.h   |   39 +++++++++++-------------
 2 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
index aae40e5..39c6457 100644
--- a/drivers/media/common/tuners/tda18271-common.c
+++ b/drivers/media/common/tuners/tda18271-common.c
@@ -676,10 +676,28 @@ fail:
 	return ret;
 }
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
+int _tda_printk(struct tda18271_priv *state, const char *level,
+		const char *func, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int rtn;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (state)
+		rtn = printk("%s%s: [%d-%04x|%c] %pV",
+			     level, func, i2c_adapter_id(state->i2c_props.adap),
+			     state->i2c_props.addr,
+			     (state->role == TDA18271_MASTER) ? 'M' : 'S',
+			     &vaf);
+	else
+		rtn = printk("%s%s: %pV", level, func, &vaf);
+
+	va_end(args);
+
+	return rtn;
+}
diff --git a/drivers/media/common/tuners/tda18271-priv.h b/drivers/media/common/tuners/tda18271-priv.h
index 9589ab0..94340f4 100644
--- a/drivers/media/common/tuners/tda18271-priv.h
+++ b/drivers/media/common/tuners/tda18271-priv.h
@@ -136,29 +136,26 @@ extern int tda18271_debug;
 #define DBG_ADV  8
 #define DBG_CAL  16
 
-#define tda_printk(st, kern, fmt, arg...) do {\
-	if (st) { \
-		struct tda18271_priv *state = st; \
-		printk(kern "%s: [%d-%04x|%s] " fmt, __func__, \
-			i2c_adapter_id(state->i2c_props.adap), \
-			state->i2c_props.addr, \
-			(state->role == TDA18271_MASTER) \
-			? "M" : "S", ##arg); \
-	} else \
-		printk(kern "%s: " fmt, __func__, ##arg); \
+__attribute__((format(printf, 4, 5)))
+int _tda_printk(struct tda18271_priv *state, const char *level,
+		const char *func, const char *fmt, ...);
+
+#define tda_printk(st, lvl, fmt, arg...)			\
+	_tda_printk(st, lvl, __func__, fmt, ##arg)
+
+#define tda_dprintk(st, lvl, fmt, arg...)			\
+do {								\
+	if (tda18271_debug & lvl)				\
+		tda_printk(st, KERN_DEBUG, fmt, ##arg);		\
 } while (0)
 
-#define tda_dprintk(st, lvl, fmt, arg...) do {\
-	if (tda18271_debug & lvl) \
-		tda_printk(st, KERN_DEBUG, fmt, ##arg); } while (0)
-
-#define tda_info(fmt, arg...)     printk(KERN_INFO     fmt, ##arg)
-#define tda_warn(fmt, arg...) tda_printk(priv, KERN_WARNING, fmt, ##arg)
-#define tda_err(fmt, arg...)  tda_printk(priv, KERN_ERR,     fmt, ##arg)
-#define tda_dbg(fmt, arg...)  tda_dprintk(priv, DBG_INFO,    fmt, ##arg)
-#define tda_map(fmt, arg...)  tda_dprintk(priv, DBG_MAP,     fmt, ##arg)
-#define tda_reg(fmt, arg...)  tda_dprintk(priv, DBG_REG,     fmt, ##arg)
-#define tda_cal(fmt, arg...)  tda_dprintk(priv, DBG_CAL,     fmt, ##arg)
+#define tda_info(fmt, arg...)	pr_info(fmt, ##arg)
+#define tda_warn(fmt, arg...)	tda_printk(priv, KERN_WARNING, fmt, ##arg)
+#define tda_err(fmt, arg...)	tda_printk(priv, KERN_ERR,     fmt, ##arg)
+#define tda_dbg(fmt, arg...)	tda_dprintk(priv, DBG_INFO,    fmt, ##arg)
+#define tda_map(fmt, arg...)	tda_dprintk(priv, DBG_MAP,     fmt, ##arg)
+#define tda_reg(fmt, arg...)	tda_dprintk(priv, DBG_REG,     fmt, ##arg)
+#define tda_cal(fmt, arg...)	tda_dprintk(priv, DBG_CAL,     fmt, ##arg)
 
 #define tda_fail(ret)							     \
 ({									     \
-- 
1.7.6.131.g99019

