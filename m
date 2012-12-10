Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2LJVOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:14:25 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33305 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2LJVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:14:23 -0500
MIME-Version: 1.0
In-Reply-To: <c6f38a8b22d0bf2980785a2f9a786ba4616a3284.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com> <c6f38a8b22d0bf2980785a2f9a786ba4616a3284.1352719877.git.jang@linux.vnet.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Dec 2012 14:14:01 -0700
Message-ID: <CAErSpo7h_EnqWzx7TN9yr5JnmUjLcZSv=pkc+Cz=8egF+EcyXQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/10] s390/pci: base support
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 2:41 AM, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> Add PCI support for s390, (only 64 bit mode is supported by hardware):
> - PCI facility tests
> - PCI instructions: pcilg, pcistg, pcistb, stpcifc, mpcifc, rpcit
> - map readb/w/l/q and writeb/w/l/q to pcilg and pcistg instructions
> - pci_iomap implementation
> - memcpy_fromio/toio
> - pci_root_ops using special pcilg/pcistg
> - device, bus and domain allocation
>
> Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>

I think these patches are in -next already, so I just have some
general comments & questions.

My overall impression is that these are exceptionally well done.
They're easy to read, well organized, and well documented.  It's a
refreshing change from a lot of the stuff that's posted.

As with other arches that run on top of hypervisors, you have
arch-specific code that enumerates PCI devices using hypervisor calls,
and you hook into the PCI core at a lower level than
pci_scan_root_bus().  That is, you call pci_create_root_bus(),
pci_scan_single_device(), pci_bus_add_devices(), etc., directly from
the arch code.  This is the typical approach, but it does make more
dependencies between the arch code and the PCI core than I'd like.

Did you consider hiding any of the hypervisor details behind the PCI
config accessor interface?  If that could be done, the overall
structure might be more similar to other architectures.

The current config accessors only work for dev/fn 00.0 (they fail when
"devfn != ZPCI_DEVFN").  Why is that?  It looks like it precludes
multi-function devices and basically prevents you from building an
arbitrary PCI hierarchy.

zpci_map_resources() is very unusual.  The struct pci_dev resource[]
table normally contains CPU physical addresses, but
zpci_map_resources() fills it with virtual addresses.  I suspect this
has something to do with the "BAR spaces are not disjunctive on s390"
comment.  It almost sounds like that's describing host bridges where
the PCI bus address is not equal to the CPU physical address -- in
that case, device A and device B may have the same values in their
BARs, but they can still be distinct if they're under host bridges
that apply different CPU-to-bus address translations.

Bjorn
