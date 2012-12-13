Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab2LMOeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:34:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab2LMOKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Chris Ball <cjb@laptop.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 158/241] mmc: sh-mmcif: avoid oops on spurious interrupts (second try)
Date: Thu, 13 Dec 2012 11:58:43 -0200
Message-Id: <1355407206-17100-159-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 91ab252ac5a5c3461dd6910797611e9172626aed upstream.

On some systems, e.g., kzm9g, MMCIF interfaces can produce spurious
interrupts without any active request. To prevent the Oops, that results
in such cases, don't dereference the mmc request pointer until we make
sure, that we are indeed processing such a request.

Reported-by: Tetsuyuki Kobayashi <koba@kmckk.co.jp>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Tetsuyuki Kobayashi <koba@kmckk.co.jp>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mmc/host/sh_mmcif.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index 724b35e..a5786a8 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1066,7 +1066,6 @@ static irqreturn_t sh_mmcif_irqt(int irq, void *dev_id)
 {
 	struct sh_mmcif_host *host = dev_id;
 	struct mmc_request *mrq = host->mrq;
-	struct mmc_data *data = mrq->data;
 
 	cancel_delayed_work_sync(&host->timeout_work);
 
@@ -1114,13 +1113,14 @@ static irqreturn_t sh_mmcif_irqt(int irq, void *dev_id)
 	case MMCIF_WAIT_FOR_READ_END:
 	case MMCIF_WAIT_FOR_WRITE_END:
 		if (host->sd_error)
-			data->error = sh_mmcif_error_manage(host);
+			mrq->data->error = sh_mmcif_error_manage(host);
 		break;
 	default:
 		BUG();
 	}
 
 	if (host->wait_for != MMCIF_WAIT_FOR_STOP) {
+		struct mmc_data *data = mrq->data;
 		if (!mrq->cmd->error && data && !data->error)
 			data->bytes_xfered =
 				data->blocks * data->blksz;
-- 
1.7.9.5

