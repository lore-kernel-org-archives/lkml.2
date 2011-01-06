Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1AFAbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:55 -0500
Received: from kroah.org ([198.145.64.141]:36118 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab1AFAbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:50 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:10 2011
Message-Id: <20110106002309.949930724@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:24:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [141/152] libata-sff: fix HSM_ST_ERR handling in __ata_sff_port_intr()
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Reported-by: Antonio Toma <antonio.toma@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-sff.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1532,11 +1532,10 @@ static unsigned int __ata_sff_port_intr(
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


