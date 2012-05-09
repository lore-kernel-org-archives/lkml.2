Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab2EIJYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:24:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2EIJYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:24:37 -0400
From: =?UTF-8?q?Steffen=20K=C3=BChn?= <sk@ammonit.com>
To: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Steffen=20K=C3=BChn?= <sk@ammonit.com>
Subject: [PATCH] mmc: atmel-mci: fix deadlock
Date: Wed,  9 May 2012 11:23:36 +0200
Message-Id: <1336555416-14640-1-git-send-email-sk@ammonit.com>
X-Mailer: git-send-email 1.7.2.5
X-OriginalArrivalTime: 09 May 2012 09:24:23.0295 (UTC) FILETIME=[855E00F0:01CD2DC5]
X-Provags-ID: V02:K0:q75AUeCfGhmrIoaU5a/21ikjnYiBvTJK10PZWbXjo8Q
 kbTkdEUSHq/kCBkWtEaOboQ+jkt2M931TgUiBgAl8CcEm+ZixL
 5ecOrzGog/snztah1i35EC36nSyWCUHTZIME1NA5gPyc0r7rRw
 rj06rQJN6NxhH+DhiKd31d7++ZNf2DQ3Ngw+6IZFpNduJS1XyT
 hbXgQS0SU9B2rRuOPfHUtIBU+hEQshSr7JOUvU4qJPr+APyMnR
 cRq3ANJsh/PVULnqghYdY9ah0paH9UFkQBR70L2sKb7rDOvXoy
 nPHmi87ogawGKcDq/xdpEG7dPYkvpusMK6IOWuVlFN1RuYQ3b8
 jq9yZPaiYNiCyAMcbidlZlGmSOkTn1H+6ZkkhPrbIefkN5Fezh
 ua2qNtY6DFnQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

solves a deadlock problem which appears when a mmc card is
removing and a process is reading from the card at the same time.
---
 drivers/mmc/host/atmel-mci.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e94476b..effdc36 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1499,8 +1499,10 @@ static void atmci_tasklet_func(unsigned long priv)
			}

			if (!atmci_test_and_clear_pending(host,
-						EVENT_XFER_COMPLETE))
+						EVENT_XFER_COMPLETE)) {
+				host->stop_transfer(host);
				break;
+            }

			atmci_set_completed(host, EVENT_XFER_COMPLETE);
			prev_state = state = STATE_DATA_BUSY;
--
1.7.2.5
