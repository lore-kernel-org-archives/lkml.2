Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1HYG4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:56:17 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49664 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1HYG4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:56:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo56V1eHaLTz72gLHcdONsNSUM01upKr4K+DtoU58ea5Ag@mail.gmail.com>
References: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
	<1314167063-15785-3-git-send-email-dengcheng.zhu@gmail.com>
	<CAErSpo56V1eHaLTz72gLHcdONsNSUM01upKr4K+DtoU58ea5Ag@mail.gmail.com>
Date: Thu, 25 Aug 2011 14:56:15 +0800
Message-ID: <CAOfQC9_S9q9fE6VyDaLseUFZD_GxZcEOYw8YsvRWkr9-2S=RRQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] PCI: Pass available resources into pci_create_bus()
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/24 Bjorn Helgaas <bhelgaas@google.com>:
> I like this approach a lot.  Thanks for working it up.  It's a nice
> small change with very little impact to other architectures, and you
> have a nice clear changelog.  You might mention something about the
> fact that by default, the bus starts out with all of ioport_resource
> and iomem_resource -- that will mean something to people who know how
> host bridges work.

Thanks! And I'll add this info to the patch description.

> Using pci_bus_add_resource() here *seems* like it should be the right
> thing, but I don't think it will work correctly.
>
> The problem is that struct pci_bus has both a table of resources
> (bus->resource[]) *and* a list (bus->resources).
> pci_bus_add_resource() always puts the new resource on the list, but
> various arch code still references the table directly, e.g., sparc has
> "pbus->resource[0] = &pbm->io_space" in pcibios_fixup_bus().
>
> As written, I think this patch will break sparc because the host
> bridge will end up with both pbm->io_space (in the table) and
> ioport_resource (in the list).

Good catch! I overlooked this point.

> I think something like this would work, though:
>
>    if (bus_res)
>        list_add_tail(&b->resources, &bus_res->list);
>    else {
>        b->resource[0] = &ioport_resource;
>        b->resource[1] = &iomem_resource;
>    }

Yes, it should work.


Thanks again for your time,

Deng-Cheng
