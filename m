Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1ITS1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:27:06 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:46705
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540Ab1ITS1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:27:03 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Timur Tabi <timur@freescale.com>
To: <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, <linux-console@vger.kernel.org>
Subject: [PATCH] drivers/tty: don't use the byte channel handle as a parameter in ehv_bytechan.c
Date: Tue, 20 Sep 2011 13:26:57 -0500
Message-ID: <1316543217-13769-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ePAPR hypervisor byte channel console driver only supports one byte
channel as a console, and the byte channel handle is stored in a global
variable.  It doesn't make any sense to pass that handle as a parameter
to the console functions, since these functions already have access to the
global variable.

This change also fixes this compilation warning on a 64-bit kernel:

  CC      drivers/tty/ehv_bytechan.o
drivers/tty/ehv_bytechan.c: In function 'ehv_bc_console_write':
drivers/tty/ehv_bytechan.c:289:24: warning: cast from pointer to integer of different size
drivers/tty/ehv_bytechan.c: In function 'ehv_bc_console_init':
drivers/tty/ehv_bytechan.c:355:24: warning: cast to pointer from integer of different size

This warning is because the driver is converting the integer byte channel
handle to/from the void* 'data' field of struct console.  Rather than fix
the warning, we just eliminate the code altogether.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 drivers/tty/ehv_bytechan.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index e67f70b..b24e6f7 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -286,7 +286,6 @@ static int ehv_bc_console_byte_channel_send(unsigned int handle, const char *s,
 static void ehv_bc_console_write(struct console *co, const char *s,
 				 unsigned int count)
 {
-	unsigned int handle = (unsigned int)co->data;
 	char s2[EV_BYTE_CHANNEL_MAX_BYTES];
 	unsigned int i, j = 0;
 	char c;
@@ -299,14 +298,14 @@ static void ehv_bc_console_write(struct console *co, const char *s,
 
 		s2[j++] = c;
 		if (j >= (EV_BYTE_CHANNEL_MAX_BYTES - 1)) {
-			if (ehv_bc_console_byte_channel_send(handle, s2, j))
+			if (ehv_bc_console_byte_channel_send(stdout_bc, s2, j))
 				return;
 			j = 0;
 		}
 	}
 
 	if (j)
-		ehv_bc_console_byte_channel_send(handle, s2, j);
+		ehv_bc_console_byte_channel_send(stdout_bc, s2, j);
 }
 
 /*
@@ -352,8 +351,6 @@ static int __init ehv_bc_console_init(void)
 			   CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE);
 #endif
 
-	ehv_bc_console.data = (void *)stdout_bc;
-
 	/* add_preferred_console() must be called before register_console(),
 	   otherwise it won't work.  However, we don't want to enumerate all the
 	   byte channels here, either, since we only care about one. */
-- 
1.7.3.4


