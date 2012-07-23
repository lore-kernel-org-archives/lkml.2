Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2GWBxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:53:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54343 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443Ab2GWBnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:17 -0400
Message-Id: <20120723010659.475635464@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 053/108] rt2x00usb: fix indexes ordering on RX queue kick
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit efd821182cec8c92babef6e00a95066d3252fda4 upstream.

On rt2x00_dmastart() we increase index specified by Q_INDEX and on
rt2x00_dmadone() we increase index specified by Q_INDEX_DONE. So entries
between Q_INDEX_DONE and Q_INDEX are those we currently process in the
hardware. Entries between Q_INDEX and Q_INDEX_DONE are those we can
submit to the hardware.

According to that fix rt2x00usb_kick_queue(), as we need to submit RX
entries that are not processed by the hardware. It worked before only
for empty queue, otherwise was broken.

Note that for TX queues indexes ordering are ok. We need to kick entries
that have filled skb, but was not submitted to the hardware, i.e.
started from Q_INDEX_DONE and have ENTRY_DATA_PENDING bit set.

>From practical standpoint this fixes RX queue stall, usually reproducible
in AP mode, like for example reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=828824

Reported-and-tested-by: Franco Miceli <fmiceli@plan.ceibal.edu.uy>
Reported-and-tested-by: Tom Horsley <horsley1953@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index d357d1e..74ecc33 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -436,8 +436,8 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
 	case QID_RX:
 		if (!rt2x00queue_full(queue))
 			rt2x00queue_for_each_entry(queue,
-						   Q_INDEX_DONE,
 						   Q_INDEX,
+						   Q_INDEX_DONE,
 						   NULL,
 						   rt2x00usb_kick_rx_entry);
 		break;


