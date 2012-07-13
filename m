Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161021Ab2GMLcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 07:32:47 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:63539 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932088Ab2GMLco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 07:32:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAIIGAFBbdWOb/2dsb2JhbABFhWiyN4EHgiEBBSMECwFGECUCJgICVwYThhGCAKhIkwiBII8AgRIDlTqQBoJhgV0
X-IronPort-AV: E=Sophos;i="4.77,579,1336341600"; 
   d="scan'208";a="543096046"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: ipack/devices/ipoctal: initialize the device in probe function
Date: Fri, 13 Jul 2012 13:33:14 +0200
Message-Id: <1342179194-728-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342179194-728-1-git-send-email-siglesias@igalia.com>
References: <1342179194-728-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the device when registering it. Sometimes the user access to it
and the device is in an unknown state, so it could fail.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index a1aae40..fd0e301 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -411,6 +411,20 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	for (i = 0; i < NR_CHANNELS ; i++) {
 		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
 				     CR_DISABLE_RX | CR_DISABLE_TX);
+		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
+				     CR_CMD_RESET_RX);
+		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
+				     CR_CMD_RESET_TX);
+		ipoctal_write_io_reg(ipoctal,
+				     &ipoctal->chan_regs[i].u.w.mr,
+				     MR1_CHRL_8_BITS | MR1_ERROR_CHAR |
+				     MR1_RxINT_RxRDY); /* mr1 */
+		ipoctal_write_io_reg(ipoctal,
+				     &ipoctal->chan_regs[i].u.w.mr,
+				     0); /* mr2 */
+		ipoctal_write_io_reg(ipoctal,
+				     &ipoctal->chan_regs[i].u.w.csr,
+				     TX_CLK_9600  | RX_CLK_9600);
 	}
 
 	for (i = 0; i < IP_OCTAL_NB_BLOCKS; i++) {
-- 
1.7.10.4

