Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1LVVjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:39:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1LVVji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:39:38 -0500
From: Eric Miao <eric.miao@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Eric Miao <eric.miao@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] tty: serial: imx: move del_timer_sync() to avoid potential deadlock
Date: Fri, 23 Dec 2011 05:39:27 +0800
Message-Id: <1324589967-25365-1-git-send-email-eric.miao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

del_timer_sync() acquires its own lock and doesn't have to be nested
within the spinlock of sport->port.lock in imx_set_termios(),  which
will cause potential deadlock.  Fix this by moving it outside.

Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Eric Miao <eric.miao@linaro.org>
---
 drivers/tty/serial/imx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 39bbce4..0f4ba21 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -904,6 +904,8 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 			ucr2 |= UCR2_PROE;
 	}
 
+	del_timer_sync(&sport->timer);
+
 	/*
 	 * Ask the core to calculate the divisor for us.
 	 */
@@ -934,8 +936,6 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 			sport->port.ignore_status_mask |= URXD_OVRRUN;
 	}
 
-	del_timer_sync(&sport->timer);
-
 	/*
 	 * Update the per-port timeout.
 	 */
-- 
1.7.5.4

