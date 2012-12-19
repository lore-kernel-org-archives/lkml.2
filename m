Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2LTGmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:42:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:32402 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab2LTGl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:41:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="183093657"
Subject: [PATCH] n_gsm.c: add tx_lock in gsm_send
From: Xiao Jin <jin.xiao@intel.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com, sboyd@codeaurora.org
Cc: vincentx.pillet@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Dec 2012 13:16:10 +0800
Message-ID: <1355894170.9600.94.camel@xiaojin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaojin <jin.xiao@intel.com>
Date: Wed, 19 Dec 2012 11:53:43 +0800
Subject: [PATCH] n_gsm.c: add tx_lock in gsm_send

All the call to gsm->output should be in the tx_lock,
that could avoid potential race from MUX level. But
we have no tx_lock in gsm_send.

This patch is to add tx_lock in gsm_send.

Signed-off-by: xiaojin <jin.xiao@intel.com>
---
 drivers/tty/n_gsm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index dcc0430..4572117 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -573,6 +573,7 @@ static void gsm_send(struct gsm_mux *gsm, int addr,
int cr, int control)
 	int len;
 	u8 cbuf[10];
 	u8 ibuf[3];
+	unsigned long flags;
 
 	switch (gsm->encoding) {
 	case 0:
@@ -602,7 +603,9 @@ static void gsm_send(struct gsm_mux *gsm, int addr,
int cr, int control)
 		WARN_ON(1);
 		return;
 	}
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	gsm->output(gsm, cbuf, len);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 	gsm_print_packet("-->", addr, cr, control, NULL, 0);
 }
 
-- 
1.7.1



