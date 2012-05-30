Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2E3JHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:07:54 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:59116
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932272Ab2E3JHt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:07:49 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -17
X-BigFish: VS-17(zz9371I1447I542M1432N98dK4015Izz1202hzz8275dhz2fh2a8h668h839h944hd25hf0ah)
From: Fuzhou Chen <fuzhouch@microsoft.com>
To: Aaron Lu <aaron.lu@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Hashir Abdi <habdi@microsoft.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH v4 0/13] SATA ZPODD support
Thread-Topic: [PATCH v4 0/13] SATA ZPODD support
Thread-Index: AQHNPic5sKac6ROXoUmhaKVdpIsQT5biCA0g
Date: Wed, 30 May 2012 09:06:43 +0000
Message-ID: <6689D53B948ACF469C8E9C8CCD48EBE1166CD91A@SINEX14MBXC403.southpacific.corp.microsoft.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
 <20120528104438.044ae385@pyramind.ukuu.org.uk>
 <20120528105428.689d0102@pyramind.ukuu.org.uk>
 <CAF1ivSaYo8bcYAJ0i1b44HTarz11gndUU_pG109sGPOaupDi3w@mail.gmail.com>
 <20120530054310.GA11672@ladygaga>
In-Reply-To: <20120530054310.GA11672@ladygaga>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Aaron, but I have left Microsoft Open Source team for a while. Due to policy limitations, I can't touch Linux kernel source now. 

Hi Hashir, could you help find current owner of our HDD driver to verify this fix? This is a ata-acpi module bug I reported last year. Our daily BVT in linux-next tree should be able to handle this verification

Thanks,
Fuzhou

-----Original Message-----
From: Aaron Lu [mailto:aaron.lu@amd.com] 
Sent: Wednesday, May 30, 2012 1:43 PM
To: Lin Ming; Fuzhou Chen
Cc: Alan Cox; Jeff Garzik; David Woodhouse; Holger Macht; Matthew Garrett; linux-kernel@vger.kernel.org; linux-pm@vger.kernel.org; linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org; linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 0/13] SATA ZPODD support

On Tue, May 29, 2012 at 08:32:49PM +0800, Lin Ming wrote:
> On Mon, May 28, 2012 at 5:54 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Have you fixed the fact that Matthews patches broke things like 
> >> pata_acpi last time ? Until that is fixed properly I don't see that 
> >> these patches can make any progress.
> >
> > https://lkml.org/lkml/2012/2/24/2
> 
> Aaron has a fix.
> We'll do more test.

Here is the patch, apply on top of the ZPODD patch set.

Hi Fuzhou,
Can you please give it a test? Thanks.
I tested on my system with a ATI IDE controller and it could work with pata_acpi module.

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c index 6de8f32..c53266a 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -59,7 +59,18 @@ acpi_handle ata_ap_acpi_handle(struct ata_port *ap)  {
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return NULL;
-	return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
+
+	/*
+	 * If acpi bind operation has already happened, we can get the handle
+	 * for the port by checking the corresponding scsi_host device's
+	 * firmware node, otherwise we will need to find out the handle from
+	 * its parent's acpi node.
+	 */
+	if (ap->scsi_host)
+		return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
+	else
+		return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev),
+				ap->port_no);
 }
 EXPORT_SYMBOL(ata_ap_acpi_handle);

-Aaron

> 
> Thanks for the info.
> Lin Ming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
> 


