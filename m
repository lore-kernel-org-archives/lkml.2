Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0EJPax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:30:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49639 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab0EJPav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:30:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH v2] i2c-bfin-twi: handle faulty slave devices better
Date: Mon, 10 May 2010 11:33:44 -0400
Message-Id: <1273505624-30920-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273403087-3326-1-git-send-email-vapier@gentoo.org>
References: <1273403087-3326-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Faulty slave devices might drive SDA low after a transfer finishes.  So,
when this scenario is detected, have the master generate up to 9 extra
clocks until the SDA is properly released.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- fix typo in comment pointed out by Ben
	- use 9 clocks rather than 8 to cover a possible NACK pointed out by Michael

 drivers/i2c/busses/i2c-bfin-twi.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index fb26e5c..1ee9d5a 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -20,6 +20,7 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/delay.h>
 
 #include <asm/blackfin.h>
 #include <asm/portmux.h>
@@ -159,6 +160,27 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 		if (mast_stat & BUFWRERR)
 			dev_dbg(&iface->adap.dev, "Buffer Write Error\n");
 
+		/* Faulty slave devices, may drive SDA low after a transfer
+		 * finishes. To release the bus this code generates up to 9
+		 * extra clocks until SDA is released.
+		 */
+
+		if (read_MASTER_STAT(iface) & SDASEN) {
+			int cnt = 9;
+			do {
+				write_MASTER_CTL(iface, SCLOVR);
+				udelay(6);
+				write_MASTER_CTL(iface, 0);
+				udelay(6);
+			} while ((read_MASTER_STAT(iface) & SDASEN) && cnt--);
+
+			write_MASTER_CTL(iface, SDAOVR | SCLOVR);
+			udelay(6);
+			write_MASTER_CTL(iface, SDAOVR);
+			udelay(6);
+			write_MASTER_CTL(iface, 0);
+		}
+
 		/* If it is a quick transfer, only address without data,
 		 * not an err, return 1.
 		 */
-- 
1.7.1

