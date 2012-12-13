Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2LMSsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:48:25 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37197 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab2LMSsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:48:24 -0500
Date: Thu, 13 Dec 2012 10:48:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Amos Kong <kongjianjun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] PCI Hotplug: workaround for Thunderbolt on Intel
 DZ77RE-75K motherboard
Message-ID: <20121213184820.GC12105@kroah.com>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-4-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355412708-20046-4-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 05:31:48PM +0200, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> BIOS on Intel DZ77RE-75K motherboard notifies OS about Thunderbolt
> hotplug before devices behind Thunderbolt are ready to be enumerated.
> 
> Let's delay enumeration by 2 seconds.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 1a2b3ca..165987a 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -49,6 +49,7 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/acpi.h>
> +#include <linux/dmi.h>
>  
>  #include "../pci.h"
>  #include "acpiphp.h"
> @@ -1327,6 +1328,19 @@ out:
>  static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
>  					void *context)
>  {
> +	unsigned long delay = 0;
> +	const char *board_name;
> +
> +	board_name = dmi_get_system_info(DMI_BOARD_NAME);
> +	/*
> +	 * BIOS on Intel DZ77RE-75K motherboard notifies OS about Thunderbolt
> +	 * hotplug before devices behind Thunderbolt are ready to be
> +	 * enumerated.
> +	 * Let's delay enumeration by 2 seconds.
> +	 */
> +	if (board_name && !strcmp(board_name, "DZ77RE-75K"))
> +		delay = 2 * HZ;

Again, no objection to this patch as-is, but should we make it a bit
more "general" and provide a quirk table to make this type of fix easier
for other motherboards?  Shouldn't we also match on a manufacturer field
as well as the board_name?  The kernel provides a very easy to match on
any arbritary set of DMI fields for this kind of problem that we could
use here.

I can make that change if needed.

What are the odds that other boards are going to need a longer delay
time?  Actually, is there a spec saying how long we need to wait?  The
ACPI PCI Hotplug had a value somewhere that the hardware was supposed to
follow, but I don't have access to that ACPI spec anymore to verify
this...

thanks,

greg k-h
