Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2DWBJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 21:09:49 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:31773
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab2DWBJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 21:09:47 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz1803M1432N98dKzz1202hzz8275bhz2dh668h839h944hd25hd2bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2WR83-01-QHV-02
X-M-MSG: 
Date: Mon, 23 Apr 2012 09:09:31 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Len Brown <lenb@kernel.org>, "Rafeal J. Wysocki" <rjw@sisk.pl>,
        Lin Ming <ming.m.lin@intel.com>
CC: <linux-acpi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Message-ID: <20120423010929.GA13246@ladygaga>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-OriginalArrivalTime: 23 Apr 2012 01:09:33.0637 (UTC) FILETIME=[BE57B750:01CD20ED]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael and Ming,

Do you have any more comments on this patch?
If not, can I have your ack? Thanks.

-Aaron

On Sun, Apr 01, 2012 at 02:18:30AM +0800, Aaron Lu wrote:
> When entering D3 Cold from a higher device state, evaluate _PS3 first
> and then make the proper power transition.
> This is used to solve the ZPODD problem on AMD's platform, _PS3 on such
> platforms will power off the ODD device and thus make the device enter
> D3 cold state.
> 
> Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> Cc: Andiry Xu <andiry.xu@amd.com>
> Cc: Alex He <alex.he@amd.com>
> ---
>  drivers/acpi/bus.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 3263b68..68e593f 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -227,6 +227,8 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
>  	int result = 0;
>  	acpi_status status = AE_OK;
>  	char object_name[5] = { '_', 'P', 'S', '0' + state, '\0' };
> +	struct acpi_device_power_state *ps;
> +	u8 explicit_set;
>  
>  	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
>  		return -EINVAL;
> @@ -239,7 +241,8 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
>  		return 0;
>  	}
>  
> -	if (!device->power.states[state].flags.valid) {
> +	ps = &device->power.states[state];
> +	if (!ps->flags.valid) {
>  		printk(KERN_WARNING PREFIX "Device does not support D%d\n", state);
>  		return -ENODEV;
>  	}
> @@ -263,7 +266,7 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
>  			if (result)
>  				goto end;
>  		}
> -		if (device->power.states[state].flags.explicit_set) {
> +		if (ps->flags.explicit_set) {
>  			status = acpi_evaluate_object(device->handle,
>  						      object_name, NULL, NULL);
>  			if (ACPI_FAILURE(status)) {
> @@ -272,7 +275,15 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
>  			}
>  		}
>  	} else {
> -		if (device->power.states[state].flags.explicit_set) {
> +		/* If state is D3 Cold, try to evaluate _PS3 first */
> +		if (state == ACPI_STATE_D3_COLD) {
> +			explicit_set = (ps - 1)->flags.explicit_set;
> +			object_name[3] -= 1;
> +		}
> +		else {
> +			explicit_set = ps->flags.explicit_set;
> +		}
> +		if (explicit_set) {
>  			status = acpi_evaluate_object(device->handle,
>  						      object_name, NULL, NULL);
>  			if (ACPI_FAILURE(status)) {
> -- 
> 1.7.9.2.315.g25a78.dirty
> 

