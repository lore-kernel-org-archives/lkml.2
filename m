Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1FOUCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:02:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58012 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab1FOUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:02:38 -0400
Message-ID: <4DF90FCA.1040706@linux.vnet.ibm.com>
Date: Wed, 15 Jun 2011 15:02:18 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@us.ibm.com>
CC: jgarzik@pobox.com, mbizon@freebox.fr, tj@kernel.org,
        benh@kernel.crashing.org, wayneb@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: libata/ipr/powerpc: regression between 2.6.39-rc4 and 2.6.39-rc5
References: <20110615191747.GA6324@us.ibm.com>
In-Reply-To: <20110615191747.GA6324@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 02:17 PM, Nishanth Aravamudan wrote:
> From what I can tell, the only place that explicitly clears the FROZEN
> flag is the error-handling code via ata_eh_thaw_port().
> 
> So I thought either we're not invoking the error-handler at probe time
> correctly to kick the port or perhaps the SAS code is not clearing the
> flag?
> 
> I tried the following patch:
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d51f979..abd0e0b 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3797,6 +3797,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
>   */
>  int ata_sas_port_start(struct ata_port *ap)
>  {
> +       ap->pflags &= ~ATA_PFLAG_FROZEN;
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(ata_sas_port_start);
> 
> and the CD-ROM drive works, but I have no idea if it's the right thing
> to do. I chose this particular change, FWIW, because we call
> ata_sas_port_start before we probe in ata_sas_port_init and it seems
> like we need to mark the port as not frozen before we init it? Perhaps
> that should really be a call to a thaw function, not sure. Let's just
> say the ATA/SAS/SCSI interactions are a bit hard to follow at first :)

That looks like the right thing to do. For ipr's usage of
libata, we don't have the concept of a port frozen state, so this flag
should really never get set. The alternate way to fix this would be to
only set ATA_PFLAG_FROZEN in ata_port_alloc if ap->ops->error_handler
is not NULL.

Thanks,

Brian


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


