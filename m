Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab1DNRyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:54:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:38443 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933362Ab1DNRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 078/209] USB: EHCI: fix obscure race in ehci_endpoint_disable
Date: Thu, 14 Apr 2011 13:41:48 -0400
Message-Id: <1302803039-9400-79-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-hcd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 13ead00..d2dd6e1 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1010,10 +1010,11 @@ rescan:
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
@@ -1030,7 +1031,6 @@ idle_timeout:
 		}
 		/* else FALL THROUGH */
 	default:
-nogood:
 		/* caller was supposed to have unlinked any requests;
 		 * that's not our job.  just leak this memory.
 		 */
-- 
1.7.4.4

