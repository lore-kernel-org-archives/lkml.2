Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab0LHBOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:14:38 -0500
Received: from kroah.org ([198.145.64.141]:33730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697Ab0LHBDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:30 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:45 2010
Message-Id: <20101208005745.110140903@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Ball <cjb@laptop.org>
Subject: [237/289] mmc: fix rmmod race for hosts using card-detection polling
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit d9bcbf343ec63e1104b5276195888ee06b4d086f upstream.

MMC hosts that poll for card detection by defining the MMC_CAP_NEEDS_POLL
flag have a race on rmmod, where the delayed work is cancelled without
waiting for completed polling. To prevent this a _sync version of the work
cancellation has to be used.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1514,7 +1514,7 @@ void mmc_stop_host(struct mmc_host *host
 
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
-	cancel_delayed_work(&host->detect);
+	cancel_delayed_work_sync(&host->detect);
 	mmc_flush_scheduled_work();
 
 	/* clear pm flags now and let card drivers set them as needed */


