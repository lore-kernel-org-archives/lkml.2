Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1FOXe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 19:34:28 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58288 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab1FOXeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 19:34:25 -0400
Date: Wed, 15 Jun 2011 16:34:17 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: jgarzik@pobox.com, mbizon@freebox.fr, tj@kernel.org,
        benh@kernel.crashing.org, wayneb@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: libata/ipr/powerpc: regression between 2.6.39-rc4 and 2.6.39-rc5
Message-ID: <20110615233417.GB6324@us.ibm.com>
References: <20110615191747.GA6324@us.ibm.com>
 <4DF90FCA.1040706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF90FCA.1040706@linux.vnet.ibm.com>
X-Operating-System: Linux 2.6.38-8-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.06.2011 [15:02:18 -0500], Brian King wrote:
> On 06/15/2011 02:17 PM, Nishanth Aravamudan wrote:
> > From what I can tell, the only place that explicitly clears the FROZEN
> > flag is the error-handling code via ata_eh_thaw_port().
> > 
> > So I thought either we're not invoking the error-handler at probe time
> > correctly to kick the port or perhaps the SAS code is not clearing the
> > flag?
> > 
> > I tried the following patch:
> > 
> > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > index d51f979..abd0e0b 100644
> > --- a/drivers/ata/libata-scsi.c
> > +++ b/drivers/ata/libata-scsi.c
> > @@ -3797,6 +3797,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
> >   */
> >  int ata_sas_port_start(struct ata_port *ap)
> >  {
> > +       ap->pflags &= ~ATA_PFLAG_FROZEN;
> >         return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(ata_sas_port_start);
> > 
> > and the CD-ROM drive works, but I have no idea if it's the right thing
> > to do. I chose this particular change, FWIW, because we call
> > ata_sas_port_start before we probe in ata_sas_port_init and it seems
> > like we need to mark the port as not frozen before we init it? Perhaps
> > that should really be a call to a thaw function, not sure. Let's just
> > say the ATA/SAS/SCSI interactions are a bit hard to follow at first :)
> 
> That looks like the right thing to do. For ipr's usage of
> libata, we don't have the concept of a port frozen state, so this flag
> should really never get set. The alternate way to fix this would be to
> only set ATA_PFLAG_FROZEN in ata_port_alloc if ap->ops->error_handler
> is not NULL.

It seemed like ipr is as you say, but I wasn't sure if it was
appropriate to make the change above in the common libata-scis code or
not. I don't want to break some other device on accident.

Also, I tried your suggestion, but I don't think that can happen in
ata_port_alloc? ata_port_alloc is allocated ap itself, and it seems like
ap->ops typically gets set only after ata_port_alloc returns?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
