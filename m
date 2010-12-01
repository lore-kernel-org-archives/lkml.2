Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0LAOUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:20:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:58683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0LAOUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:20:06 -0500
Message-ID: <4CF6595A.6010104@kernel.org>
Date: Wed, 01 Dec 2010 15:19:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
References: <20101022012302.GA7487@havoc.gtf.org> <20101129180755.GK15818@bombadil.infradead.org> <4CF506A6.4020200@kernel.org> <20101130153839.GM15818@bombadil.infradead.org> <4CF52652.4030802@kernel.org> <20101130163150.GA25668@bombadil.infradead.org> <20101130175317.GB25668@bombadil.infradead.org> <20101130210938.GF25668@bombadil.infradead.org> <4CF62EE0.7040607@kernel.org> <20101201124445.GG25668@bombadil.infradead.org>
In-Reply-To: <20101201124445.GG25668@bombadil.infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 14:19:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On 12/01/2010 01:44 PM, Kyle McMartin wrote:
> 00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series
...
> 	Model Number:       HITACHI HTS725032A9A364                 

Nothing peculiar.  Hmm... okay, I think I've found what went wrong.
Can you please try the following patch and see whether the problem
goes away?

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5e59050..17a6378 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3275,6 +3275,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	struct ata_port *ap = ata_is_host_link(link) ? link->ap : NULL;
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
+	enum ata_lpm_policy old_policy = link->lpm_policy;
 	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
 	unsigned int err_mask;
 	int rc;
@@ -3338,6 +3339,14 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 		goto fail;
 	}

+	/*
+	 * Low level driver acked the transition.  Issue DIPM command
+	 * with the new policy set.
+	 */
+	link->lpm_policy = policy;
+	if (ap && ap->slave_link)
+		ap->slave_link->lpm_policy = policy;
+
 	/* host config updated, enable DIPM if transitioning to MIN_POWER */
 	ata_for_each_dev(dev, link, ENABLED) {
 		if (policy == ATA_LPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
@@ -3353,12 +3362,14 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 		}
 	}

-	link->lpm_policy = policy;
-	if (ap && ap->slave_link)
-		ap->slave_link->lpm_policy = policy;
 	return 0;

 fail:
+	/* restore the old policy */
+	link->lpm_policy = old_policy;
+	if (ap && ap->slave_link)
+		ap->slave_link->lpm_policy = old_policy;
+
 	/* if no device or only one more chance is left, disable LPM */
 	if (!dev || ehc->tries[dev->devno] <= 2) {
 		ata_link_printk(link, KERN_WARNING,
