Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1DYUuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:50:05 -0400
Received: from 1wt.eu ([62.212.114.60]:34140 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab1DYUYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:31 -0400
Message-Id: <20110425200233.776513369@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Thomas Taranowski <tom@baringforge.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 018/173] rapidio: fix hang on RapidIO doorbell queue full condition
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
@@ -832,7 +832,6 @@ fsl_rio_dbell_handler(int irq, void *dev
 	if (dsr & DOORBELL_DSR_QFI) {
 		pr_info("RIO: doorbell queue full\n");
 		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_QFI);
-		goto out;
 	}
 
 	/* XXX Need to check/dispatch until queue empty */


