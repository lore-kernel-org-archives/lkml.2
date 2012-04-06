Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2DFSev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:34:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:29919 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab2DFSet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:34:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127986818"
Subject: [RFC PATCH 6/6] serial/8250_pci: fix suspend/resume vs init/exit
 quirks
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Date: Fri, 06 Apr 2012 11:50:24 -0700
Message-ID: <20120406185010.22088.3244.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e86ff4a6 "serial/8250_pci: init-quirk msi support for kt serial
controller" introduced a regression in suspend/resume by causing msi's
to be enabled twice without an intervening disable.

That patch has since been reverted, but by inspection it seems that
pciserial_suspend_ports() should be invoking .exit() quirks to release
resources acquired during .init().

Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/8250/8250_pci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 024551a..24ea98c 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2814,6 +2814,12 @@ void pciserial_suspend_ports(struct serial_private *priv)
 	for (i = 0; i < priv->nr; i++)
 		if (priv->line[i] >= 0)
 			serial8250_suspend_port(priv->line[i]);
+
+	/*
+	 * Ensure that every init quirk is properly torn down
+	 */
+	if (priv->quirk->exit)
+		priv->quirk->exit(priv->dev);
 }
 EXPORT_SYMBOL_GPL(pciserial_suspend_ports);
 

