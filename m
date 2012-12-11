Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2LKMkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:40:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:55068 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab2LKMkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:40:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
Date: Tue, 11 Dec 2012 13:45:43 +0100
Message-ID: <1918088.8lbRqmEGMX@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAE9FiQXYPPcRZZBFGrqcV--0-UixMH1f+q4WdovErthsLhxn7A@mail.gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <8119513.v7VrlzcaZC@vostro.rjw.lan> <CAE9FiQXYPPcRZZBFGrqcV--0-UixMH1f+q4WdovErthsLhxn7A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 10, 2012 06:26:08 PM Yinghai Lu wrote:
> On Mon, Dec 10, 2012 at 5:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >> OK, thanks for the pointers.  I actually see more differences between our
> >> patchsets.  For one example, you seem to have left the parent->ops.bind()
> >> stuff in acpi_add_single_object() which calls it even drivers_autoprobe is
> >> set.
> >
> > Sorry, that should have been "which calls it even when drivers_autoprobe is
> > not set".  I need to be more careful.
> >
> 
> oh,  Jiang Liu had one patch to remove that workaround.
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=b40dba80c2b8395570d8357e6b3f417c27c84504
> 
> ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops

OK, so I'm looking at the current code, which for me is the master branch of
the linux-pm.git tree (the linux-next branch is the same ATM), and I'm not
seeing acpi_pci_unbind_cb() in there.  So surely this patch applies to
something different, right?  In which case I wonder what reason there is for
me to look at it at all?

Besides, I think it may be done differently and in a more straightforward
way.  Namely, on top of my current patchset, it is guaranteed that not only
struct pci_dev objects will always be registered after the companion struct
acpi_device ones, but also they always will be *created* after those
companion objects have been registered.  So in principle we can populate
a new struct pci_dev's ACPI handle as soon as in pci_scan_device(),
next to pci_set_of_node().  Then, we can do something like acpi_pci_bind(),
although without the whole acpi_get_pci_dev() nonsense, in pci_setup_device(),
in which case we won't need to do it anywhere else.

As an added benefit, acpi_platform_notify() would then see a populated ACPI
handle in that struct pci_dev when finally registering the PCI device, so it
wouldn't need to do the whole acpi_find_bridge_device() and type->find_device()
dance.

> Maybe you can review that patches in my for-pci-next2...
> those are ACPI related anyway.

I can, provided that (1) they are based on top of my tree or v3.7 and (2)
they don't conflict with patches we're currently discussing.

> those patches have been there for a while, and Bjorn did not have time
> to digest them.

Well, Bjorn's review bandwidth is limited and we need to take that into
account.

> or you prefer I resend updated version as huge whole patchset?

No, no huge patchsets, please.  Let's take one step at a time, so that
everyone involved/interested can understand what's going on, OK?

My review capacity also is not unlimited, mind you.  I can't promise I'll
have the time to review more than a few patches a day (where "a few" is
rather less than "several").

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
