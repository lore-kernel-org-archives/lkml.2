Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab1FUQHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:07:43 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48388 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1FUQHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:07:40 -0400
Date: Tue, 21 Jun 2011 09:07:14 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        wayneb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, mbizon@freebox.fr, jgarzik@pobox.com
Subject: Re: [PATCH] libata/sas: only set FROZEN flag if new EH is supported
Message-ID: <20110621160714.GA14174@us.ibm.com>
References: <20110615191747.GA6324@us.ibm.com>
 <4DF90FCA.1040706@linux.vnet.ibm.com>
 <20110615233417.GB6324@us.ibm.com>
 <20110616075114.GH8141@htj.dyndns.org>
 <4DFA0507.3090609@linux.vnet.ibm.com>
 <20110616152836.GA15268@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616152836.GA15268@us.ibm.com>
X-Operating-System: Linux 2.6.38-8-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping on this -- Tejun, Brian, Jeff, this is a pretty annoying 2.6.39
regression which it would be good to have fixed in 3.0.

Thanks,
Nish

On 16.06.2011 [08:28:36 -0700], Nishanth Aravamudan wrote:
> On 16.06.2011 [08:28:39 -0500], Brian King wrote:
> > On 06/16/2011 02:51 AM, Tejun Heo wrote:
> > > On Wed, Jun 15, 2011 at 04:34:17PM -0700, Nishanth Aravamudan wrote:
> > >>> That looks like the right thing to do. For ipr's usage of
> > >>> libata, we don't have the concept of a port frozen state, so this flag
> > >>> should really never get set. The alternate way to fix this would be to
> > >>> only set ATA_PFLAG_FROZEN in ata_port_alloc if ap->ops->error_handler
> > >>> is not NULL.
> > >>
> > >> It seemed like ipr is as you say, but I wasn't sure if it was
> > >> appropriate to make the change above in the common libata-scis code or
> > >> not. I don't want to break some other device on accident.
> > >>
> > >> Also, I tried your suggestion, but I don't think that can happen in
> > >> ata_port_alloc? ata_port_alloc is allocated ap itself, and it seems like
> > >> ap->ops typically gets set only after ata_port_alloc returns?
> > > 
> > > Maybe we can test error_handler in ata_sas_port_start()?
> > 
> > Good point. Since libsas is converted to the new eh now, we would need to have
> > this test.
> 
> Commit 7b3a24c57d2eeda8dba9c205342b12689c4679f9 ("ahci: don't enable
> port irq before handler is registered") caused a regression for CD-ROMs
> attached to the IPR SATA bus on Power machines:
> 
>   ata_port_alloc: ENTER
>   ata_port_probe: ata1: bus probe begin
>   ata1.00: ata_dev_read_id: ENTER
>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
>   ata1.00: ata_dev_read_id: ENTER
>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
>   ata1.00: limiting speed to UDMA7:PIO5
>   ata1.00: ata_dev_read_id: ENTER
>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
>   ata1.00: disabled
>   ata_port_probe: ata1: bus probe end
>   scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> 
> The FROZEN flag added in that commit is only cleared by the new EH code,
> which is not used by ipr. Clear this flag in the SAS code if we don't
> support new EH.
> 
> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d51f979..ebe1685 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3797,6 +3797,12 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
>   */
>  int ata_sas_port_start(struct ata_port *ap)
>  {
> +	/*
> +	 * the port is marked as frozen at allocation time, but if we don't
> +	 * have new eh, we won't thaw it
> +	 */
> +	if (!ap->ops->error_handler)
> +		ap->pflags &= ~ATA_PFLAG_FROZEN;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(ata_sas_port_start);
> 
> 
> -- 
> Nishanth Aravamudan <nacc@us.ibm.com>
> IBM Linux Technology Center

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
