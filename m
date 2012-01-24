Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2AXEeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 23:34:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:41799 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab2AXEe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 23:34:29 -0500
Message-ID: <1327379648.19850.31.camel@pasglop>
Subject: Re: [PATCH 1/7] PCI: Make sriov work with hotplug remove
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 24 Jan 2012 15:34:08 +1100
In-Reply-To: <CA+55aFwEbbq0yuN4mAtfDSbOE86mAWsBBz+pgBzn8_QHVk+B3g@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
	 <1327139539-14301-2-git-send-email-yinghai@kernel.org>
	 <CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
	 <CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
	 <CA+55aFyok04YrmEYXLbAE2vB_944+aEJZhd5tzu6U2k0CLaN5A@mail.gmail.com>
	 <CA+55aFwEbbq0yuN4mAtfDSbOE86mAWsBBz+pgBzn8_QHVk+B3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 11:34 -0800, Linus Torvalds wrote:
> On Mon, Jan 23, 2012 at 10:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Why isn't this magically true in this case? If some *other* random
> > entry than the one that is being iterated over can magically be
> > removed, then the whole thing is just pure and utter crap, and no
> > amount of list maintenance can ever fix it.
> >
> > So explain.
> 
> Ahh. I finally understand what's going on. The virtual device attached
> to a physical device can go away, and it's on the same damn list.
> 
> That's broken. Virtual devices set up by a physical device should be
> *children* of the physical device, not "siblings". But that's
> apparently not what the broken virtual PCI layer does.

Thank the PCI SIG for that ... they are sibling functions (or even
devices in some case) of the PF :-(

> So I think that there are two possible solutions:
> 
>  (a) fix the virtual devices that are attached to physical devices to
> really be children of the physical device, with the physical device as
> a "bridge" to that virtual bus.

This will confuse various other aspects of the PCI code since they are
really siblings from an addressing standpoint (ie bus/dev/fn)

Cheers,
Ben.

> I think this is the correct solution from any sane standpoint (now the
> topology of the device tree actually matches the logical
> relationship), which is why I think this is the RightThing(tm) to do.
> And it should automatically fix this insane issue where removing a
> device from a bus can remove *multiple* devices from the same list.
> 
>  (b) if that isn't an option, and the virtual devices make a mess, at
> least don't make the code uglier, just do something like:
> 
>     while (!list_empty(&bus->devices)) {
>         struct pci_dev *dev = list_first_entry(struct pci_dev, bus_list);
> 
>         pci_stop_bus_device(dev);
>     }
> 
> which at least isn't butt ugly. Add a large comment about how
> pci_stop_bus_device() can remove multiple devices due to the virtual
> devices having been done badly.
> 
> Who is in charge of the whole 'is_virtfn' mess? How realistic is it to
> fix that crud?
> 
>                      Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


