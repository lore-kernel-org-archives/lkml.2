Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1IWBdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:33:22 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:26469
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754519Ab1IWBdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:33:21 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Timur Tabi <timur@freescale.com>
To: <greg@kroah.com>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] [v2] drivers/tty: don't use the byte channel handle as a parameter in ehv_bytechan.c
Date: Thu, 22 Sep 2011 20:33:13 -0500
Message-ID: <1316741593-24262-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.4.4
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

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 drivers/tty/ehv_bytechan.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index f733718..1595dba 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -282,7 +282,6 @@ static int ehv_bc_console_byte_channel_send(unsigned int handle, const char *s,
 static void ehv_bc_console_write(struct console *co, const char *s,
 				 unsigned int count)
 {
-	unsigned int handle = (uintptr_t)co->data;
 	char s2[EV_BYTE_CHANNEL_MAX_BYTES];
 	unsigned int i, j = 0;
 	char c;
@@ -295,14 +294,14 @@ static void ehv_bc_console_write(struct console *co, const char *s,
 
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
@@ -348,8 +347,6 @@ static int __init ehv_bc_console_init(void)
 			   CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE);
 #endif
 
-	ehv_bc_console.data = (void *)(uintptr_t)stdout_bc;
-
 	/* add_preferred_console() must be called before register_console(),
 	   otherwise it won't work.  However, we don't want to enumerate all the
 	   byte channels here, either, since we only care about one. */
-- 
1.7.4.4


