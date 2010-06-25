Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0FYPTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:19:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:55304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0FYPTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:19:40 -0400
Message-ID: <4C24C903.1070705@kernel.org>
Date: Fri, 25 Jun 2010 17:19:31 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch> <4C224429.6010705@kernel.org> <4C224502.2040206@kernel.org> <4C2305A8.4070708@odi.ch>
In-Reply-To: <4C2305A8.4070708@odi.ch>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------020603070400050700040305"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Jun 2010 15:19:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020603070400050700040305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hello,

Patch attached, but please see below.

On 06/24/2010 09:13 AM, Ortwin Glück wrote:
> On 23.06.2010 19:31, Tejun Heo wrote:
>> Meh, it won't work.  It's failing softreset so we should be checking
>> reset try counts.  I'll try to write up something tomorrow.
> 
> I am happy to try patches. The problem shows up maybe once a month
> only, however. Interestingly it only occurs on ata2 with a IBM hdd,
> never on the first channel with a maxtor. I can also try and attach
> the dvd on the first channel and see if that makes any difference.

Problems like this definitely can depend on the specific drive.

> ata1.00: ATA-5: MAXTOR 6L020J1, A93.0500, max UDMA/133
> ata2.00: ATA-5: IC25N030ATCS04-0, CA3OA71A, max UDMA/100
> ata2.01: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-115  0127, E1.27, max UDMA/33

Is it PATA?  Why do you have 2.01?  Can you please attach full boot
log?

Thanks.

-- 
tejun

--------------020603070400050700040305
Content-Type: text/x-patch;
 name="nv-last-reset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nv-last-reset.patch"

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f77a673..5b30776 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2486,6 +2486,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	 */
 	while (ata_eh_reset_timeouts[max_tries] != ULONG_MAX)
 		max_tries++;
+	if (max_tries > 1)
+		ehc->i.flags &= ~ATA_EHI_LAST_RESET;
+	else
+		ehc->i.flags |= ATA_EHI_LAST_RESET;
+
 	if (link->flags & ATA_LFLAG_NO_HRST)
 		hardreset = NULL;
 	if (link->flags & ATA_LFLAG_NO_SRST)
@@ -2814,6 +2819,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	if (try == max_tries - 1) {
+		ehc->i.flags |= ATA_EHI_LAST_RESET;
 		sata_down_spd_limit(link, 0);
 		if (slave)
 			sata_down_spd_limit(slave, 0);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 2116113..5c22f02 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1583,11 +1583,14 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
 {
 	struct ata_eh_context *ehc = &link->eh_context;
 
-	/* Do hardreset iff it's post-boot probing, please read the
-	 * comment above port ops for details.
+	/*
+	 * Do hardreset iff it's the last reset attempt or post-boot
+	 * probing, please read the comment above port ops for
+	 * details.
 	 */
-	if (!(link->ap->pflags & ATA_PFLAG_LOADING) &&
-	    !ata_dev_enabled(link->device))
+	if (ehc->i.flags & ATA_EHI_LAST_RESET ||
+	    (!(link->ap->pflags & ATA_PFLAG_LOADING) &&
+	     !ata_dev_enabled(link->device)))
 		sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
 				    NULL, NULL);
 	else {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b85f3ff..de61cc3 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -341,6 +341,7 @@ enum {
 	ATA_EHI_PRINTINFO	= (1 << 18), /* print configuration info */
 	ATA_EHI_SETMODE		= (1 << 19), /* configure transfer mode */
 	ATA_EHI_POST_SETMODE	= (1 << 20), /* revaildating after setmode */
+	ATA_EHI_LAST_RESET	= (1 << 21), /* last reset attempt hint */
 
 	ATA_EHI_DID_RESET	= ATA_EHI_DID_SOFTRESET | ATA_EHI_DID_HARDRESET,
 

--------------020603070400050700040305--
