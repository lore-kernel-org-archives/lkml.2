Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2HNJOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:14:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:53750 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab2HNJOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:14:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,765,1336374000"; 
   d="scan'208";a="134035404"
Date: Tue, 14 Aug 2012 17:14:25 +0800
From: Aaron Lu <ziqian.lu@intel.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>,
        Lin Ming <minggr@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
        Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: bisected regression: v3.6-rc1: resume from s2ram does not
 restore ata_piix (v3.5 worked)
Message-ID: <20120814091425.GA1968@localhost.localdomain>
References: <CA2E3DE2DD06CA4FA11644750E4E292F102ACD65@SHSMSX102.ccr.corp.intel.com>
 <20120814080952.GA4981@localhost.localdomain>
 <20120814114420.2e844ea1@sf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814114420.2e844ea1@sf>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 11:44:20AM +0300, Sergei Trofimovich wrote:
> > The only problem I can see is the offending commit didn't do a gtm for
> > IDE channel during init. It was used to be done in
> > ata_acpi_associate_ide_port.
> > 
> > So can you please test if the following code fix your problem? Thanks.
> 
> Unfortunately, nothing changed. The same hangup after resume.
> Did the bisected patch change the way kernel relies on ACPI
> information?

No, I don't think so.

> I have some complains in dmesg output about it
> (attached whole dmesg) like that:
> 
> ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000004) is beyond end of object (20120711/exoparg2-418)
> ACPI Error: Method parse/execution failed [\_SB_.C003.C09A._DOD] (Node ffff88007b82c988), AE_AML_PACKAGE_LIMIT (20120711/psparse-536)
> ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD (20120711/video-1149)

I guess the above errors are related to video, not ata.

> ata1: ACPI get timing mode failed (AE 0x1001)

This means the _GTM control method failed, I suppose this control method
on your platform always failed, even with a working kernel. So this
shouldn't be the cause.

> ACPI: Invalid Power Resource to register!
Not related to the hang.

I've tried here with two systems, the sata controller are set to IDE
mode using ata_piix driver and no problem with S3. Don't have a clue at
the moment :-(

Thanks,
Aaron

> 
> They are not new errors.
> 
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index 902b5a4..0f338bb 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -1101,6 +1101,9 @@ static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
> >  	if (!*handle)
> >  		return -ENODEV;
> >  
> > +	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
> > +		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
> > +
> >  	return 0;
> >  }
> > 
> > Thanks,
> > Aaron
> > 



