Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935160Ab1KJE7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:59:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934805Ab1KJD36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:16 2011
Message-Id: <20111109212716.222301881@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clifton Barnes <cabarnes@indesign-llc.com>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [155/262] drivers/power/ds2780_battery.c: add a nolock function to w1 interface
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clifton Barnes <cabarnes@indesign-llc.com>

commit 9fe678fa2feb4aaac0b4220de63e1b7f8ccebae6 upstream.

Adds a nolock function to the w1 interface to avoid locking the
mutex if needed.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/w1/slaves/w1_ds2780.c |   48 ++++++++++++++++++++++++++++++------------
 drivers/w1/slaves/w1_ds2780.h |    2 +
 2 files changed, 37 insertions(+), 13 deletions(-)

--- a/drivers/w1/slaves/w1_ds2780.c
+++ b/drivers/w1/slaves/w1_ds2780.c
@@ -26,20 +26,14 @@
 #include "../w1_family.h"
 #include "w1_ds2780.h"
 
-int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
-			int io)
+static int w1_ds2780_do_io(struct device *dev, char *buf, int addr,
+			size_t count, int io)
 {
 	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
 
-	if (!dev)
-		return -ENODEV;
-
-	mutex_lock(&sl->master->mutex);
+	if (addr > DS2780_DATA_SIZE || addr < 0)
+		return 0;
 
-	if (addr > DS2780_DATA_SIZE || addr < 0) {
-		count = 0;
-		goto out;
-	}
 	count = min_t(int, count, DS2780_DATA_SIZE - addr);
 
 	if (w1_reset_select_slave(sl) == 0) {
@@ -47,7 +41,6 @@ int w1_ds2780_io(struct device *dev, cha
 			w1_write_8(sl->master, W1_DS2780_WRITE_DATA);
 			w1_write_8(sl->master, addr);
 			w1_write_block(sl->master, buf, count);
-			/* XXX w1_write_block returns void, not n_written */
 		} else {
 			w1_write_8(sl->master, W1_DS2780_READ_DATA);
 			w1_write_8(sl->master, addr);
@@ -55,13 +48,42 @@ int w1_ds2780_io(struct device *dev, cha
 		}
 	}
 
-out:
+	return count;
+}
+
+int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&sl->master->mutex);
+
+	ret = w1_ds2780_do_io(dev, buf, addr, count, io);
+
 	mutex_unlock(&sl->master->mutex);
 
-	return count;
+	return ret;
 }
 EXPORT_SYMBOL(w1_ds2780_io);
 
+int w1_ds2780_io_nolock(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	ret = w1_ds2780_do_io(dev, buf, addr, count, io);
+
+	return ret;
+}
+EXPORT_SYMBOL(w1_ds2780_io_nolock);
+
 int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
 {
 	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
--- a/drivers/w1/slaves/w1_ds2780.h
+++ b/drivers/w1/slaves/w1_ds2780.h
@@ -124,6 +124,8 @@
 
 extern int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
 			int io);
+extern int w1_ds2780_io_nolock(struct device *dev, char *buf, int addr,
+			size_t count, int io);
 extern int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd);
 
 #endif /* !_W1_DS2780_H */


