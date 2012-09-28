Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab2I1VOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:14:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46187 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759491Ab2I1Uke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:34 -0400
X-Sasl-enc: wydq7hG93rsHW8/dd3/LrbbquOK5LoKfiPZ2O5Mxura5 1348864829
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 011/127] Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
Date: Fri, 28 Sep 2012 13:33:04 -0700
Message-Id: <20120928203047.144376484@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit e15ca9a0ef9a86f0477530b0f44a725d67f889ee ]

The HCI code fails to initialize the two padding bytes of struct
hci_ufilter before copying it to userland -- that for leaking two
bytes kernel stack. Add an explicit memset(0) before filling the
structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -644,6 +644,7 @@ static int hci_sock_setsockopt(struct so
 		{
 			struct hci_filter *f = &hci_pi(sk)->filter;
 
+			memset(&uf, 0, sizeof(uf));
 			uf.type_mask = f->type_mask;
 			uf.opcode    = f->opcode;
 			uf.event_mask[0] = *((u32 *) f->event_mask + 0);


