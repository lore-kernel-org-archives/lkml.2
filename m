Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab1HFANI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:13:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501Ab1HFAM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:15 2011
Message-Id: <20110806000415.334841169@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [37/50] EHCI: only power off port if over-current is active
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

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

---
 drivers/usb/host/ehci-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -760,10 +760,11 @@ static int ehci_hub_control (
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
 


