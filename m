Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab0IZOXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 10:23:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49740 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab0IZOXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 10:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GEn49EtX7samPBZkmSAiTzwB8tfVhuFVaBxKrxh6UUSpoDQUcrVuKKgIJnPaO2Pm6f
         m6WJ2XpCYzPtrvh5Y3ykTIgNI3v2Pz9UD1RaGeT5fmJeMIYuUlI7JhrLiX36ABdBU1H1
         rkLkE2mvJwQPfATNnG67hN2yI8wydfxE548t8=
Date: Sun, 26 Sep 2010 16:25:35 +0200
From: Lutz Ballaschke <vegan.grindcore@googlemail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 1/3] watchdog: add f71862fg support
Message-ID: <20100926142535.GB2150@kreios.titan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Lutz Ballaschke <vegan.grindcore@googlemail.com>

Watchdog support for Fintek F71862fg Super-I/O added.
Two different hardware reset pins of the F71862fg chip can be configured 
by an additional module parameter.

Signed-off-by: Lutz Ballaschke <vegan.grindcore@googlemail.com>
---

 drivers/watchdog/f71808e_wdt.c |   44 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)


diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index 7e5c266..546cef6 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -42,6 +42,11 @@
 #define SIO_REG_DEVID		0x20	/* Device ID (2 bytes) */
 #define SIO_REG_DEVREV		0x22	/* Device revision */
 #define SIO_REG_MANID		0x23	/* Fintek ID (2 bytes) */
+#define SIO_REG_ROM_ADDR_SEL	0x27	/* ROM address select */
+#define SIO_REG_MFUNCT1		0x29	/* Multi function select 1 */
+#define SIO_REG_MFUNCT2		0x2a	/* Multi function select 2 */
+#define SIO_REG_MFUNCT3		0x2b	/* Multi function select 3 */
+#define SIO_REG_MFUNCT4		0x2c	/* Multi function select 4 */
 #define SIO_REG_ENABLE		0x30	/* Logical device enable */
 #define SIO_REG_ADDR		0x60	/* Logical device address (2 bytes) */
 
@@ -70,6 +75,8 @@
 #define WATCHDOG_MAX_TIMEOUT	(60 * 255)
 #define WATCHDOG_PULSE_WIDTH	125	/* 125 ms, default pulse width for
 					   watchdog signal */
+#define WATCHDOG_F71862FG_PIN	63	/* default watchdog reset output
+					   pin number 63 */
 
 static unsigned short force_id;
 module_param(force_id, ushort, 0);
@@ -89,6 +96,12 @@ MODULE_PARM_DESC(pulse_width,
 	"Watchdog signal pulse width. 0(=level), 1 ms, 25 ms, 125 ms or 5000 ms"
 			" (default=" __MODULE_STRING(WATCHDOG_PULSE_WIDTH) ")");
 
+static unsigned int f71862fg_pin = WATCHDOG_F71862FG_PIN;
+module_param(f71862fg_pin, uint, 0);
+MODULE_PARM_DESC(f71862fg_pin,
+	"Watchdog f71862fg reset output pin configuration. Choose pin 56 or 63"
+			" (default=" __MODULE_STRING(WATCHDOG_F71862FG_PIN)")");
+
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0444);
 MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
@@ -282,6 +295,28 @@ exit_unlock:
 	return err;
 }
 
+static int f71862fg_pin_configure(unsigned short ioaddr)
+{
+	/* When ioaddr is non-zero the calling function has to take care of
+	   mutex handling and superio preparation! */
+
+	if (f71862fg_pin == 63) {
+		if (ioaddr) {
+			/* SPI must be disabled first to use this pin! */
+			superio_clear_bit(ioaddr, SIO_REG_ROM_ADDR_SEL, 6);
+			superio_set_bit(ioaddr, SIO_REG_MFUNCT3, 4);
+		}
+	} else if (f71862fg_pin == 56) {
+		if (ioaddr)
+			superio_set_bit(ioaddr, SIO_REG_MFUNCT1, 1);
+	} else {
+		printk(KERN_ERR DRVNAME ": Invalid argument f71862fg_pin=%d\n",
+				f71862fg_pin);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int watchdog_start(void)
 {
 	/* Make sure we don't die as soon as the watchdog is enabled below */
@@ -308,6 +343,12 @@ static int watchdog_start(void)
 		superio_set_bit(watchdog.sioaddr, 0x29, 1);
 		break;
 
+	case f71862fg:
+		err = f71862fg_pin_configure(watchdog.sioaddr);
+		if (err)
+			goto exit_superio;
+		break;
+
 	default:
 		/*
 		 * 'default' label to shut up the compiler and catch
@@ -709,6 +750,9 @@ static int __init f71808e_find(int sioaddr)
 		watchdog.type = f71882fg;
 		break;
 	case SIO_F71862_ID:
+		watchdog.type = f71862fg;
+		err = f71862fg_pin_configure(0); /* validate module parameter */
+		break;
 	case SIO_F71889_ID:
 		/* These have a watchdog, though it isn't implemented (yet). */
 		err = -ENOSYS;
