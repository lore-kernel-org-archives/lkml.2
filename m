Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1CKUpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:45:38 -0500
Received: from kroah.org ([198.145.64.141]:46553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab1CKUnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:43:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 11 12:41:10 2011
Message-Id: <20110311204110.032665901@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 11 Mar 2011 12:40:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
Subject: [07/17] powerpc/kdump: Use chip->shutdown to disable IRQs
In-Reply-To: <20110311204126.GA7223@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 5d7a87217de48b234b3c8ff8a73059947d822e07 upstream.

I saw this in a kdump kernel:

IOMMU table initialized, virtual merging enabled
Interrupt 155954 (real) is invalid, disabling it.
Interrupt 155953 (real) is invalid, disabling it.

ie we took some spurious interrupts. default_machine_crash_shutdown tries
to disable all interrupt sources but uses chip->disable which maps to
the default action of:

static void default_disable(unsigned int irq)
{
}

If we use chip->shutdown, then we actually mask the IRQ:

static void default_shutdown(unsigned int irq)
{
        struct irq_desc *desc = irq_to_desc(irq);

        desc->chip->mask(irq);
        desc->status |= IRQ_MASKED;
}

Not sure why we don't implement a ->disable action for xics.c, or why
default_disable doesn't mask the interrupt.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -381,7 +381,7 @@ void default_machine_crash_shutdown(stru
 			desc->chip->eoi(i);
 
 		if (!(desc->status & IRQ_DISABLED))
-			desc->chip->disable(i);
+			desc->chip->shutdown(i);
 	}
 
 	/*


