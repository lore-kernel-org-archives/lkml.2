Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965592Ab2EOChs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:37:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53511 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965370Ab2EOCRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 137/179] EHCI: only power off port if over-current is active
Date: Mon, 14 May 2012 22:13:53 -0400
Message-ID: <1337048075-6132-138-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 81463c1d707186adbbe534016cd1249edeab0dac upstream.

MAX4967 USB power supply chip we use on our boards signals over-current when
power is not enabled; once it's enabled, over-current signal returns to normal.
That unfortunately caused the endless stream of "over-current change on port"
messages. The EHCI root hub code reacts on every over-current signal change
with powering off the port -- such change event is generated the moment the
port power is enabled, so once enabled the power is immediately cut off.
I think we should only cut off power when we're seeing the active over-current
signal, so I'm adding such check to that code. I also think that the fact that
we've cut off the port power should be reflected in the result of GetPortStatus
request immediately, hence I'm adding a PORTSCn register readback after write...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 1b2af4d..ae32f02 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -837,10 +837,11 @@ static int ehci_hub_control (
 			 * power switching; they're allowed to just limit the
 			 * current.  khubd will turn the power back on.
 			 */
-			if (HCS_PPC (ehci->hcs_params)){
+			if ((temp & PORT_OC) && HCS_PPC(ehci->hcs_params)) {
 				ehci_writel(ehci,
 					temp & ~(PORT_RWC_BITS | PORT_POWER),
 					status_reg);
+				temp = ehci_readl(ehci, status_reg);
 			}
 		}
 
-- 
1.7.9.6

