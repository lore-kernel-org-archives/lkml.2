Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab2JKARF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:17:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57723 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932878Ab2JKAQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:16:58 -0400
X-Sasl-enc: RMU78G9TICaQfP4TmZGyos2Or34IimT1VZCERfU3eATV 1349914617
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vaibhav Bedia <vaibhav.bedia@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [ 128/133] mmc: omap_hsmmc: Pass on the suspend failure to the PM core
Date: Thu, 11 Oct 2012 07:52:34 +0900
Message-Id: <20121010224917.588836187@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Bedia <vaibhav.bedia@ti.com>

commit c4c8eeb4df00aabb641553d6fbcd46f458e56cd9 upstream.

In some cases mmc_suspend_host() is not able to claim the
host and proceed with the suspend process. The core returns
-EBUSY to the host controller driver. Unfortunately, the
host controller driver does not pass on this information
to the PM core and hence the system suspend process continues.

	ret = mmc_suspend_host(host->mmc);
	if (ret) {
		host->suspended = 0;
		if (host->pdata->resume) {
			ret = host->pdata->resume(dev, host->slot_id);

The return status from mmc_suspend_host() is overwritten by return
status from host->pdata->resume. So the original return status is lost.

In these cases the MMC core gets to an unexpected state
during resume and multiple issues related to MMC crop up.
1. Host controller driver starts accessing the device registers
before the clocks are enabled which leads to a prefetch abort.
2. A file copy thread which was launched before suspend gets
stuck due to the host not being reclaimed during resume.

To avoid such problems pass on the -EBUSY status to the PM core
from the host controller driver. With this change, MMC core
suspend might still fail but it does not end up making the
system unusable. Suspend gets aborted and the user can try
suspending the system again.

Signed-off-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
Acked-by: Venkatraman S <svenkatr@ti.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/omap_hsmmc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2102,8 +2102,7 @@ static int omap_hsmmc_suspend(struct dev
 	if (ret) {
 		host->suspended = 0;
 		if (host->pdata->resume) {
-			ret = host->pdata->resume(dev, host->slot_id);
-			if (ret)
+			if (host->pdata->resume(dev, host->slot_id))
 				dev_dbg(dev, "Unmask interrupt failed\n");
 		}
 		goto err;


