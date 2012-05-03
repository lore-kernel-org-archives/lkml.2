Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2ECJIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:08:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37125 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab2ECJIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:08:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7RNLdP4sRfg_3NE78rbvKM5HyRrApmLSLJOA8ggX=VvQ@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
	<CAErSpo7RNLdP4sRfg_3NE78rbvKM5HyRrApmLSLJOA8ggX=VvQ@mail.gmail.com>
Date: Thu, 3 May 2012 02:08:29 -0700
X-Google-Sender-Auth: cdvqygUAjuGcbceqCF7MQQ_dLzo
Message-ID: <CAE9FiQWEdsB4YEs+oueyGm99Umi0p4jYaEDEnwsHi5mgYGXBJA@mail.gmail.com>
Subject: Re: [PATCH -v11 00/30] PCI: allocate pci bus num range for unassigned
 bridge busn
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 2:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sun, Mar 18, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Set up iobusn_resource tree, and register bus number range to it.
>> Later when need to find bus range, will try to allocate from the tree
>>
>> Need to test on arches other than x86. esp for ia64 and powerpc that support
>>  more than on peer root buses.
>>
>> The patches need to apply to linux v3.3 + pci-next and
>>        [PATCH -v3] PCI: pci_host_bridge related cleanup
>>
>> could be found at:
>>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc
>
> I started merging this series, but I didn't get very far.  I stopped
> at the "resources: Add probe_resource()" patch because I don't think
> that interface makes sense yet.  My work-in-progress is at
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git on the
> topic/yinghai-busn-alloc branch.
>
> I *could* merge that branch, but I don't think they fix anything (that
> would come in the later patches), and there are still some issues in
> my mind.
>
>  - I think we really want a [bus 00-ff] resource for each *domain*,
> with each host bridge in the domain requesting part of that range.  I
> think these patches only track bus number usage within each host
> bridge, and I'm not sure there's any place we would detect conflicts
> between host bridges.

I updated the patch set a bit. now it have domain busn_res.

It could detect the conflicts. later could add code to resolve the conflicts.

int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
{
        struct resource *res = &b->busn_res;
        struct resource *parent_res;
        int ret;

        res->start = bus;
        res->end = bus_max;
        res->flags = IORESOURCE_BUS;

        if (!pci_is_root_bus(b))
                parent_res = &b->parent->busn_res;
        else {
                parent_res = get_pci_domain_busn_res(pci_domain_nr(b));
                res->flags |= IORESOURCE_PCI_FIXED;
        }

        ret = insert_resource(parent_res, res);

        dev_printk(KERN_DEBUG, &b->dev,
                        "busn_res: %pR %s inserted under %s %pR\n",
                        res, ret ? "can not be" : "is",
                        pci_is_root_bus(b) ? "domain":"", parent_res);

        return ret;
}


>
>  - I think I made a mistake in the pci_create_root_bus() and
> pci_scan_root_bus() interfaces.  They currently take a bus number and
> a list of resources, and we expect the arch to include the bus number
> aperture in the list.  The bus number argument should have been
> replaced with a bus number aperture resource.  The bus number aperture
> is essential, while the MMIO/IO aperture list may be empty.  And it's
> stupid to pass both the starting bus number and a bus resource that
> contains the starting bus number.  Fixing this would make some of
> these patches quite a bit simpler.

Yes, could try to address that later to make it more clean.

>  - In some of the arches (sparc, powerpc), you added a bus number
> resource right next to existing first_busno, last_busno fields.  So
> now that data lives two places, which will bite us later.

then later we should kill first_busno and last_busno in those arches.

Yinghai
