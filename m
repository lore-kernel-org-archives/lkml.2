Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1JKAqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:46:47 -0400
Received: from dns1.mips.com ([12.201.5.69]:60804 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab1JKAqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:46:46 -0400
X-Greylist: delayed 3242 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Oct 2011 20:46:45 EDT
From: "Zhu, DengCheng" <dczhu@mips.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        "dengcheng.zhu@gmail.com" <dengcheng.zhu@gmail.com>
Subject: RE: [RESEND PATCH v3 0/2] Pass resources to pci_create_bus() and
 fix MIPS PCI resources
Thread-Topic: [RESEND PATCH v3 0/2] Pass resources to pci_create_bus() and
 fix MIPS PCI resources
Thread-Index: AQHMaFGlI7Hp27+M00OrntK+WpTVnJVyGw+AgASqA4D//68aHQ==
Date: Mon, 10 Oct 2011 23:49:06 +0000
Message-ID: <BD04AF0D5BE72443A0B69C1C0486AD3ECE8D8973@exchdb03.mips.com>
References: <1314845309-3277-1-git-send-email-dczhu@mips.com>
 <CAErSpo5py82G1=6BOTG4RSAj6_SRzN4fng6sECU2sS+u9quixw@mail.gmail.com>,<CAErSpo5HNKi7NSKBbyL3o39Ow+Xkncyccrj5PQNaoeMdLHJsFQ@mail.gmail.com>
In-Reply-To: <CAErSpo5HNKi7NSKBbyL3o39Ow+Xkncyccrj5PQNaoeMdLHJsFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.36.79]
x-ems-proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
x-ems-stamp: iiay/VHfaASoyHWbbhfuEw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/11 Bjorn Helgaas <bhelgaas@google.com>
>
> On Fri, Oct 7, 2011 at 3:50 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Wed, Aug 31, 2011 at 8:48 PM, Deng-Cheng Zhu <dczhu@mips.com> wrote:
> >> (Resending the patch set to include more arch maintainers.)
> >>
> >> Change the pci_create_bus() interface to pass in available resources to get them
> >> settled down early. This is to avoid possible resource conflicts while doing
> >> pci_scan_slot() in pci_scan_child_bus(). Note that pcibios_fixup_bus() can get
> >> rid of such conflicts, but it's done AFTER scanning slots.
> >>
> >> In addition, MIPS PCI resources are now fixed using this new interface.
> >
> > Jesse, I assume these are headed for the 3.2 merge window, right?
>
> I tried to build on these patches to convert x86 to using the new
> pci_create_bus() interface, but I couldn't figure out a nice way to
> handle an arbitrary number of resources.
>
> We made pci_create_bus() take a "struct pci_bus_resource *"
> (https://lkml.org/lkml/2011/8/26/88):
>
>    struct pci_bus *pci_create_bus(struct device *parent, int bus,
>                               struct pci_ops *ops, void *sysdata,
>                               struct pci_bus_resource *bus_res);
>
> Where pci_bus_resource looks like this:
>
>    struct pci_bus_resource {
>        struct list_head list;
>        struct resource *res;
>        unsigned int flags;
>    };
>
> Conceptually, we're passing a list of resources to pci_create_bus(),
> which I think is the right thing.  But I think the best way to do that
> is by passing a pointer to a struct list_head, not a pointer to a
> pci_bus_resource.
>
> If we pass a pci_bus_resource, we're basically using that as a
> container for a list (as per include/linux/list.h), but it's not a
> well-formed list.  Normally a list contains one list_head per element,
> plus an extra list_head for the head of the list.  There's a nice
> drawing on page 296 of http://lwn.net/images/pdf/LDD3/ch11.pdf.
>
> The list built in your MIPS patch (https://lkml.org/lkml/2011/8/26/89)
> consists of two pci_bus_resource structs (each with a list_head), but
> there's no third list_head for the head of the list.  I think if you
> tried to use list_for_each_entry() to iterate through the list, it
> would not work correctly.
>
> I'll post a slightly modified series to show what I mean.  Take a look
> and see if it makes sense to you.

Yes, I can easily understand what you mean, because this point was ever
considered while writing this patch series. We pass the element list as
opposed to a list_head for the head of the element list because we simply
want to link the elements into pci_bus->resources in pci_create_bus(). This
can be done by a single line:
    list_add_tail(&b->resources, &bus_res->list);

In addition, if we need to do list_for_each_entry() on the list, our target
should always be pci_bus->resources rather than the pci_bus_resource list
which is passed into pci_create_bus() to be part (the meat) of
pci_bus->resources.


Deng-Cheng




