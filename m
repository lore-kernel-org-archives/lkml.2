Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0IFNWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:22:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61420 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0IFNWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CsrcCpWKTXlnka5RxY2Bd4RtI3WFfd48SxVtnjOgqDwhypcb9FVomlpCret16jzzMR
         1FK3ZktGw139mzVCctPPNb8tCVAAIXYKzmQ5GW11zKU8fYixetNdRipQbAOXIsxen6IA
         V5++sLJf/vd+CDDmRp62YyFpeYeTYH8d8Vq2o=
Date: Mon, 6 Sep 2010 15:24:34 +0200
From: Lutz Ballaschke <vegan.grindcore@googlemail.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog: add f71862fg support
Message-ID: <20100906132434.GA17730@kreios.titan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lutz Ballaschke <vegan.grindcore@gmail.com>

Fintek Super-I/O f71862fg watchdog support added to f71808e_wdt driver.
Furthermore the WDIOC_GETTIMELEFT ioctl is added to the driver.

Signed-off-by: Lutz Ballaschke <vegan.grindcore@gmail.com>
---

diff -Nurp linux-2.6.36-rc1-orig/drivers/watchdog/f71808e_wdt.c linux-2.6.36-rc1/drivers/watchdog/f71808e_wdt.c
--- linux-2.6.36-rc1-orig/drivers/watchdog/f71808e_wdt.c	2010-08-16 02:41:37.000000000 +0200
+++ linux-2.6.36-rc1/drivers/watchdog/f71808e_wdt.c	2010-09-04 18:52:14.000000000 +0200
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
 
@@ -52,8 +57,6 @@
 #define SIO_F71882_ID		0x0541	/* Chipset ID */
 #define SIO_F71889_ID		0x0723	/* Chipset ID */
 
-#define	F71882FG_REG_START		0x01
-
 #define F71808FG_REG_WDO_CONF		0xf0
 #define F71808FG_REG_WDT_CONF		0xf5
 #define F71808FG_REG_WD_TIME		0xf6
@@ -252,6 +255,24 @@ exit_unlock:
 	return err;
 }
 
+static int watchdog_time_left(void)
+{
+	int ret = 0;
+
+	mutex_lock(&watchdog.lock);
+	ret = superio_enter(watchdog.sioaddr);
+	if (ret)
+		goto exit_unlock;
+
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+	ret = (int) superio_inb(watchdog.sioaddr, F71808FG_REG_WD_TIME);
+	superio_exit(watchdog.sioaddr);
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+	return ret;
+}
+
 static int watchdog_keepalive(void)
 {
 	int err = 0;
@@ -299,13 +320,19 @@ static int watchdog_start(void)
 	switch (watchdog.type) {
 	case f71808fg:
 		/* Set pin 21 to GPIO23/WDTRST#, then to WDTRST# */
-		superio_clear_bit(watchdog.sioaddr, 0x2a, 3);
-		superio_clear_bit(watchdog.sioaddr, 0x2b, 3);
+		superio_clear_bit(watchdog.sioaddr, SIO_REG_MFUNCT2, 3);
+		superio_clear_bit(watchdog.sioaddr, SIO_REG_MFUNCT3, 3);
 		break;
 
 	case f71882fg:
 		/* Set pin 56 to WDTRST# */
-		superio_set_bit(watchdog.sioaddr, 0x29, 1);
+		superio_set_bit(watchdog.sioaddr, SIO_REG_MFUNCT1, 1);
+		break;
+
+	case f71862fg:
+		/* Set pin 63 to WDTRST# (SPI must be disabled first!) */
+		superio_clear_bit(watchdog.sioaddr, SIO_REG_ROM_ADDR_SEL, 6);
+		superio_set_bit(watchdog.sioaddr, SIO_REG_MFUNCT3, 4);
 		break;
 
 	default:
@@ -549,6 +576,12 @@ static long watchdog_ioctl(struct file *
 	case WDIOC_GETTIMEOUT:
 		return put_user(watchdog.timeout, uarg.i);
 
+	case WDIOC_GETTIMELEFT:
+		status = watchdog_time_left();
+		if (status < 0)
+			return status;
+		return put_user(status, uarg.i);
+
 	default:
 		return -ENOTTY;
 
@@ -709,6 +742,8 @@ static int __init f71808e_find(int sioad
 		watchdog.type = f71882fg;
 		break;
 	case SIO_F71862_ID:
+		watchdog.type = f71862fg;
+		break;
 	case SIO_F71889_ID:
 		/* These have a watchdog, though it isn't implemented (yet). */
 		err = -ENOSYS;

