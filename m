Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1BBAsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:48:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:43069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1BBApQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505368"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: tj@kernel.org, ak@linux.intel.com, jgarzik@redhat.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [127/139] libata-sff: fix HSM_ST_ERR handling in __ata_sff_port_intr()
Message-Id: <20110202004526.A7DD83E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 687a993339c4f3a63654746230da3aab8bbdbffd upstream.

While separating out BMDMA irq handler from SFF, commit c3b28894
(libata-sff: separate out BMDMA irq handler) incorrectly made
__ata_sff_port_intr() consider an IRQ to be an idle one if the host
state was transitioned to HSM_ST_ERR by ata_bmdma_port_intr().

This makes BMDMA drivers ignore IRQs reporting host bus error which
leads to timeouts instead of triggering EH immediately.  Fix it by
making __ata_sff_port_intr() consider the IRQ to be an idle one iff
the state is HSM_ST_IDLE.  This is equivalent to adding HSM_ST_ERR to
the "break"ing case but less error-prone.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Antonio Toma <antonio.toma@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-sff.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/ata/libata-sff.c
===================================================================
--- linux-2.6.35.y.orig/drivers/ata/libata-sff.c
+++ linux-2.6.35.y/drivers/ata/libata-sff.c
@@ -1515,11 +1515,10 @@ static unsigned int __ata_sff_port_intr(
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
 			return ata_sff_idle_irq(ap);
 		break;
-	case HSM_ST:
-	case HSM_ST_LAST:
-		break;
-	default:
+	case HSM_ST_IDLE:
 		return ata_sff_idle_irq(ap);
+	default:
+		break;
 	}
 
 	/* check main status, clearing INTRQ if needed */
