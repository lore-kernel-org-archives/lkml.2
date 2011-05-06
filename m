Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab1EFBAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:00:53 -0400
Received: from kroah.org ([198.145.64.141]:36648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab1EFAYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:08 2011
Message-Id: <20110506002208.192222656@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Ball <cjb@laptop.org>
Subject: [031/143] mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Ball <cjb@laptop.org>

commit 0c9c99a765321104cc5f9c97f949382a9ba4927e upstream.

It seems that under certain circumstances the sdhci_tasklet_finish()
call can be entered with mrq set to NULL, causing the system to crash
with a NULL pointer de-reference.

Seen on S3C6410 system.  Based on a patch by Dimitris Papastamos.

Reported-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1266,6 +1266,13 @@ static void sdhci_tasklet_finish(unsigne
 
 	host = (struct sdhci_host*)param;
 
+        /*
+         * If this tasklet gets rescheduled while running, it will
+         * be run again afterwards but without any active request.
+         */
+	if (!host->mrq)
+		return;
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	del_timer(&host->timer);


