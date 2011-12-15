Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1LOGCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:02:39 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:46485 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1LOGCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:02:38 -0500
Date: Wed, 14 Dec 2011 23:59:20 -0600
From: David Fries <david@fries.net>
To: video4linux-list@redhat.com
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Istvan Varga <istvan_v@mailbox.hu>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cx88-dvb avoid dangling core->gate_ctrl pointer
Message-ID: <20111215055920.GA3948@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Wed, 14 Dec 2011 23:59:23 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <David@Fries.net>

dvb_register calls videobuf_dvb_register_bus, but if that returns
a failure the module will be unloaded without clearing the
value of core->gate_ctrl which will cause an oops in macros
called from video_open in cx88-video.c

Signed-off-by: David Fries <David@Fries.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Istvan Varga <istvan_v@mailbox.hu>
Cc: Jonathan Nieder <jrnieder@gmail.com>
---
This is with 3.2.0-rc5+, and it only fixes the oops, it doesn't
resolve why cx88-dvb failed to work.  Any ideas?

cx88/2: cx2388x dvb driver version 0.0.9 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
DVB: registering new adapter (cx88[0])
DVB: registering adapter 0 frontend 0 (Oren OR51132 VSB/QAM
Frontend)...
cx88[0]: videobuf_dvb_register_frontend failed (errno = -12)
cx88[0]/2: dvb_register failed (err = -12)
cx88[0]/2: cx8802 probe failed, err = -12


 drivers/media/video/cx88/cx88-dvb.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index cf3d33a..3961498 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -954,6 +954,7 @@ static int dvb_register(struct cx8802_dev *dev)
 	struct cx88_core *core = dev->core;
 	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
 	int mfe_shared = 0; /* bus not shared by default */
+	int res = -EINVAL;
 
 	if (0 != core->i2c_rc) {
 		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
@@ -1566,13 +1567,16 @@ static int dvb_register(struct cx8802_dev *dev)
 	call_all(core, core, s_power, 0);
 
 	/* register everything */
-	return videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
-					 &dev->pci->dev, adapter_nr, mfe_shared, NULL);
+	res = videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
+		&dev->pci->dev, adapter_nr, mfe_shared, NULL);
+	if (res)
+		goto frontend_detach;
+	return res;
 
 frontend_detach:
 	core->gate_ctrl = NULL;
 	videobuf_dvb_dealloc_frontends(&dev->frontends);
-	return -EINVAL;
+	return res;
 }
 
 /* ----------------------------------------------------------- */
-- 
1.7.2.5

