Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2L1TTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55427 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932272Ab2L1TTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:03 -0500
Message-Id: <20121228190346.334894433@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 077/173] USB: OHCI: workaround for hardware bug: retired TDs not added to the
 Done Queue
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 50ce5c0683aa83eb161624ea89daa5a9eee0c2ce upstream.

This patch (as1636) is a partial workaround for a hardware bug
affecting OHCI controllers by NVIDIA at least, maybe others too.  When
the controller retires a Transfer Descriptor, it is supposed to add
the TD onto the Done Queue.  But sometimes this doesn't happen, with
the result that ohci-hcd never realizes the corresponding transfer has
finished.  Symptoms can vary; a typical result is that USB audio stops
working after a while.

The patch works around the problem by recognizing that TDs are always
processed in order.  Therefore, if a later TD is found on the Done
Queue than all the earlier TDs for the same endpoint must be finished
as well.

Unfortunately this won't solve the problem in cases where the missing
TD is the last one in the endpoint's queue.  A complete fix would
require a signficant amount of change to the driver.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ohci-q.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index 177a213..7482cfb 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -1128,6 +1128,25 @@ dl_done_list (struct ohci_hcd *ohci)
 
 	while (td) {
 		struct td	*td_next = td->next_dl_td;
+		struct ed	*ed = td->ed;
+
+		/*
+		 * Some OHCI controllers (NVIDIA for sure, maybe others)
+		 * occasionally forget to add TDs to the done queue.  Since
+		 * TDs for a given endpoint are always processed in order,
+		 * if we find a TD on the donelist then all of its
+		 * predecessors must be finished as well.
+		 */
+		for (;;) {
+			struct td	*td2;
+
+			td2 = list_first_entry(&ed->td_list, struct td,
+					td_list);
+			if (td2 == td)
+				break;
+			takeback_td(ohci, td2);
+		}
+
 		takeback_td(ohci, td);
 		td = td_next;
 	}


