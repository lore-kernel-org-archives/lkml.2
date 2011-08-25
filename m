Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1HYQKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:10:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1HYQKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:10:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=yaotez9k1m6Xi/Jj2McGi3OpAKe/bRmKv/BCU1JNTkPdvcgZqFc1XUF28rTsUP6Mt
	oyngjAHy7Y84y6GHpYCzw==
MIME-Version: 1.0
In-Reply-To: <1314271117-32717-3-git-send-email-dczhu@mips.com>
References: <1314271117-32717-1-git-send-email-dczhu@mips.com> <1314271117-32717-3-git-send-email-dczhu@mips.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Aug 2011 10:09:48 -0600
Message-ID: <CAErSpo5n-FJXwOd2h179tctw2LX0bZ7xcyxU5Mam+tmVoqgprw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] MIPS: PCI: Pass controller's resources to
 pci_create_bus() in pcibios_scanbus()
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com, dengcheng.zhu@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 5:18 AM, Deng-Cheng Zhu <dczhu@mips.com> wrote:
> Use the new interface of pci_create_bus() so that system controller's
> resources are added to the root bus upon bus creation, thereby avoiding
> conflicts with PCI quirks before pcibios_fixup_bus() gets the chance to do
> right things in pci_scan_child_bus(). Also, since we are passing resources
> to pci_create_bus() and setting them up in the bus->resources list as
> opposed to the bus->resource[] array, we have to adopt the list style while
> doing bus fixups later on, or else, for example in this MIPS case, system
> controller's resources will stay in both bus->resources and
> bus->resource[].

> +static void __devinit
> +pcibios_setup_root_resources(struct pci_bus *bus, struct pci_controller *ctrl)
> +{
> +       pci_bus_remove_resources(bus);
> +       pci_bus_add_resource(bus, ctrl->io_resource, 0);
> +       pci_bus_add_resource(bus, ctrl->mem_resource, 0);
> +}
> +
>  void __devinit pcibios_fixup_bus(struct pci_bus *bus)
>  {
>        /* Propagate hose info into the subordinate devices.  */
> @@ -269,10 +313,9 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
>        struct list_head *ln;
>        struct pci_dev *dev = bus->self;
>
> -       if (!dev) {
> -               bus->resource[0] = hose->io_resource;
> -               bus->resource[1] = hose->mem_resource;
> -       } else if (pci_probe_only &&
> +       if (!dev)
> +               pcibios_setup_root_resources(bus, hose);

As I mentioned in my other response, I think you can just drop this
whole "if (!dev)" block since the root bus resources should already be
correct.  There's no need to move them from the bus->resource[] array
to the bus->resources list.

Someday, if all arches adopt your nice pci_create_bus() extension to
make root bus resources correct from the beginning, there should be no
arch references to the bus->resource[] array left, and then we can
remove it altogether.  At least, that's what I was hoping when I added
the list :)

In any case, all the *readers* of bus resources already use the
pci_bus_for_each_resource() interface, which knows how to look at both
the array and the list.

Bjorn
