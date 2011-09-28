Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1I1Whk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab1I1Whi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:27 2011
Message-Id: <20110928220127.457952576@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wang Zhi <zhi.wang@windriver.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [021/244] USB: EHCI: Do not rely on PORT_SUSPEND to stop USB resuming in ehci_bus_resume().
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wang Zhi <zhi.wang@windriver.com>

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

---
 drivers/usb/host/ehci-hub.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -343,7 +343,7 @@ static int ehci_bus_resume (struct usb_h
 	u32			temp;
 	u32			power_okay;
 	int			i;
-	u8			resume_needed = 0;
+	unsigned long		resume_needed = 0;
 
 	if (time_before (jiffies, ehci->next_statechange))
 		msleep(5);
@@ -416,7 +416,7 @@ static int ehci_bus_resume (struct usb_h
 		if (test_bit(i, &ehci->bus_suspended) &&
 				(temp & PORT_SUSPEND)) {
 			temp |= PORT_RESUME;
-			resume_needed = 1;
+			set_bit(i, &resume_needed);
 		}
 		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 	}
@@ -431,8 +431,7 @@ static int ehci_bus_resume (struct usb_h
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {
 		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
-		if (test_bit(i, &ehci->bus_suspended) &&
-				(temp & PORT_SUSPEND)) {
+		if (test_bit(i, &resume_needed)) {
 			temp &= ~(PORT_RWC_BITS | PORT_RESUME);
 			ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 			ehci_vdbg (ehci, "resumed port %d\n", i + 1);


