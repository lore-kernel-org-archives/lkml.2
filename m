Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1EFARz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:17:55 -0400
Received: from kroah.org ([198.145.64.141]:32867 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab1EFANZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:09 2011
Message-Id: <20110506001209.055756635@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Ball <cjb@laptop.org>
Subject: [patch 18/38] mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1334,6 +1334,13 @@ static void sdhci_tasklet_finish(unsigne
 
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


