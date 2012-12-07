Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424501Ab2LGU7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:59:41 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:44454 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424420Ab2LGU7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:59:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] PCI, acpiphp: Separate out hot-add support of pci host bridge
Date: Fri, 07 Dec 2012 22:04:35 +0100
Message-ID: <1601199.4gTPfZEF7o@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAErSpo6MEtx6hsYhY=h0+eXqQcnZuG2vq=z_8Oz8tnksKZd7DA@mail.gmail.com>
References: <20121207062454.11051.12739.stgit@amt.stowe> <20121207062500.11051.44198.stgit@amt.stowe> <CAErSpo6MEtx6hsYhY=h0+eXqQcnZuG2vq=z_8Oz8tnksKZd7DA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 07, 2012 12:32:46 PM Bjorn Helgaas wrote:
> On Thu, Dec 6, 2012 at 11:25 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> > From: Yinghai Lu <yinghai@kernel.org>
> >
> > It causes confusion.
> 
> I completely agree that acpiphp causes confusion  :)
> 
> > We may only need acpi hp for pci host bridge.
> >
> > Split host bridge hot-add support to pci_root_hp, and keep acpiphp simple.
> >
> > -v2: put back pci_root_hp change in one patch
> > -v3: add pcibios_resource_survey_bus() calling
> > -v4: remove not needed code with remove_bridge
> > -v5: put back support for acpiphp support for slots just on root bus.
> > -v6: change some functions to *_p2p_* to make it more clean.
> > -v7: split hot_added change out.
> >
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > ---
> >
> >  drivers/acpi/Makefile              |    1
> >  drivers/acpi/pci_root_hp.c         |  228 ++++++++++++++++++++++++++++++++++++
> >  drivers/pci/hotplug/acpiphp_glue.c |   59 ++-------
> >  3 files changed, 244 insertions(+), 44 deletions(-)
> >  create mode 100644 drivers/acpi/pci_root_hp.c
> >
> > diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> > index 82422fe..4edfe41 100644
> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -36,6 +36,7 @@ acpi-y                                += processor_core.o
> >  acpi-y                         += ec.o
> >  acpi-$(CONFIG_ACPI_DOCK)       += dock.o
> >  acpi-y                         += pci_root.o pci_link.o pci_irq.o pci_bind.o
> > +acpi-$(CONFIG_HOTPLUG)         += pci_root_hp.o
> 
> I absolutely, 110% agree with splitting out the host bridge hotplug
> code from the PCI device hotplug code.
> 
> But I don't want to put this in a separate file; I think it should go
> directly in pci_root.c.  Putting it in a separate file gives the
> illusion that hotplug is something we only do in unusual
> circumstances.  But that's wrong -- even at boot-time we should be
> using the same hot-plug flow as we do later.
> 
> Plus, I want people to be forced to look at the ugliness of this code
> every time they look at pci_root.c.  Maybe that will help get it
> cleaned up eventually.
> 
> For example, as soon as you put this code in pci_root.c instead of
> pci_root_hp.c, it becomes obvious that we're keeping a list of host
> bridges in both places, and we probably don't need two lists.  And it
> seems dubious that acpi_pci_root_hp_init() is an initcall that walks
> the namespace looking for host bridges, when acpi_pci_root_add()
> already exists and is called for every host bridge.

Agreed.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
