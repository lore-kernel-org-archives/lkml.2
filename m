Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1KCBy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:54:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934501Ab1KCBlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:44 2011
Message-Id: <20111102222744.774158854@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [055/101] [SCSI] ipr: Always initiate hard reset in kdump kernel
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 5d7c20b7fa5c6ca19e871b4050e321c99d32bd43 upstream.

During kdump testing I noticed timeouts when initialising each IPR
adapter. While the driver has logic to detect an adapter in an
indeterminate state, it wasn't triggering and each adapter went
through a 5 minute timeout before finally going operational.

Some analysis showed the needs_hard_reset flag wasn't getting set.
We can check the reset_devices kernel parameter which is set by
kdump and force a full reset. This fixes the problem.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ipr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7673,7 +7673,7 @@ static int __devinit ipr_probe_ioa(struc
 	uproc = readl(ioa_cfg->regs.sense_uproc_interrupt_reg);
 	if ((mask & IPR_PCII_HRRQ_UPDATED) == 0 || (uproc & IPR_UPROCI_RESET_ALERT))
 		ioa_cfg->needs_hard_reset = 1;
-	if (interrupts & IPR_PCII_ERROR_INTERRUPTS)
+	if ((interrupts & IPR_PCII_ERROR_INTERRUPTS) || reset_devices)
 		ioa_cfg->needs_hard_reset = 1;
 	if (interrupts & IPR_PCII_IOA_UNIT_CHECKED)
 		ioa_cfg->ioa_unit_checked = 1;


