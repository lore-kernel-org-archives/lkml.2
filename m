Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1AANxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 08:53:34 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59953 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1AANxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 08:53:24 -0500
From: Abylay Ospan <liplianin@tut.by>
Date: Sat, 1 Jan 2011 15:51:46 +0200
Subject: [PATCH 17/18] Force xc5000 firmware loading for NetUP Dual DVB-T/C CI RF card
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101011551.46309.aospan@netup.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two xc5000 tuners connected to same i2c bus.
Experiments shows that situation when one tuner is not initialized
while other is tuned to channel causes TS errors.

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/video/cx23885/cx23885-dvb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 53c2b6d..e17be5a 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -1071,12 +1071,15 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(stv0367ter_attach,
 					&netup_stv0367_config[port->nr -1],
 					&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL)
+		if (fe0->dvb.frontend != NULL) {
 			if (NULL == dvb_attach(xc5000_attach,
 					fe0->dvb.frontend,
 					&i2c_bus->i2c_adap,
 					&netup_xc5000_tunerconfig[port->nr - 1]))
 				goto frontend_detach;
+			/* load xc5000 firmware */
+			fe0->dvb.frontend->ops.tuner_ops.init(fe0->dvb.frontend);
+		}
 		/* MFE frontend 2 */
 		fe1 = videobuf_dvb_get_frontend(&port->frontends, 2);
 		if (fe1 == NULL)
-- 
1.7.1

