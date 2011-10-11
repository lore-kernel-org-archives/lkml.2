Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1JKHxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:53:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:48416 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1JKHxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:53:17 -0400
Subject: RE: [RESEND PATCH v3 0/2] Pass resources to pci_create_bus() and
 fix MIPS PCI resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Zhu, DengCheng" <dczhu@mips.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
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
In-Reply-To: <BD04AF0D5BE72443A0B69C1C0486AD3ECE8D8973@exchdb03.mips.com>
References: <1314845309-3277-1-git-send-email-dczhu@mips.com>
	 <CAErSpo5py82G1=6BOTG4RSAj6_SRzN4fng6sECU2sS+u9quixw@mail.gmail.com>
	 ,<CAErSpo5HNKi7NSKBbyL3o39Ow+Xkncyccrj5PQNaoeMdLHJsFQ@mail.gmail.com>
	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8D8973@exchdb03.mips.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 09:48:15 +0200
Message-ID: <1318319295.29415.452.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 23:49 +0000, Zhu, DengCheng wrote:
> Yes, I can easily understand what you mean, because this point was ever
> considered while writing this patch series. We pass the element list as
> opposed to a list_head for the head of the element list because we simply
> want to link the elements into pci_bus->resources in pci_create_bus(). This
> can be done by a single line:
>     list_add_tail(&b->resources, &bus_res->list);
> 
> In addition, if we need to do list_for_each_entry() on the list, our target
> should always be pci_bus->resources rather than the pci_bus_resource list
> which is passed into pci_create_bus() to be part (the meat) of
> pci_bus->resources. 

I must admit I don't completely understand what this patch is about,
other than it will most probably break the way we do resource management
on powerpc :-)

I don't understand the point about conflicts in scan_slot and I don't
see what you win by "settling down early". Also keep in mind that the
resources read from the device need to be remapped on some archs like
powerpc which we do from a header quirk at the moment.

We also have very different behaviour depending on the platform that we
can trigger ranging from ignoring all resources read from the devices
because we want the kernel to fully re-assign everything, to on the
contrary only every using what the firmware set (no re-assigning
possible), with variants such as re-assigning everything using a custom
algorithm etc....

We do rely in various places on the concept of scan first, alloc/fixup
next, then use. Merging scan & alloc/fixup of resources in one pass is a
major conceptual change. It might be ok but I need to convince myself it
is by understanding better what's going on and what problem you are
really trying to solve here.

Cheers,
Ben.


