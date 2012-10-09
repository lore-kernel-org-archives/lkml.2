Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2JIUO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:14:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2JIUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:14:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Pavel Machek <pavel@suse.cz>, linux-pcmcia@lists.infradead.org,
        Jochen Friedrich <jochen@scram.de>, stable@vger.kernel.org
Subject: [PATCH v2 6/8] pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops
Date: Tue,  9 Oct 2012 22:13:56 +0200
Message-Id: <1349813638-4617-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QzzISXOVjBuGfD6krTrEAj8c5WNDPtA0uwxYGchQqfD
 LPfXlsE22tEcA0mz0D6qVTM7Pf5pSRo/YmQk30MAb2DpNVmWdF
 umK3b1fosO9g/g7OEeSec4A4pf1712fvWv+Kes0YwKm7UpPzaM
 99Z2m1CvJoIUZIwEeYVQv7Wizbr4Uzc8l7mUvG2t3+b8xrMS8x
 5l0Ae3MT6yDwRDyZl6kaEcXpWbdxYyL8EJSRp5Zjd+OX6XfOVz
 6ZqBB3swL8KfOjbnWlvyyVkuZD42A4Zf8nc9SYv0EgA2AmkF0v
 M9FiS01e95rK9XExlJJ5rx5uusyuluKw4rHEikWzGNXGSj7syh
 tXYQOkiEbyUj74R7gnx7tpmwJBm8SB4OnkbOox5eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sharpsl_pcmcia_ops structure gets passed into
sa11xx_drv_pcmcia_probe, where it gets accessed at run-time,
unlike all other pcmcia drivers that pass their structures
into platform_device_add_data, which makes a copy.

This means the gcc warning is valid and the structure
must not be marked as __initdata.

Without this patch, building collie_defconfig results in:

drivers/pcmcia/pxa2xx_sharpsl.c:22:31: fatal error: mach-pxa/hardware.h: No such file or directory
compilation terminated.
make[3]: *** [drivers/pcmcia/pxa2xx_sharpsl.o] Error 1
make[2]: *** [drivers/pcmcia] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Pavel Machek <pavel@suse.cz>
Cc: linux-pcmcia@lists.infradead.org
Cc: Jochen Friedrich <jochen@scram.de>
Cc: stable@vger.kernel.org
---
 drivers/pcmcia/pxa2xx_sharpsl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pcmcia/pxa2xx_sharpsl.c b/drivers/pcmcia/pxa2xx_sharpsl.c
index b066273..7dd879c 100644
--- a/drivers/pcmcia/pxa2xx_sharpsl.c
+++ b/drivers/pcmcia/pxa2xx_sharpsl.c
@@ -194,7 +194,7 @@ static void sharpsl_pcmcia_socket_suspend(struct soc_pcmcia_socket *skt)
 	sharpsl_pcmcia_init_reset(skt);
 }
 
-static struct pcmcia_low_level sharpsl_pcmcia_ops __initdata = {
+static struct pcmcia_low_level sharpsl_pcmcia_ops = {
 	.owner                  = THIS_MODULE,
 	.hw_init                = sharpsl_pcmcia_hw_init,
 	.socket_state           = sharpsl_pcmcia_socket_state,
-- 
1.7.10

