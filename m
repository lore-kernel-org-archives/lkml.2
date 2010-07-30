Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab0G3SYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:24:46 -0400
Received: from kroah.org ([198.145.64.141]:58563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759977Ab0G3Rzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:41 2010
Message-Id: <20100730175141.815256382@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Subject: [090/205] genirq: Deal with desc->set_type() changing desc->chip
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 4673247562e39a17e09440fa1400819522ccd446 upstream.

The set_type() function can change the chip implementation when the
trigger mode changes. That might result in using an non-initialized
irq chip when called from __setup_irq() or when called via
set_irq_type() on an already enabled irq.

The set_irq_type() function should not be called on an enabled irq,
but because we forgot to put a check into it, we have a bunch of users
which grew the habit of doing that and it never blew up as the
function is serialized via desc->lock against all users of desc->chip
and they never hit the non-initialized irq chip issue.

The easy fix for the __setup_irq() issue would be to move the
irq_chip_set_defaults(desc->chip) call after the trigger setting to
make sure that a chip change is covered.

But as we have already users, which do the type setting after
request_irq(), the safe fix for now is to call irq_chip_set_defaults()
from __irq_set_trigger() when desc->set_type() changed the irq chip.

It needs a deeper analysis whether we should refuse to change the chip
on an already enabled irq, but that'd be a large scale change to fix
all the existing users. So that's neither stable nor 2.6.35 material.

Reported-by: Esben Haabendal <eha@doredevelopment.dk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/manage.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -440,6 +440,9 @@ int __irq_set_trigger(struct irq_desc *d
 		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
 		desc->status &= ~(IRQ_LEVEL | IRQ_TYPE_SENSE_MASK);
 		desc->status |= flags;
+
+		if (chip != desc->chip)
+			irq_chip_set_defaults(desc->chip);
 	}
 
 	return ret;


