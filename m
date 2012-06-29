Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2F2SAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:00:13 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:10683 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2F2SAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:00:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1340992806!23686439!5
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] staging: comedi: das_08: remove the cached 8254 'mode'
Date: Fri, 29 Jun 2012 10:59:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291059.55603.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver initially sets all the cached 'mode' values for the
8254 timers to (I8254_MODE0 | I8254_BINARY). It then sets the
timers to that 'mode'. Configuring the counters with the comedi
INSN_CONFIG_SET_COUNTER_MODE updates the 'mode' and then sets
the timers to the 'mode'. The cached value is never read or
used other than for storage.

Just remove the 'mode' usage as it serves no purpose.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 78c3314..c0c93ea 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -435,10 +435,11 @@ das08ao_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 static void i8254_initialize(struct i8254_struct *st)
 {
+	unsigned int mode = I8254_MODE0 | I8254_BINARY;
 	int i;
 
 	for (i = 0; i < 3; ++i)
-		i8254_set_mode(st->iobase, 0, i, st->mode[i]);
+		i8254_set_mode(st->iobase, 0, i, mode);
 }
 
 static int das08_counter_read(struct comedi_device *dev,
@@ -478,7 +479,6 @@ static int das08_counter_config(struct comedi_device *dev,
 
 	switch (data[0]) {
 	case INSN_CONFIG_SET_COUNTER_MODE:
-		st->mode[chan] = data[1];
 		i8254_set_mode(st->iobase, 0, chan, data[1]);
 		break;
 	case INSN_CONFIG_8254_READ_STATUS:
@@ -852,9 +852,6 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		devpriv->i8254.logic2phys[1] = 1;
 		devpriv->i8254.logic2phys[2] = 2;
 		devpriv->i8254.iobase = iobase + thisboard->i8254_offset;
-		devpriv->i8254.mode[0] =
-		    devpriv->i8254.mode[1] =
-		    devpriv->i8254.mode[2] = I8254_MODE0 | I8254_BINARY;
 		i8254_initialize(&devpriv->i8254);
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
-- 
1.7.11

