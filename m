Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab0JOSYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 14:24:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:11842 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab0JOSYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 14:24:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,337,1283756400"; 
   d="scan'208";a="667862406"
Date: Fri, 15 Oct 2010 11:24:14 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, lud <linux-usb@vger.kernel.org>,
        Andiry Xu <andiry.xu@amd.com>, Dong Nguyen <dong.nguyen@amd.com>,
        Libin Yang <libin.yang@amd.com>
Subject: [PATCH] xhci: Fix compile error when CONFIG_PM=n
Message-ID: <20101015182414.GA12349@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015181656.GA6473@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this error when CONFIG_PM is not enabled:

drivers/usb/host/xhci.c:675: error: implicit declaration of function 'usb_root_hub_lost_power'

Wrap xhci_suspend() and xhci_resume() into an ifdef CONFIG_PM, along with
the functions that only they call -- xhci_save_registers() and
xhci_restore_registers().

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 33d0034..9dc5be5 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -551,6 +551,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		    xhci_readl(xhci, &xhci->op_regs->status));
 }
 
+#ifdef CONFIG_PM
 static void xhci_save_registers(struct xhci_hcd *xhci)
 {
 	xhci->s3.command = xhci_readl(xhci, &xhci->op_regs->command);
@@ -761,6 +762,13 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	return 0;
 }
 
+#else
+
+#define	xhci_suspend	NULL
+#define	xhci_resume	NULL
+
+#endif	/* CONFIG_PM */
+
 /*-------------------------------------------------------------------------*/
 
 /**
-- 
1.6.3.3

