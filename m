Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1AAJbC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 04:31:02 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45947 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1AAJbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 04:31:00 -0500
Message-ID: <4d1ef452.cc7e0e0a.6410.0b4b@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Fri, 31 Dec 2010 13:37:00 +0200
Subject: [PATCH 07/18] cx23885: implement num_fds_portb, num_fds_portc parameters for cx23885_board structure.
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
 drivers/media/video/cx23885/cx23885-core.c  |    4 ++++
 drivers/media/video/cx23885/cx23885.h       |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 7de6379..461413a 100644
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
index a5998dd..307eaf4 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1011,6 +1011,8 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	}
 
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_DVB) {
+		if (cx23885_boards[dev->board].num_fds_portb)
+			dev->ts1.num_frontends = cx23885_boards[dev->board].num_fds_portb;
 		if (cx23885_dvb_register(&dev->ts1) < 0) {
 			printk(KERN_ERR "%s() Failed to register dvb adapters on VID_B\n",
 			       __func__);
@@ -1025,6 +1027,8 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	}
 
 	if (cx23885_boards[dev->board].portc == CX23885_MPEG_DVB) {
+		if (cx23885_boards[dev->board].num_fds_portc)
+			dev->ts2.num_frontends = cx23885_boards[dev->board].num_fds_portc;
 		if (cx23885_dvb_register(&dev->ts2) < 0) {
 			printk(KERN_ERR
 				"%s() Failed to register dvb on VID_C\n",
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index d43f80b..e678667 100644
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

