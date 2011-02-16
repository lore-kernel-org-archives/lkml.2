Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1BPB2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:28:52 -0500
Received: from kroah.org ([198.145.64.141]:39424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab1BPAV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001438.641700239@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Taranowski <tom@baringforge.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [136/272] rapidio: fix hang on RapidIO doorbell queue full condition
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Taranowski <tom@baringforge.com>

commit 12a4dc43911785f51a596f771ae0701b18d436f1 upstream.

In fsl_rio_dbell_handler() the code currently simply acknowledges the QFI
queue full interrupt, but does nothing to resolve the queue full
condition.  Instead, it jumps to the end of the isr.  When a queue full
condition occurs, the isr is then re-entered immediately and continually,
forever.

The fix is to just fall through and read out current doorbell entries.

Signed-off-by: Thomas Taranowski <tom@baringforge.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/sysdev/fsl_rio.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -973,7 +973,6 @@ fsl_rio_dbell_handler(int irq, void *dev
 	if (dsr & DOORBELL_DSR_QFI) {
 		pr_info("RIO: doorbell queue full\n");
 		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_QFI);
-		goto out;
 	}
 
 	/* XXX Need to check/dispatch until queue empty */


