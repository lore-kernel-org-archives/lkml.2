Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2AWQGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:06:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44813 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2AWQGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:06:34 -0500
MIME-Version: 1.0
In-Reply-To: <1327139539-14301-2-git-send-email-yinghai@kernel.org>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org> <1327139539-14301-2-git-send-email-yinghai@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 08:06:12 -0800
X-Google-Sender-Auth: xhXWbCp8pKKFGBgko3pwNhcyh8Y
Message-ID: <CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
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

On Sat, Jan 21, 2012 at 1:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> +       /*
> +        * pci_stop_bus_device(dev) will not remove dev from bus->devices list,
> +        *  so We don't need use _safe version for_each here.
> +        * Also _safe version has problem when pci_stop_bus_device() for PF try
> +        *  to remove VFs.
> +        */
> +       for (l = head->next; l != head;) {

That's crazy. Why would you open-code this? Why isn't it just a
"list_for_each()"?

And what are the problems with the safe version? If the safe version
doesn't work, then something is *seriously* wrong with the list.

> +               struct pci_dev *dev = pci_dev_b(l);
> +
> +               /*
> +                * VFs are removed by pci_remove_bus_device() in the
> +                *  pci_stop_bus_devices() code path for PF.
> +                *  aka, bus->devices get updated in the process.
> +                * barrier() will make sure we get right next from that list.
> +                */
> +               if (!dev->is_virtfn) {
> +                       pci_stop_bus_device(dev);
> +                       barrier();
> +               }

And this is just insanity. The "barrier()" cannot *possibly* do
anything sane. If it really makes a difference, there is again some
serious problem with the whole f*cking thing.

NAK on the patch until sanity is restored. This is just total voodoo
programming.

                            Linus
