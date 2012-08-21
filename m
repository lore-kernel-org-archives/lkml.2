Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2HUHwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:52:32 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:33597 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab2HUHw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:52:29 -0400
From: Marina Makienko <makienko@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marina Makienko <makienko@ispras.ru>, David Daney <david.daney@cavium.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Roy.Li" <rongqing.li@windriver.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: octeon: Add prevent NAPI from scheduling IN-REPLY-TO:
Date: Tue, 21 Aug 2012 11:48:13 +0400
Message-Id: <1345535293-12800-1-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
In-reply-to: <5032653A.9090403@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are netif_napi_add() and napi_enable() in for_each_possible_cpu
loop in function cvm_oct_rx_initialize(). So it's logical to add
napi_disable() in for_each_possible_cpu loop in function
cvm_oct_rx_shutdown().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
 drivers/staging/octeon/ethernet-rx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 34afc16..e5b62fc 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -558,6 +558,8 @@ void cvm_oct_rx_shutdown(void)
 {
 	int i;
 	/* Shutdown all of the NAPIs */
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
 		netif_napi_del(&cvm_oct_napi[i].napi);
+		napi_disable(&cvm_oct_napi[i].napi);
+	}
 }
-- 
1.7.7

