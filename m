Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab0EJXED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:04:03 -0400
Received: from kroah.org ([198.145.64.141]:45335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926Ab0EJW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:27 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:41 2010
Message-Id: <20100510223541.243072327@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andre Detsch <adetsch@br.ibm.com>, Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       Brandon Philips <bphilips@suse.de>
Subject: [76/98] tg3: Fix INTx fallback when MSI fails
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andre Detsch <adetsch@br.ibm.com>

commit dc8bf1b1a6edfc92465526de19772061302f0929 upstream.

tg3: Fix INTx fallback when MSI fails

MSI setup changes the value of irq_vec in struct tg3 *tp.
This attribute must be taken into account and restored before
we try to do a new request_irq for INTx fallback.

In powerpc, the original code was leading to an EINVAL return within
request_irq, because the driver was trying to use the disabled MSI
virtual irq number instead of tp->pdev->irq.

Signed-off-by: Andre Detsch <adetsch@br.ibm.com>
Acked-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -8168,6 +8168,7 @@ static int tg3_test_msi(struct tg3 *tp)
 	pci_disable_msi(tp->pdev);
 
 	tp->tg3_flags2 &= ~TG3_FLG2_USING_MSI;
+	tp->napi[0].irq_vec = tp->pdev->irq;
 
 	err = tg3_request_irq(tp, 0);
 	if (err)


