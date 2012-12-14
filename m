Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2LNXCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:02:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:40433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab2LNXB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:01:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tetsuyuki Kobayashi <koba@kmckk.co.jp>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Ball <cjb@laptop.org>
Subject: [ 03/37] mmc: sh-mmcif: avoid oops on spurious interrupts (second try)
Date: Fri, 14 Dec 2012 15:00:40 -0800
Message-Id: <20121214222253.564494508@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sh_mmcif.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1104,7 +1104,6 @@ static irqreturn_t sh_mmcif_irqt(int irq
 {
 	struct sh_mmcif_host *host = dev_id;
 	struct mmc_request *mrq = host->mrq;
-	struct mmc_data *data = mrq->data;
 
 	cancel_delayed_work_sync(&host->timeout_work);
 
@@ -1152,13 +1151,14 @@ static irqreturn_t sh_mmcif_irqt(int irq
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


