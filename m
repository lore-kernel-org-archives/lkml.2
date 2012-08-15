Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab2HOTtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:36481 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab2HOTt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Wang Zhi <zhi.wang@windriver.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 022/165] USB: EHCI: Do not rely on PORT_SUSPEND to stop USB resuming in ehci_bus_resume().
Date: Wed, 15 Aug 2012 15:46:06 -0400
Message-ID: <1345060109-9187-23-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Zhi <zhi.wang@windriver.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d0f2fb2500b1c5fe4967eb45d8c9bc758d7aef80 upstream.

>From EHCI Spec p.28 HC should clear PORT_SUSPEND when SW clears
PORT_RESUME. In Intel Oaktrail platform, MPH (Multi-Port Host
Controller) core clears PORT_SUSPEND directly when SW sets PORT_RESUME
bit. If we rely on PORT_SUSPEND bit to stop USB resume, we will miss
the action of clearing PORT_RESUME. This will cause unexpected long
resume signal on USB bus.

Signed-off-by: Wang Zhi <zhi.wang@windriver.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-hub.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index ae32f02..d5ff2b0 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -311,7 +311,7 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 	u32			temp;
 	u32			power_okay;
 	int			i;
-	u8			resume_needed = 0;
+	unsigned long		resume_needed = 0;
 
 	if (time_before (jiffies, ehci->next_statechange))
 		msleep(5);
@@ -384,7 +384,7 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 		if (test_bit(i, &ehci->bus_suspended) &&
 				(temp & PORT_SUSPEND)) {
 			temp |= PORT_RESUME;
-			resume_needed = 1;
+			set_bit(i, &resume_needed);
 		}
 		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 	}
@@ -399,8 +399,7 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {
 		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
-		if (test_bit(i, &ehci->bus_suspended) &&
-				(temp & PORT_SUSPEND)) {
+		if (test_bit(i, &resume_needed)) {
 			temp &= ~(PORT_RWC_BITS | PORT_RESUME);
 			ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 			ehci_vdbg (ehci, "resumed port %d\n", i + 1);
-- 
1.7.12.rc2

