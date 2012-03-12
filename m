Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2CLCDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:03:13 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:32615
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab2CLCDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:03:04 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0R1OW-02-H32-02
X-M-MSG: 
Date: Mon, 12 Mar 2012 10:02:50 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>, <"@ladygaga"@domain.invalid>
CC: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH v2 4/8] libata-acpi: set acpi state for SATA port
Message-ID: <20120312020249.GC2820@ladygaga>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
 <1330592577-16546-5-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330592577-16546-5-git-send-email-ming.m.lin@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Mar 2012 02:02:50.0342 (UTC) FILETIME=[3A60B060:01CCFFF4]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 01, 2012 at 05:02:53PM +0800, Lin Ming wrote:
> Currently, ata_acpi_set_state() only sets acpi sate for IDE port.
> Remove this limitation.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/ata/libata-acpi.c |   21 ++++++++++++---------
>  1 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index b03e468..104c1d0 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -841,23 +841,26 @@ void ata_acpi_on_resume(struct ata_port *ap)
>  void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
>  {
>  	struct ata_device *dev;
> -
> -	if (!ata_ap_acpi_handle(ap) || (ap->flags & ATA_FLAG_ACPI_SATA))
> -		return;
> +	acpi_handle handle;
> +	int acpi_state;
>  
>  	/* channel first and then drives for power on and vica versa
>  	   for power off */
> -	if (state.event == PM_EVENT_ON)
> -		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D0);
> +	handle = ata_ap_acpi_handle(ap);
> +	if (handle && state.event == PM_EVENT_ON)
> +		acpi_bus_set_power(handle, ACPI_STATE_D0);
>  
>  	ata_for_each_dev(dev, &ap->link, ENABLED) {
> -		if (ata_dev_acpi_handle(dev))
> -			acpi_bus_set_power(ata_dev_acpi_handle(dev),
> +		handle = ata_dev_acpi_handle(dev);
> +		if (handle)
> +			acpi_bus_set_power(handle,
>  				state.event == PM_EVENT_ON ?
>  					ACPI_STATE_D0 : ACPI_STATE_D3);
>  	}
> -	if (state.event != PM_EVENT_ON)
> -		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D3);
> +
> +	handle = ata_ap_acpi_handle(ap);
> +	if (handle && state.event != PM_EVENT_ON)
> +		acpi_bus_set_power(handle, ACPI_STATE_D3);
>  }
>  
>  /**

Acked-by: Aaron Lu <aaron.lu@amd.com>

> -- 
> 1.7.2.5
> 
> 

