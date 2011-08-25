Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1HYSHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:07:08 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:25175
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104Ab1HYSHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:07:06 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <greg@kroah.com>, <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Subject: [PATCH] [v2] tty/powerpc: fix build break with ehv_bytechan.c on allyesconfig
Date: Thu, 25 Aug 2011 13:06:57 -0500
Message-ID: <1314295617-2953-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ePAPR hypervisor byte channel driver is supposed to work on all
ePAPR-compliant embedded PowerPC systems, but it had a reference to the MSR_GS
bit, which is available only on Book-E systems.

Also fix a couple integer-to-pointer typecast problems.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 drivers/tty/ehv_bytechan.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index e67f70b..f733718 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -226,10 +226,6 @@ void __init udbg_init_ehv_bc(void)
 	unsigned int rx_count, tx_count;
 	unsigned int ret;
 
-	/* Check if we're running as a guest of a hypervisor */
-	if (!(mfmsr() & MSR_GS))
-		return;
-
 	/* Verify the byte channel handle */
 	ret = ev_byte_channel_poll(CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE,
 				   &rx_count, &tx_count);
@@ -286,7 +282,7 @@ static int ehv_bc_console_byte_channel_send(unsigned int handle, const char *s,
 static void ehv_bc_console_write(struct console *co, const char *s,
 				 unsigned int count)
 {
-	unsigned int handle = (unsigned int)co->data;
+	unsigned int handle = (uintptr_t)co->data;
 	char s2[EV_BYTE_CHANNEL_MAX_BYTES];
 	unsigned int i, j = 0;
 	char c;
@@ -352,7 +348,7 @@ static int __init ehv_bc_console_init(void)
 			   CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE);
 #endif
 
-	ehv_bc_console.data = (void *)stdout_bc;
+	ehv_bc_console.data = (void *)(uintptr_t)stdout_bc;
 
 	/* add_preferred_console() must be called before register_console(),
 	   otherwise it won't work.  However, we don't want to enumerate all the
-- 
1.7.3.4


