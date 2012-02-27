Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2B0WpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:45:07 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44226 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab2B0WpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:45:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.216.139.165 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXx6wXaes1pbpM7SAHzndgr=N2D2g6LEWsB2_pf8+mgSA@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
 <1328425088-6562-10-git-send-email-yinghai@kernel.org> <CAErSpo6BwznWf3rq4J2Ao+rrgR4yWqQ0mQGygkd2KmBuA1OD8g@mail.gmail.com>
 <1328738567.2903.45.camel@pasglop> <CAErSpo7ekGn-+Mnyz7KL=fVFH3Ed19AeE3MKkZWJ4bd0Jo7kCw@mail.gmail.com>
 <1328823358.2903.77.camel@pasglop> <20120223122536.6a2a7a6b@jbarnes-desktop>
 <CAErSpo7_WGjitDZz4XH+77f65Uz1ynd5_USN+D17D09Eux1iQQ@mail.gmail.com>
 <20120224142430.58f5e5ef@jbarnes-desktop> <CAE9FiQXx6wXaes1pbpM7SAHzndgr=N2D2g6LEWsB2_pf8+mgSA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Feb 2012 15:44:42 -0700
Message-ID: <CAErSpo4YvyAhG1dCmtVhqNpCLj2oF4tCQ+UpU0oQYrG0nw+-ug@mail.gmail.com>
Subject: Re: [PATCH 09/24] PCI, powerpc: Register busn_res for root buses
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
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

On Sat, Feb 25, 2012 at 12:47 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Feb 24, 2012 at 2:24 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Thu, 23 Feb 2012 12:51:30 -0800
>> Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> 2) We already have a way to add resources to a root bus: the
>>> pci_add_resource() used to add I/O port and MMIO apertures.  I think
>>> it'd be a lot simpler to just use that same interface for the bus
>>> number aperture, e.g.,
>>>
>>>     pci_add_resource(&resources, hose->io_space);
>>>     pci_add_resource(&resources, hose->mem_space);
>>>     pci_add_resource(&resources, hose->busnr_space);
>>>     bus = pci_scan_root_bus(dev, next_busno, pci_ops, sysdata, &resources);
>>>
>>> This is actually a bit redundant, since "next_busno" should be the
>>> same as hose->busnr_space->start.  So if we adopted this approach, we
>>> might want to eventually drop the "next_busno" argument.
>>
>> Yeah that would be nice, the call would certainly make more sense that
>> way.
>
> no, I don't think so.
>
> using pci_add_resource will need to create dummy resource abut bus range.

I don't see the problem here.  The bus number aperture is a
fundamental property of a host bridge, and any firmware or native
bridge driver that tells you about a bridge but doesn't tell you the
bus number aperture is just broken.

Every arch already has struct resources for the MMIO and IO port
regions available on the bus.  ACPI already has a resource for the bus
number range.  It makes sense to me that the arch should supply a bus
number resource.

Conceptually, it's just like the MMIO and IO resources, so it makes
sense to me that the code for bus numbers should look like the code
for MMIO and IO ports.

> there is lots of pci_scan_root_bus(),  and those user does not bus end
> yet before scan.
> so could just hide pci_insert_busn_res in pci_scan_root_bus, and
> update busn_res end there.

pci_scan_child_bus() does NOT tell you the end of the bus number
aperture, and we shouldn't pretend that it does.  It might give you a
lower bound on the end of the aperture (as long as you're willing to
trust the current PCI config and you don't change anything).

> other arch like x86, ia64, powerpc, sparc, will insert exact bus range
> between pci_create_root_bus and
> pci_scan_child_bus, will not need to update busn_res end.
>
> please check v7 of this patchset.
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-busn-alloc

I looked at your git tree, but I can't tell whether what's there is v7
or not and it's too much trouble to try to figure it out.

Bjorn
