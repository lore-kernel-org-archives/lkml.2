Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1FWEbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 00:31:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:53951 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1FWEbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 00:31:39 -0400
Subject: Re: [PATCH] libata/sas: only set FROZEN flag if new EH is supported
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, wayneb@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        mbizon@freebox.fr, jgarzik@pobox.com
In-Reply-To: <4E00FF58.7070802@linux.vnet.ibm.com>
References: <20110615191747.GA6324@us.ibm.com>
	 <4DF90FCA.1040706@linux.vnet.ibm.com> <20110615233417.GB6324@us.ibm.com>
	 <20110616075114.GH8141@htj.dyndns.org>
	 <4DFA0507.3090609@linux.vnet.ibm.com> <20110616152836.GA15268@us.ibm.com>
	 <20110621160714.GA14174@us.ibm.com>  <4E00FF58.7070802@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 14:31:01 +1000
Message-ID: <1308803461.32158.191.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 15:30 -0500, Brian King wrote:
> Looks good to me. Jeff/Tejun - any issues with merging this?

BTW. Current upstream with that patch applied on a machine here leads to
several oddities, I don't know at this point whether any of that is
actually a regression :




> Thanks,
> 
> Brian
> 
> On 06/21/2011 11:07 AM, Nishanth Aravamudan wrote:
> > Ping on this -- Tejun, Brian, Jeff, this is a pretty annoying 2.6.39
> > regression which it would be good to have fixed in 3.0.
> > 
> > Thanks,
> > Nish
> > 
> > On 16.06.2011 [08:28:36 -0700], Nishanth Aravamudan wrote:
> >> On 16.06.2011 [08:28:39 -0500], Brian King wrote:
> >>> On 06/16/2011 02:51 AM, Tejun Heo wrote:
> >>>> On Wed, Jun 15, 2011 at 04:34:17PM -0700, Nishanth Aravamudan wrote:
> >>>>>> That looks like the right thing to do. For ipr's usage of
> >>>>>> libata, we don't have the concept of a port frozen state, so this flag
> >>>>>> should really never get set. The alternate way to fix this would be to
> >>>>>> only set ATA_PFLAG_FROZEN in ata_port_alloc if ap->ops->error_handler
> >>>>>> is not NULL.
> >>>>>
> >>>>> It seemed like ipr is as you say, but I wasn't sure if it was
> >>>>> appropriate to make the change above in the common libata-scis code or
> >>>>> not. I don't want to break some other device on accident.
> >>>>>
> >>>>> Also, I tried your suggestion, but I don't think that can happen in
> >>>>> ata_port_alloc? ata_port_alloc is allocated ap itself, and it seems like
> >>>>> ap->ops typically gets set only after ata_port_alloc returns?
> >>>>
> >>>> Maybe we can test error_handler in ata_sas_port_start()?
> >>>
> >>> Good point. Since libsas is converted to the new eh now, we would need to have
> >>> this test.
> >>
> >> Commit 7b3a24c57d2eeda8dba9c205342b12689c4679f9 ("ahci: don't enable
> >> port irq before handler is registered") caused a regression for CD-ROMs
> >> attached to the IPR SATA bus on Power machines:
> >>
> >>   ata_port_alloc: ENTER
> >>   ata_port_probe: ata1: bus probe begin
> >>   ata1.00: ata_dev_read_id: ENTER
> >>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> >>   ata1.00: ata_dev_read_id: ENTER
> >>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> >>   ata1.00: limiting speed to UDMA7:PIO5
> >>   ata1.00: ata_dev_read_id: ENTER
> >>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> >>   ata1.00: disabled
> >>   ata_port_probe: ata1: bus probe end
> >>   scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> >>
> >> The FROZEN flag added in that commit is only cleared by the new EH code,
> >> which is not used by ipr. Clear this flag in the SAS code if we don't
> >> support new EH.
> >>
> >> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> >>
> >> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> >> index d51f979..ebe1685 100644
> >> --- a/drivers/ata/libata-scsi.c
> >> +++ b/drivers/ata/libata-scsi.c
> >> @@ -3797,6 +3797,12 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
> >>   */
> >>  int ata_sas_port_start(struct ata_port *ap)
> >>  {
> >> +	/*
> >> +	 * the port is marked as frozen at allocation time, but if we don't
> >> +	 * have new eh, we won't thaw it
> >> +	 */
> >> +	if (!ap->ops->error_handler)
> >> +		ap->pflags &= ~ATA_PFLAG_FROZEN;
> >>  	return 0;
> >>  }
> >>  EXPORT_SYMBOL_GPL(ata_sas_port_start);
> >>
> >>
> >> -- 
> >> Nishanth Aravamudan <nacc@us.ibm.com>
> >> IBM Linux Technology Center
> > 
> 
> 


