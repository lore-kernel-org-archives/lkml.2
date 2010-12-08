Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0LHArf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:35 -0500
Received: from kroah.org ([198.145.64.141]:58435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab0LHArd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:33 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:31 2010
Message-Id: <20101208004431.291222578@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>
Subject: [070/127] USB: EHCI: fix obscure race in ehci_endpoint_disable
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 02e2c51ba3e80acde600721ea784c3ef84da5ea1 upstream.

This patch (as1435) fixes an obscure and unlikely race in ehci-hcd.
When an async URB is unlinked, the corresponding QH is removed from
the async list.  If the QH's endpoint is then disabled while the URB
is being given back, ehci_endpoint_disable() won't find the QH on the
async list, causing it to believe that the QH has been lost.  This
will lead to a memory leak at best and quite possibly to an oops.

The solution is to trust usbcore not to lose track of endpoints.  If
the QH isn't on the async list then it doesn't need to be taken off
the list, but the driver should still wait for the QH to become IDLE
before disabling it.

In theory this fixes Bugzilla #20182.  In fact the race is so rare
that it's not possible to tell whether the bug is still present.
However, adding delays and making other changes to force the race
seems to show that the patch works.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1008,10 +1008,11 @@ rescan:
 				tmp && tmp != qh;
 				tmp = tmp->qh_next.qh)
 			continue;
-		/* periodic qh self-unlinks on empty */
-		if (!tmp)
-			goto nogood;
-		unlink_async (ehci, qh);
+		/* periodic qh self-unlinks on empty, and a COMPLETING qh
+		 * may already be unlinked.
+		 */
+		if (tmp)
+			unlink_async(ehci, qh);
 		/* FALL THROUGH */
 	case QH_STATE_UNLINK:		/* wait for hw to finish? */
 	case QH_STATE_UNLINK_WAIT:
@@ -1028,7 +1029,6 @@ idle_timeout:
 		}
 		/* else FALL THROUGH */
 	default:
-nogood:
 		/* caller was supposed to have unlinked any requests;
 		 * that's not our job.  just leak this memory.
 		 */


