Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2GRARd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:17:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39056 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab2GRAMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:12:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 08/23] rt2x00usb: fix indexes ordering on RX queue kick
Date: Tue, 17 Jul 2012 17:12:01 -0700
Message-Id: <20120717232329.898578692@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232329.276003806@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232329.276003806@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -426,8 +426,8 @@ void rt2x00usb_kick_queue(struct data_qu
 	case QID_RX:
 		if (!rt2x00queue_full(queue))
 			rt2x00queue_for_each_entry(queue,
-						   Q_INDEX_DONE,
 						   Q_INDEX,
+						   Q_INDEX_DONE,
 						   NULL,
 						   rt2x00usb_kick_rx_entry);
 		break;


