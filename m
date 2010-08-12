Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab0HLAH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:07:58 -0400
Received: from kroah.org ([198.145.64.141]:60455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966Ab0HLAHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:07:50 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:13 2010
Message-Id: <20100812000613.326364328@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Christoph Fritz <chf.fritz@googlemail.com>
Subject: [07/67] pcmcia: avoid buffer overflow in pcmcia_setup_isa_irq
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 127c03cdbad9bd5af5d7f33bd31a1015a90cb77f upstream.

NR_IRQS may be as low as 16, causing a (harmless?) buffer overflow in
pcmcia_setup_isa_irq():

static u8 pcmcia_used_irq[NR_IRQS];

...

		if ((try < 32) && pcmcia_used_irq[irq])
			continue;

This is read-only, so if this address would be non-zero, it would just
mean we would not attempt an IRQ >= NR_IRQS -- which would fail anyway!
And as request_irq() fails for an irq >= NR_IRQS, the setting code path:

			pcmcia_used_irq[irq]++;

is never reached as well.

Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/pcmcia_resource.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -651,7 +651,7 @@ EXPORT_SYMBOL(__pcmcia_request_exclusive
 #ifdef CONFIG_PCMCIA_PROBE
 
 /* mask of IRQs already reserved by other cards, we should avoid using them */
-static u8 pcmcia_used_irq[NR_IRQS];
+static u8 pcmcia_used_irq[32];
 
 static irqreturn_t test_action(int cpl, void *dev_id)
 {
@@ -674,6 +674,9 @@ static int pcmcia_setup_isa_irq(struct p
 	for (try = 0; try < 64; try++) {
 		irq = try % 32;
 
+		if (irq > NR_IRQS)
+			continue;
+
 		/* marked as available by driver, not blocked by userspace? */
 		if (!((mask >> irq) & 1))
 			continue;


