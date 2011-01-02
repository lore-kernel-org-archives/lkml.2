Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1ABQuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 11:50:37 -0500
Received: from utm.netup.ru ([193.203.36.250]:47405 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1ABQuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 11:50:35 -0500
Message-ID: <4D20AC49.3030905@netup.ru>
Date: Sun, 02 Jan 2011 16:48:09 +0000
From: Abylay Ospan <aospan@netup.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5 v2] Fix CI code for NetUP Dual DVB-T/C CI RF card
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CI reset takes several seconds on some CAM,
so there is no need to lock mutex all that time.
Also we need not to preserve CI's reset bits in
CIBUSCTRL register, they are handled automatically by FPGA.
Set it to 0 explicitly in order to not reset wrong CAM.

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
  drivers/media/video/cx23885/altera-ci.c |   14 ++++++++++----
  1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx23885/altera-ci.c 
b/drivers/media/video/cx23885/altera-ci.c
index e2c9fee..aa67a33 100644
--- a/drivers/media/video/cx23885/altera-ci.c
+++ b/drivers/media/video/cx23885/altera-ci.c
@@ -283,7 +283,7 @@ int netup_ci_op_cam(struct dvb_ca_en50221 *en50221, 
int slot,
  	netup_fpga_op_rw(inter, NETUP_CI_ADDR1, ((addr >> 7) & 0x7f), 0);
  	store = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, 0, NETUP_CI_FLG_RD);
  -	store &= 0x3f;
+	store &= 0x0f;
  	store |= ((state->nr << 7) | (flag << 6));
   	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, store, 0);
@@ -340,19 +340,25 @@ int netup_ci_slot_reset(struct dvb_ca_en50221 
*en50221, int slot)
   	ret = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, 0, NETUP_CI_FLG_RD);
  	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL,
-				ret | (1 << (5 - state->nr)), 0);
+				(ret & 0xcf) | (1 << (5 - state->nr)), 0);
+
+	mutex_unlock(&inter->fpga_mutex);
   	for (;;) {
  		mdelay(50);
+
+		mutex_lock(&inter->fpga_mutex);
+
  		ret = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL,
  						0, NETUP_CI_FLG_RD);
+		mutex_unlock(&inter->fpga_mutex);
+
  		if ((ret & (1 << (5 - state->nr))) == 0)
  			break;
  		if (time_after(jiffies, t_out))
  			break;
  	}
  -	mutex_unlock(&inter->fpga_mutex);
   	printk("%s: %d msecs\n", __func__,
  		jiffies_to_msecs(jiffies + msecs_to_jiffies(9999) - t_out));
@@ -381,7 +387,7 @@ int netup_ci_slot_ts_ctl(struct dvb_ca_en50221 
*en50221, int slot)
   	ret = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, 0, NETUP_CI_FLG_RD);
  	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL,
-				ret | (1 << (3 - state->nr)), 0);
+				(ret & 0x0f) | (1 << (3 - state->nr)), 0);
   	mutex_unlock(&inter->fpga_mutex);
  -- 1.7.1

