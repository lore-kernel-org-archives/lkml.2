Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2BWUvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:51:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64628 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab2BWUvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:51:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.216.139.165 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <20120223122536.6a2a7a6b@jbarnes-desktop>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
 <1328425088-6562-10-git-send-email-yinghai@kernel.org> <CAErSpo6BwznWf3rq4J2Ao+rrgR4yWqQ0mQGygkd2KmBuA1OD8g@mail.gmail.com>
 <1328738567.2903.45.camel@pasglop> <CAErSpo7ekGn-+Mnyz7KL=fVFH3Ed19AeE3MKkZWJ4bd0Jo7kCw@mail.gmail.com>
 <1328823358.2903.77.camel@pasglop> <20120223122536.6a2a7a6b@jbarnes-desktop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 23 Feb 2012 12:51:30 -0800
Message-ID: <CAErSpo7_WGjitDZz4XH+77f65Uz1ynd5_USN+D17D09Eux1iQQ@mail.gmail.com>
Subject: Re: [PATCH 09/24] PCI, powerpc: Register busn_res for root buses
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 12:25 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Fri, 10 Feb 2012 08:35:58 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
>> On Thu, 2012-02-09 at 11:24 -0800, Bjorn Helgaas wrote:
>> > My point is that the interface between the arch and the PCI core
>> > should be simply the arch telling the core "this is the range of bus
>> > numbers you can use."  If the firmware doesn't give you the HW limits,
>> > that's the arch's problem.  If you want to assume 0..255 are
>> > available, again, that's the arch's decision.
>> >
>> > But the answer to the question "what bus numbers are available to me"
>> > depends only on the host bridge HW configuration.  It does not depend
>> > on what pci_scan_child_bus() found.  Therefore, I think we can come up
>> > with a design where pci_bus_update_busn_res_end() is unnecessary.
>>
>> In an ideal world yes. In a world where there are reverse engineered
>> platforms on which we aren't 100% sure how thing actually work under the
>> hood and have the code just adapt on "what's there" (and try to fix it
>> up -sometimes-), thinks can get a bit murky :-)
>>
>> But yes, I see your point. As for what is the "correct" setting that
>> needs to be done so that the patch doesn't end up a regression for us,
>> I'll have to dig into some ancient HW to dbl check a few things. I hope
>> 0...255 will just work but I can't guarantee it.
>>
>> What I'll probably do is constraint the core to the values in
>> hose->min/max, and update selected platforms to put 0..255 in there when
>> I know for sure they can cope.
>
> But I think the point is, can't we intiialize the busn resource after
> the first & last bus numbers have been determined?  E.g. rather than
> Yinghai's current:
> +       pci_bus_insert_busn_res(bus, hose->first_busno, hose->last_busno);
> +
>        /* Get probe mode and perform scan */
>        mode = PCI_PROBE_NORMAL;
>        if (node && ppc_md.pci_probe_mode)
> @@ -1742,8 +1744,11 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
>                of_scan_bus(node, bus);
>        }
>
> -       if (mode == PCI_PROBE_NORMAL)
> +       if (mode == PCI_PROBE_NORMAL) {
> +               pci_bus_update_busn_res_end(bus, 255);
>                hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
> +               pci_bus_update_busn_res_end(bus, bus->subordinate);
> +       }
>
> we'd have something more like:
>
>        /* Get probe mode and perform scan */
>        mode = PCI_PROBE_NORMAL;
>        if (node && ppc_md.pci_probe_mode)
> @@ -1742,8 +1744,11 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
>                of_scan_bus(node, bus);
>        }
>
>        if (mode == PCI_PROBE_NORMAL)
>                hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
>
> +       pci_bus_insert_busn_res(bus, hose->first_busno, hose->last_busno);
>
> since we should have the final bus range by then?  Setting the end to
> 255 and then changing it again doesn't make sense; and definitely makes
> the code hard to follow.

I have two issues here:

1) hose->last_busno is currently the highest bus number found by
pci_scan_child_bus().  If I understand correctly,
pci_bus_insert_busn_res() is supposed to update the core's idea of the
host bridge's bus number aperture.  (Actually, I guess it just updates
the *end* of the aperture, since we supply the start directly to
pci_scan_root_bus()).  The aperture and the highest bus number we
found are not related, except that we should have:

    hose->first_busno <= bus->subordinate <= hose->last_busno

If we set the aperture to [first_busno - last_busno], we artificially
prevent some hotplug.

2) We already have a way to add resources to a root bus: the
pci_add_resource() used to add I/O port and MMIO apertures.  I think
it'd be a lot simpler to just use that same interface for the bus
number aperture, e.g.,

    pci_add_resource(&resources, hose->io_space);
    pci_add_resource(&resources, hose->mem_space);
    pci_add_resource(&resources, hose->busnr_space);
    bus = pci_scan_root_bus(dev, next_busno, pci_ops, sysdata, &resources);

This is actually a bit redundant, since "next_busno" should be the
same as hose->busnr_space->start.  So if we adopted this approach, we
might want to eventually drop the "next_busno" argument.

 Bjorn
