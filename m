Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2F2R6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:58:49 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:24875 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2F2R6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:58:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1340992727!7238742!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] staging: comedi: das_08: use the 8253 helper functions
Date: Fri, 29 Jun 2012 10:58:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291058.42320.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding the 8254 timer io, use the helper functions
provided by 8253.h.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08.c | 39 ++++++----------------------------
 1 file changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index d0128e0..036953e 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -56,6 +56,7 @@
 #include <linux/delay.h>
 
 #include "8255.h"
+#include "8253.h"
 #include "das08.h"
 
 #define DRV_NAME "das08"
@@ -434,38 +435,13 @@ das08ao_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 static unsigned int i8254_read_channel_low(unsigned int base, int chan)
 {
-	unsigned int msb, lsb;
-
-	/* The following instructions must be in order.
-	   We must avoid other process reading the counter's value in the
-	   middle.
-	   The spin_lock isn't needed since ioctl calls grab the big kernel
-	   lock automatically */
-	/*spin_lock(sp); */
-	outb(chan << 6, base + I8254_CTRL);
-	base += chan;
-	lsb = inb(base);
-	msb = inb(base);
-	/*spin_unlock(sp); */
-
-	return lsb | (msb << 8);
+	return i8254_read(base, 0, chan);
 }
 
 static void i8254_write_channel_low(unsigned int base, int chan,
 				    unsigned int value)
 {
-	unsigned int msb, lsb;
-
-	lsb = value & 0xFF;
-	msb = value >> 8;
-
-	/* write lsb, then msb */
-	base += chan;
-	/* See comments in i8254_read_channel_low */
-	/*spin_lock(sp); */
-	outb(lsb, base);
-	outb(msb, base);
-	/*spin_unlock(sp); */
+	i8254_write(base, 0, chan, value);
 }
 
 static unsigned int i8254_read_channel(struct i8254_struct *st, int channel)
@@ -486,10 +462,10 @@ static void i8254_write_channel(struct i8254_struct *st, int channel,
 static void i8254_set_mode_low(unsigned int base, int channel,
 			       unsigned int mode)
 {
-	outb((channel << 6) | 0x30 | (mode & 0x0F), base + I8254_CTRL);
+	i8254_set_mode(base, 0, channel, mode);
 }
 
-static void i8254_set_mode(struct i8254_struct *st, int channel,
+static void __i8254_set_mode(struct i8254_struct *st, int channel,
 			   unsigned int mode)
 {
 	int chan = st->logic2phys[channel];
@@ -500,8 +476,7 @@ static void i8254_set_mode(struct i8254_struct *st, int channel,
 
 static unsigned int i8254_read_status_low(unsigned int base, int channel)
 {
-	outb(0xE0 | (2 << channel), base + I8254_CTRL);
-	return inb(base + channel);
+	return i8254_status(base, 0, channel);
 }
 
 static unsigned int i8254_read_status(struct i8254_struct *st, int channel)
@@ -550,7 +525,7 @@ static int das08_counter_config(struct comedi_device *dev,
 
 	switch (data[0]) {
 	case INSN_CONFIG_SET_COUNTER_MODE:
-		i8254_set_mode(&devpriv->i8254, chan, data[1]);
+		__i8254_set_mode(&devpriv->i8254, chan, data[1]);
 		break;
 	case INSN_CONFIG_8254_READ_STATUS:
 		data[1] = i8254_read_status(&devpriv->i8254, chan);
-- 
1.7.11

