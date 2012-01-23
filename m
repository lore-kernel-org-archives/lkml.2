Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2AWPv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:51:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab2AWPv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:51:26 -0500
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/3] ACPI, APEI: Add RAM mapping support to ACPI
Cc: Myron Stowe <myron.stowe@redhat.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, rjw@sisk.pl, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
Date: Mon, 23 Jan 2012 16:51:22 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231651.23270.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please ignore my previous mail, my mailer wrongly formatted
it with html tags and it got filtered out from the lists.

Firstly: This has to get in quickly if it shouldn't miss
3.3 (again). Tiny adjustings (I don't see any, beside the
issue Bjorn brought up) can still be done later, but I
guess this rather big one gets rejected by Linus after
the merge window closed.

Here again:

On Saturday, January 21, 2012 09:38:27 PM Bjorn Helgaas wrote:
> +cc Tony, linux-ia64
> 
...
> >>  {
> >> @@ -353,7 +385,7 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
> >>
> >>        pg_off = round_down(phys, PAGE_SIZE);
> >>        pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
> >> -       virt = acpi_os_ioremap(pg_off, pg_sz);
> >> +       virt = acpi_map(pg_off, pg_sz);
Ok, that worked before, also on IA64.
That means that typically/normally/always io mem is tried to be mapped.

It's due to the new APEI infrastructure/features that ram could
get mapped via acpi_os_map_memory.

Is there any Itanium out there implementing any APEI table?
Will there ever be one?
Even if, isn't it a BIOS bug if such stuff is declared in ram and not
in reserved memory (also on X86)?
Especially on an Enterprise Itanium platform,
I guess the vendor should or better has to fix it up.

I'd do:
can_use_ioremap(pfn) instead of should_use_kmap(pfn)
and let it return false in ram + ia64 case, something like:
#ifdef IA64
#define can_use_ioremap(pfn)   !page_is_ram(pfn)
#endif

Pass the error upwards and APEI should get disabled on IA64,
if any ACPI code tries to ioremap real memory early (when
the APEI table parsing happens).
A nice FW_BUG message could be added as well (also on X86?).

Don't forget to use:
iounmap(vaddr);
only in acpi_unmap() then.

FWIW I even grepped for APEI tables on the most recent IA
machine we have -> no APEI tables.

If the rest is functionally the same as the patch series
you've send some months ago, feel free to add:

Reviewed-by: Thomas Renninger <trenn@suse.de>

I had a rather close look at those patches.

   Thomas
