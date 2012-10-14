Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2JNTuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:50:16 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2950 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab2JNTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:50:14 -0400
Message-ID: <1350244211.1516.20.camel@x61.thuisdomein>
Subject: [PATCH] staging: lirc_serial: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Oct 2012 21:50:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2012 19:50:12.0230 (UTC) FILETIME=[1F8B4A60:01CDAA45]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building lirc_serial.o triggers this GCC warning:
    drivers/staging/media/lirc/lirc_serial.c: In function '__check_sense':
    drivers/staging/media/lirc/lirc_serial.c:1301:1: warning: return from incompatible pointer type [enabled by default]

This can be trivially fixed by changing the 'sense' parameter from bool
to int. But, to be safe, we also need to make sure 'sense' will only be
-1, 0, or 1. There's no need to document the new values that are now
allowed for the 'sense' parameter, since they're basically useless.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This warning popped up when building v3.6.2 using Fedora 17's default
config (in which, for some reason, the LIRC drivers were enabled going
from v3.5.y to v3.6.y).

1) Compile tested only.

 drivers/staging/media/lirc/lirc_serial.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 97ef670..08cfaf6 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1239,6 +1239,10 @@ static int __init lirc_serial_init_module(void)
 		}
 	}
 
+	/* make sure sense is either -1, 0, or 1 */
+	if (sense != -1)
+		sense = !!sense;
+
 	result = lirc_serial_init();
 	if (result)
 		return result;
@@ -1298,7 +1302,7 @@ MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 module_param(share_irq, bool, S_IRUGO);
 MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
 
-module_param(sense, bool, S_IRUGO);
+module_param(sense, int, S_IRUGO);
 MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit"
 		 " (0 = active high, 1 = active low )");
 
-- 
1.7.11.7

