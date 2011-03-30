Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab1C3WBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:01:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:65216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933278Ab1C3VGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236266"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tom@baringforge.com, ak@linux.intel.com, alexandre.bounine@idt.com,
        galak@kernel.crashing.org, mporter@kernel.crashing.org,
        leoli@freescale.com, thomas.moll@sysgo.com, micha@neli.hopto.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [54/275] rapidio: fix hang on RapidIO doorbell queue full condition
Message-Id: <20110330210450.886D73E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
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

Index: linux-2.6.35.y/arch/powerpc/sysdev/fsl_rio.c
===================================================================
--- linux-2.6.35.y.orig/arch/powerpc/sysdev/fsl_rio.c	2011-03-29 22:51:48.062493371 -0700
+++ linux-2.6.35.y/arch/powerpc/sysdev/fsl_rio.c	2011-03-29 23:02:59.287318406 -0700
@@ -952,7 +952,6 @@
 	if (dsr & DOORBELL_DSR_QFI) {
 		pr_info("RIO: doorbell queue full\n");
 		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_QFI);
-		goto out;
 	}
 
 	/* XXX Need to check/dispatch until queue empty */
