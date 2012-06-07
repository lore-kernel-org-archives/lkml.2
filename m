Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab2FGIZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:25:33 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:34390 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517Ab2FGIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:25:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAPdk0E9bdWOb/2dsb2JhbABFhU6uToEHghkBBSMECwFGECUCJgICVwcSiA+mFJJlgSOOcIESA5UdiSOGV4Ji
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="923788911"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: gregkh@linuxfoundation.org, siglesias@igalia.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 5/9] Staging: ipack/bridges/tpci200: remove gotos in tpci200_install()
Date: Thu,  7 Jun 2012 10:24:54 +0200
Message-Id: <1339057498-5256-5-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the gotos when handling error conditions, as the code gets clearer
and the gotos are not really avoiding code replication.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 29c91d6..51448c7 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -776,23 +776,18 @@ static int tpci200_install(struct tpci200_board *tpci200)
 
 	tpci200->slots = kzalloc(
 		TPCI200_NB_SLOT * sizeof(struct tpci200_slot), GFP_KERNEL);
-	if (tpci200->slots == NULL) {
-		res = -ENOMEM;
-		goto out_err;
-	}
+	if (tpci200->slots == NULL)
+		return -ENOMEM;
 
 	res = tpci200_register(tpci200);
-	if (res)
-		goto out_free;
+	if (res) {
+		kfree(tpci200->slots);
+		tpci200->slots = NULL;
+		return res;
+	}
 
 	mutex_init(&tpci200->mutex);
 	return 0;
-
-out_free:
-	kfree(tpci200->slots);
-	tpci200->slots = NULL;
-out_err:
-	return res;
 }
 
 static int tpci200_pciprobe(struct pci_dev *pdev,
-- 
1.7.9.5

