Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1IZNPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 09:15:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43264 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1IZNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 09:14:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org
Subject: [PATCH 1/2] 8250: ratelimit LSR safety check engaged warning.
Date: Mon, 26 Sep 2011 09:14:34 -0400
Message-Id: <1317042874-20044-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E807ACF.00E1:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my BIOSTAR TA890FXE the ttyS0 ends up spewing:

[904682.485933] ttyS0: LSR safety check engaged!
[904692.505895] ttyS0: LSR safety check engaged!
[904702.525972] ttyS0: LSR safety check engaged!
[904712.545967] ttyS0: LSR safety check engaged!
[904722.566125] ttyS0: LSR safety check engaged!
..
lets limit it so it won't be the only thing visible
in the ring buffer.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: linux-serial@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/serial/8250.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 7f50999..fc5e9ac 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2081,8 +2081,8 @@ static int serial8250_startup(struct uart_port *port)
 	 */
 	if (!(up->port.flags & UPF_BUGGY_UART) &&
 	    (serial_inp(up, UART_LSR) == 0xff)) {
-		printk(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
-		       serial_index(&up->port));
+		printk_ratelimited(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
+				   serial_index(&up->port));
 		return -ENODEV;
 	}
 
-- 
1.7.4.1

