Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2CEQOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:14:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62781 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2CEQO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:14:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.112.45.104 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1330918440.11728.87.camel@pasglop>
References: <20120302170638.3d172369d04335d9b921a28c@canb.auug.org.au>
 <CAErSpo6xQa4Rnv+RkkXCRjQ2HDZdBhorRv2c6pmWyXqRzhM4Vw@mail.gmail.com>
 <1330725132.11728.52.camel@pasglop> <1330918440.11728.87.camel@pasglop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Mar 2012 09:14:07 -0700
Message-ID: <CAErSpo6g8QyEhu6YRsv6-mpQoO0mymuE2Fu6v=qqS=OLV19GFA@mail.gmail.com>
Subject: Re: linux-next: boot failure for next-20120227 and later (pci tree related)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 8:34 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Sat, 2012-03-03 at 08:52 +1100, Benjamin Herrenschmidt wrote:
>
>> Or give me a chance to dig :-) I'll have a look next week.
>
> This is indeed what bjorn suspected on irc, this patch fixes it:
>
> (Bjorn, please fold it in the original offending patch)

Thanks for checking this out.  Sparc should have the same problem, so
I'll post both updates in a bit.

Bjorn

> diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
> index b37d0b5..5dd63f1 100644
> --- a/arch/powerpc/kernel/pci_of_scan.c
> +++ b/arch/powerpc/kernel/pci_of_scan.c
> @@ -75,6 +75,7 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
>  {
>        u64 base, size;
>        unsigned int flags;
> +       struct pci_bus_region region;
>        struct resource *res;
>        const u32 *addrs;
>        u32 i;
> @@ -106,10 +107,12 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
>                        printk(KERN_ERR "PCI: bad cfg reg num 0x%x\n", i);
>                        continue;
>                }
> -               res->start = base;
> -               res->end = base + size - 1;
> +
>                res->flags = flags;
>                res->name = pci_name(dev);
> +               region.start = base;
> +               region.end = base + size - 1;
> +               pcibios_bus_to_resource(dev, res, &region);
>        }
>  }
>
> @@ -209,6 +212,7 @@ void __devinit of_scan_pci_bridge(struct pci_dev *dev)
>        struct pci_bus *bus;
>        const u32 *busrange, *ranges;
>        int len, i, mode;
> +       struct pci_bus_region region;
>        struct resource *res;
>        unsigned int flags;
>        u64 size;
> @@ -270,9 +274,10 @@ void __devinit of_scan_pci_bridge(struct pci_dev *dev)
>                        res = bus->resource[i];
>                        ++i;
>                }
> -               res->start = of_read_number(&ranges[1], 2);
> -               res->end = res->start + size - 1;
>                res->flags = flags;
> +               region.start = of_read_number(&ranges[1], 2);
> +               region.end = region.start + size - 1;
> +               pcibios_bus_to_resource(dev, res, &region);
>        }
>        sprintf(bus->name, "PCI Bus %04x:%02x", pci_domain_nr(bus),
>                bus->number);
>
>
