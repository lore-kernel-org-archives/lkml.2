Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2BEW0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:11 -0500
Received: from 1wt.eu ([62.212.114.60]:61796 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2BEW0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:05 -0500
Message-Id: <20120205220949.833935474@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 09/91] mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 7 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/mmc/host/sdhci.c
===================================================================
--- longterm-2.6.27.orig/drivers/mmc/host/sdhci.c	2012-02-05 22:34:36.053916156 +0100
+++ longterm-2.6.27/drivers/mmc/host/sdhci.c	2012-02-05 22:34:36.192916064 +0100
@@ -1165,6 +1165,13 @@
 
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


