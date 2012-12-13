Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab2LMSoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:44:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54981 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2LMSop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:44:45 -0500
Date: Thu, 13 Dec 2012 10:44:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI Hotplug: workaround for Thunderbolt on Acer
 Aspire S5
Message-ID: <20121213184441.GB12105@kroah.com>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-2-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355412708-20046-2-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 05:31:46PM +0200, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Correct ACPI PCI hotplug imeplementation should have _RMV method in a
> PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
> deeper in hierarchy:
> 
> Device (RP05)
> {
>    // ...
>    Device (HRUP)
>    {
>        // ...
>        Device (HRDN)
>        {
>            // ...
>            Device (EPUP)
>            {
>                // ...
>                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
>                {
>                    Return (One)
>                }
>            }
>        }
>    }
> }
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  drivers/pci/hotplug/acpi_pcihp.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> index 2a47e82..d92ebfb 100644
> --- a/drivers/pci/hotplug/acpi_pcihp.c
> +++ b/drivers/pci/hotplug/acpi_pcihp.c
> @@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
>  	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
>  	if (ACPI_SUCCESS(status) && removable)
>  		return 1;
> +
> +	/*
> +	 * Workaround for Thunderbolt implementation on Acer Aspire S5.
> +	 *
> +	 * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
> +	 * slot (device under pci bridge). In Acer Aspire S5 case we have it
> +	 * deeper in hierarchy.
> +	 */
> +	status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
> +			&removable);
> +	if (ACPI_SUCCESS(status) && removable)
> +		return 1;

I have no objection to this patch as-is, but I wonder how will other
BIOSes implement this "incorrectly" in the future.  Should we always
just try to walk the whole PCI slot heirachy looking for the _RMV
attribute?  That should solve the problem where someone else places this
at another location for the slot, right?

Is there any test for Windows that ensures that this gets placed in the
"correct" location that we can rely on?

thanks,

greg k-h
