Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab0HXXnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:43:08 -0400
Received: from kroah.org ([198.145.64.141]:52262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab0HXWyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:54:13 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:25 2010
Message-Id: <20100824222525.796700864@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Christoph Fritz <chf.fritz@googlemail.com>
Subject: [39/59] pcmcia: avoid buffer overflow in pcmcia_setup_isa_irq
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -39,7 +39,7 @@ module_param(io_speed, int, 0444);
 #ifdef CONFIG_PCMCIA_PROBE
 #include <asm/irq.h>
 /* mask of IRQs already reserved by other cards, we should avoid using them */
-static u8 pcmcia_used_irq[NR_IRQS];
+static u8 pcmcia_used_irq[32];
 #endif
 
 
@@ -719,6 +719,9 @@ int pcmcia_request_irq(struct pcmcia_dev
 		for (try = 0; try < 64; try++) {
 			irq = try % 32;
 
+			if (irq > NR_IRQS)
+				continue;
+
 			/* marked as available by driver, and not blocked by userspace? */
 			if (!((mask >> irq) & 1))
 				continue;


