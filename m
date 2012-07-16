Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2GPOwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:52:53 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16326 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2GPOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:52:51 -0400
Message-ID: <1342450091.3010.1.camel@misato.fc.hp.com>
Subject: RE: [PATCH] ACPI: Add ACPI CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 08:48:11 -0600
In-Reply-To: <EC847C0FC42FF046B94E60B168774B1731633B47@G9W0337.americas.hpqcorp.net>
References: <1340981479-6521-1-git-send-email-toshi.kani@hp.com>
	 <EC847C0FC42FF046B94E60B168774B1731633B47@G9W0337.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 04:53 +0000, Pandarathil, Vijaymohan R wrote:
> Hi Toshi,
> 
> Did some basic KVM guest cpu hotplug testing of this patch over your OST patchset along with fixes in qemu-kvm for guest cpu hotplug. 
> 
> Vijay
> 
> virsh # vcpucount vmb91g1
> maximum      config         4
> maximum      live           4
> current      config         4
> current      live           4
> 
> virsh # setvcpus vmb91g1 3
> 
> virsh # vcpucount vmb91g1
> maximum      config         4
> maximum      live           4
> current      config         4
> current      live           3
> 
> virsh # setvcpus vmb91g1 4
> 
> virsh # vcpucount vmb91g1
> maximum      config         4
> maximum      live           4
> current      config         4
> current      live           4
> 
> virsh #  setvcpus vmb91g1 2
> 
> virsh # vcpucount vmb91g1
> maximum      config         4
> maximum      live           4
> current      config         4
> current      live           2
> 
> The guest cpu counts (as shown by lscpu in the guest) also changes.
> 
> 
> Tested-by: Vijay Mohan Pandarathil<vijaymohan.pandarathil@hp.com>

Hi Vijay,

Great!  Thanks for the testing!

-Toshi



> 
> 
> -----Original Message-----
> From: Kani, Toshimitsu 
> Sent: Friday, June 29, 2012 7:51 AM
> To: lenb@kernel.org; linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Kani, Toshimitsu
> Subject: [PATCH] ACPI: Add ACPI CPU hot-remove support
> 
> Added CPU hot-remove support through an ACPI eject notification.
> It calls acpi_bus_hot_remove_device(), which shares the same code
> path with the sysfs eject operation.  acpi_os_hotplug_execute()
> serializes hot-remove operations between ACPI hot-remove and sysfs
> eject requests.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> ---
> This patch applies on top of the patchset below.
> 
> [PATCH v6 0/6] ACPI: Add _OST support for ACPI hotplug
> http://marc.info/?l=linux-acpi&m=134074381322973&w=2
> 
> ---
>  drivers/acpi/processor_driver.c |   27 +++++++++++++++++----------
>  1 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index f9fa1b2..a6f6bde 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -699,8 +699,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
>  static void acpi_processor_hotplug_notify(acpi_handle handle,
>  					  u32 event, void *data)
>  {
> -	struct acpi_processor *pr;
>  	struct acpi_device *device = NULL;
> +	struct acpi_eject_event *ej_event = NULL;
>  	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
>  	int result;
>  
> @@ -732,20 +732,27 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
>  				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
>  
>  		if (acpi_bus_get_device(handle, &device)) {
> -			printk(KERN_ERR PREFIX
> -				    "Device don't exist, dropping EJECT\n");
> +			pr_err(PREFIX "Device don't exist, dropping EJECT\n");
>  			break;
>  		}
> -		pr = acpi_driver_data(device);
> -		if (!pr) {
> -			printk(KERN_ERR PREFIX
> -				    "Driver data is NULL, dropping EJECT\n");
> +		if (!acpi_driver_data(device)) {
> +			pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
>  			break;
>  		}
>  
> -		/* REVISIT: update when eject is supported */
> -		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
> -		break;
> +		ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> +		if (!ej_event) {
> +			pr_err(PREFIX "No memory, dropping EJECT\n");
> +			break;
> +		}
> +
> +		ej_event->handle = handle;
> +		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> +		acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> +					(void *)ej_event);
> +
> +		/* eject is performed asynchronously */
> +		return;
>  
>  	default:
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,


