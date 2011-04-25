Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab1DYUlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:41:12 -0400
Received: from 1wt.eu ([62.212.114.60]:34316 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab1DYUY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:56 -0400
Message-Id: <20110425200236.166713316@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh babulal <kamalesh@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 073/173] powerpc/kdump: Use chip->shutdown to disable IRQs
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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


