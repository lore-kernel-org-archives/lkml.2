Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1AYUts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:49:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58419 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1AYUtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:49:45 -0500
Message-ID: <4d3f3766.857a0e0a.122c.478f@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Tue, 25 Jan 2011 22:06:00 +0200
Subject: [PATCH 7/9 v3] cx23885: implement num_fds_portb, num_fds_portc parameters for cx23885_board structure.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for multifrontend support.
NetUP Dual DVB-T/C CI RF card has frontends connected to port B & C
Each frontend has two switchable cores - DVB-T & DVB-C

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/cx23885-cards.c |    2 ++
 drivers/media/video/cx23885/cx23885-core.c  |    6 ++++++
 drivers/media/video/cx23885/cx23885.h       |    1 +
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index fb2045a..ea88722 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -344,6 +344,8 @@ struct cx23885_board cx23885_boards[] = {
 		.porta		= CX23885_ANALOG_VIDEO,
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
+		.num_fds_portb	= 2,
+		.num_fds_portc	= 2,
 		.tuner_type	= TUNER_XC5000,
 		.tuner_addr	= 0x64,
 		.input          = { {
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index d621d76..d778b1a 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1005,6 +1005,9 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	}
 
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_DVB) {
+		if (cx23885_boards[dev->board].num_fds_portb)
+			dev->ts1.num_frontends =
+				cx23885_boards[dev->board].num_fds_portb;
 		if (cx23885_dvb_register(&dev->ts1) < 0) {
 			printk(KERN_ERR "%s() Failed to register dvb adapters on VID_B\n",
 			       __func__);
@@ -1019,6 +1022,9 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	}
 
 	if (cx23885_boards[dev->board].portc == CX23885_MPEG_DVB) {
+		if (cx23885_boards[dev->board].num_fds_portc)
+			dev->ts2.num_frontends =
+				cx23885_boards[dev->board].num_fds_portc;
 		if (cx23885_dvb_register(&dev->ts2) < 0) {
 			printk(KERN_ERR
 				"%s() Failed to register dvb on VID_C\n",
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index d8c76b0..8db2797 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -205,6 +205,7 @@ typedef enum {
 struct cx23885_board {
 	char                    *name;
 	port_t			porta, portb, portc;
+	int		num_fds_portb, num_fds_portc;
 	unsigned int		tuner_type;
 	unsigned int		radio_type;
 	unsigned char		tuner_addr;
-- 
1.7.1

