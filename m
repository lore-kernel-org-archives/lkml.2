Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab1IMV4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:56:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:49062 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab1IMV4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:56:44 -0400
Subject: Re: [PATCH 0/2] PCI: PCI-E MPS bug fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jon Mason <mason@myri.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <CAMaF-rPhfVmuMthdO_iHEMmSbi9cujX7LrK+DTGHZ=FxGpdokg@mail.gmail.com>
References: <1315518078-30619-1-git-send-email-mason@myri.com>
	 <CA+55aFyFXXyEvOs0asgNeCrLzvH+e1zXgOen1rDd9BkB09J5NQ@mail.gmail.com>
	 <6dad18a7-cf65-46db-8283-78b8da5bfa3a@email.android.com>
	 <1315911045.455.150.camel@pasglop> <1315937852.455.156.camel@pasglop>
	 <CAMaF-rPhfVmuMthdO_iHEMmSbi9cujX7LrK+DTGHZ=FxGpdokg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 18:56:19 -0300
Message-ID: <1315950979.455.159.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> DNS issue with kernel.org when the patches went out caused it to not
> get out to any of the mailing lists.
> 
> In Linux' github tree
> Patch 1/2 is commit 5307f6d5fb12fd01f9f321bc4a8fd77e74858647
> Patch 2/2 is commit ed2888e906b56769b4ffabb9c577190438aa68b8
> 
> > When using "safe" mode, I get a crash in pcie_find_smpss(). Patch below.
> >
> > From 1b542d690323fab332e61099193d598c5c515d13 Mon Sep 17 00:00:00 2001
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date: Tue, 13 Sep 2011 15:16:33 -0300
> > Subject: [PATCH] pci: Don't crash when reading mpss from root complex
> >
> > In pcie_find_smpss(), we have the following statement:
> >
> >        if (dev->is_hotplug_bridge && (!list_is_singular(&dev->bus->devices) ||
> >            dev->bus->self->pcie_type != PCI_EXP_TYPE_ROOT_PORT))
> >
> > The problem is that at least on my machine, this gets called for the
> > root complex (virtual P2P bridge), and dev->bus->self is NULL since
> > the parent bus for this is not itself anchor to a PCI device.
> >
> > This adds the necessary NULL check.
> >
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Good catch.
> 
> Acked-by: Jon Mason <mason@myri.com>

Linus, please apply.

Cheers
Ben.

> > ---
> >  drivers/pci/probe.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 8473727..09d1c0f 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -1351,7 +1351,8 @@ static int pcie_find_smpss(struct pci_dev *dev, void *data)
> >         * will occur as normal.
> >         */
> >        if (dev->is_hotplug_bridge && (!list_is_singular(&dev->bus->devices) ||
> > -           dev->bus->self->pcie_type != PCI_EXP_TYPE_ROOT_PORT))
> > +            (dev->bus->self &&
> > +             dev->bus->self->pcie_type != PCI_EXP_TYPE_ROOT_PORT)))
> >                *smpss = 0;
> >
> >        if (*smpss > dev->pcie_mpss)
> > --
> > 1.7.4.1
> >
> >
> >
> >
> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


