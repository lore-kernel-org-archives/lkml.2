Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1ENKaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:30:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1ENKaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a8nPxf1DsZITv5rKx24Jeuj/jzASyxqa1V5ILWd5MzccpQh7kFwxiBoQW1UKPvbTOx
         aJBueUpcExMGwDBpiT9fyEOcfj7GJsYAl0yMxoyrUF2Qf72gj4gksYC7qJX8zUKPOgm8
         wVlXzxqTM2B6Ye289QyghVfNb5AauaNUdqeVg=
Date: Sat, 14 May 2011 12:28:04 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Garzik <jgarzik@pobox.com>
Cc: Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeff Garzik <jgarzik@pobox.com>, Jian Peng <jipeng2005@gmail.com>
Subject: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant to
 AHCI spec"
Message-ID: <20110514102804.GB23665@htj.dyndns.org>
References: <201105120025.34531.rjw@sisk.pl>
 <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com>
 <201105132222.11582.rjw@sisk.pl>
 <201105132244.29605.rjw@sisk.pl>
 <20110514101807.GA23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514101807.GA23665@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 270dac35c26433d06a89150c51e75ca0181ca7e4.

The commits causes command timeouts on AC plug/unplug.  It isn't yet
clear why.  As the commit was for a single rather obscure controller,
revert the change for now.

The problem was reported and bisected by Gu Rui in bug#34692.

 https://bugzilla.kernel.org/show_bug.cgi?id=34692

Also, reported by Rafael and Michael in the following thread.

 http://thread.gmane.org/gmane.linux.kernel/1138771

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Gu Rui <chaos.proton@gmail.com>
Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Michael Leun <lkml20100708@newton.leun.net>
Cc: Jian Peng <jipeng2005@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
As we're already in -rc7, I'm sending the revert patch to both Jeff
and Linus.

Thank you.

 drivers/ata/libahci.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index ff9d832..d38c40f 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -561,27 +561,6 @@ void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
-	u8 status;
-
-	status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-
-	/*
-	 * At end of section 10.1 of AHCI spec (rev 1.3), it states
-	 * Software shall not set PxCMD.ST to 1 until it is determined
-	 * that a functoinal device is present on the port as determined by
-	 * PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h
-	 *
-	 * Even though most AHCI host controllers work without this check,
-	 * specific controller will fail under this condition
-	 */
-	if (status & (ATA_BUSY | ATA_DRQ))
-		return;
-	else {
-		ahci_scr_read(&ap->link, SCR_STATUS, &tmp);
-
-		if ((tmp & 0xf) != 0x3)
-			return;
-	}
 
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);
-- 
1.7.1

