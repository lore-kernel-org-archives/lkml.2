Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2LNAWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:22:49 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:59399 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab2LNAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:22:47 -0500
MIME-Version: 1.0
In-Reply-To: <1355412708-20046-2-git-send-email-kirill.shutemov@linux.intel.com>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-2-git-send-email-kirill.shutemov@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 13 Dec 2012 17:22:25 -0700
Message-ID: <CAErSpo5eFhpHwnYZvfXPLJ3hnViFXLtgkGXaGR2xNsVaSg0CKw@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI Hotplug: workaround for Thunderbolt on Acer
 Aspire S5
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael]

On Thu, Dec 13, 2012 at 8:31 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
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
>         status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
>         if (ACPI_SUCCESS(status) && removable)
>                 return 1;
> +
> +       /*
> +        * Workaround for Thunderbolt implementation on Acer Aspire S5.
> +        *
> +        * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
> +        * slot (device under pci bridge). In Acer Aspire S5 case we have it
> +        * deeper in hierarchy.
> +        */
> +       status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
> +                       &removable);

I don't think encoding an ACPI path from the BIOS of a random machine
here is the right approach.  The path components are completely
implementation-dependent, and we'll end up carrying this test forever,
long after the last Aspire S5 is in the landfill.

We need a more generic approach that covers this case.  It would be
interesting to see the rest of the ACPI namespace details under
RP05.HRUP.  I guess we have RP05.HRUP._ADR, at least.  I'm not sure
what the BIOS is trying to tell us by providing
RP05.HRUP.HRDN.EPUP._RMV, but maybe we could figure it out if we knew
more about HRDN and EPUP.

> +       if (ACPI_SUCCESS(status) && removable)
> +               return 1;
> +
>         return 0;
>  }
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
