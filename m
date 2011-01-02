Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1ABQvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 11:51:55 -0500
Received: from utm.netup.ru ([193.203.36.250]:47410 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1ABQvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 11:51:54 -0500
Message-ID: <4D20AC97.6050303@netup.ru>
Date: Sun, 02 Jan 2011 16:49:27 +0000
From: Abylay Ospan <aospan@netup.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5 v2] Force xc5000 firmware loading for NetUP Dual DVB-T/C
 CI RF card
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c 
b/drivers/media/video/cx23885/cx23885-dvb.c
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

