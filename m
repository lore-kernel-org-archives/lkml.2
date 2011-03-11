Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1CKLJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:09:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48856 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1CKLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AaNL8EqLFmSVYPk+00txyzvzgCQ++H4BZx7W3rRSjBS/Tex14VczJk05zHu4HNAFrd
         MsaWWxbuMU23hmn0PKhr5ZbL9CIdMLcszufAMOs9WWZLYTHdvTixyrWQ9Iv3snIc5vD+
         xYn5/Yll3FCHQMj9CHYTiWiIolDa7m5lYWUyk=
Date: Fri, 11 Mar 2011 12:01:44 +0100
From: Tejun Heo <tj@kernel.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: Some hints needed how to handle SATA ALPM failures
Message-ID: <20110311110144.GF13038@htj.dyndns.org>
References: <4D5E6CE1.9020908@canonical.com>
 <20110218145057.GM21209@htj.dyndns.org>
 <4D5E9681.7020809@canonical.com>
 <20110218161640.GR21209@htj.dyndns.org>
 <4D5EA38D.9060804@canonical.com>
 <4D79F92A.20402@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D79F92A.20402@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:27:54AM +0100, Stefan Bader wrote:
> > Yes, it is an Nvidia MCP67 in ahci mode. I can relay the question about
> > medium_power and yes we can try patches. If not the reporter, I can prepare
> > kernels and ask for testing.
> > One question in general would be whether (if it cannot be said for sure which
> > controller is good or not) it may be a good idea to add some whitelisting for
> > those known to work and disable (or limit the mode) for the unknown.

Does the following patch resolve the issue?

Thanks.

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b8d96ce..da75ec3 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -150,7 +150,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_FPDMA_AA | AHCI_HFLAG_NO_PMP |
 				 AHCI_HFLAG_YES_NCQ),
-		.flags		= AHCI_FLAG_COMMON,
+		.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NO_DIPM,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 17a6378..3021b95 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3276,6 +3276,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
 	enum ata_lpm_policy old_policy = link->lpm_policy;
+	bool no_dipm = ap->flags & ATA_FLAG_NO_DIPM;
 	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
 	unsigned int err_mask;
 	int rc;
@@ -3292,7 +3293,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	 */
 	ata_for_each_dev(dev, link, ENABLED) {
 		bool hipm = ata_id_has_hipm(dev->id);
-		bool dipm = ata_id_has_dipm(dev->id);
+		bool dipm = ata_id_has_dipm(dev->id) && !no_dipm;
 
 		/* find the first enabled and LPM enabled devices */
 		if (!link_dev)
@@ -3349,7 +3350,8 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 
 	/* host config updated, enable DIPM if transitioning to MIN_POWER */
 	ata_for_each_dev(dev, link, ENABLED) {
-		if (policy == ATA_LPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
+		if (policy == ATA_LPM_MIN_POWER && !no_dipm &&
+		    ata_id_has_dipm(dev->id)) {
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c9c5d7a..3ad1eeb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -137,8 +137,6 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
-	ATA_DFLAG_HIPM		= (1 << 8), /* device supports HIPM */
-	ATA_DFLAG_DIPM		= (1 << 9), /* device supports DIPM */
 	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
@@ -203,6 +201,7 @@ enum {
 					      * management */
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
 					      * led */
+	ATA_FLAG_NO_DIPM	= (1 << 23), /* host not happy with DIPM */
 
 	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
 
