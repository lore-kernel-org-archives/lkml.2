Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2LTAfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:35:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:39352 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab2LTAfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:35:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,320,1355126400"; 
   d="scan'208";a="259913252"
Subject: [PATCH] n_gsm.c: add tx_lock in gsm_send
From: Xiao Jin <jin.xiao@intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: vincentx.pillet@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Dec 2012 08:38:40 +0800
Message-ID: <1355963920.9600.99.camel@xiaojin>
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



