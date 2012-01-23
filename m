Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2AWSp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:45:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46438 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2AWSp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:45:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
 <1327139539-14301-2-git-send-email-yinghai@kernel.org> <CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
 <CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 10:45:35 -0800
X-Google-Sender-Auth: BP6ncVY4K_lufLndkiC04g1mD_8
Message-ID: <CA+55aFyok04YrmEYXLbAE2vB_944+aEJZhd5tzu6U2k0CLaN5A@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: Make sriov work with hotplug remove
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 10:30 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> in list_for_each_safe()
>
> #define list_for_each_safe(pos, n, head) \
>        for (pos = (head)->next, n = pos->next; pos != (head); \
>                pos = n, n = pos->next)
>
> n is saved before, and safe only mean pos could be freed from the
> list, but n still can be used for next loop.
>
> in our case, the list have PF and several VFs, when
> pci_stop_bus_device() is called for PF, pos are still valid, but
> VFs are removed from the list. so n will not be valid.

That still doesn't explain anything.

The whole point of the safe version is that if the entry that is being
worked on is removed, then we can still use the next one.

Why isn't this magically true in this case? If some *other* random
entry than the one that is being iterated over can magically be
removed, then the whole thing is just pure and utter crap, and no
amount of list maintenance can ever fix it.

So explain.

> https://lkml.org/lkml/2011/10/15/141
> or from attached one.

This still doesn't make sense. Why do that stupid allocation? Why not
just move the entry? Why doesn't just the sane approach work?

Exactly why does not the obvious

    /* stop bus device for phys_fn at first */
    list_for_each_safe(l, n, &bus->devices) {
        struct pci_dev *dev = pci_dev_b(l);
        if (!dev->is_virtfn)
            pci_stop_bus_device(dev);
    }

work? What the f*^& does that pci_stop_bus_device() function do to
that bus->devices list that isn't just a "list_del()" of that single
entry? And if it does anything else, it should damn well stop doing
that.

The *exact* same loop is then apparently working for the virtual
device case, so what the hell is going on that it wouldn't work for
the physical one?

What's the confusion? Why all the crazy idiotic code that makes no sense?

                      Linus
