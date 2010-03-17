Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0CQXAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:00:24 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:14701 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0CQXAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:00:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 1/3] hpet: convert to PNP driver
Date: Wed, 17 Mar 2010 16:00:18 -0700
User-Agent: KMail/1.9.10
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-acpi@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org
References: <20100317173329.31124.69795.stgit@bob.kio> <20100317173500.31124.53755.stgit@bob.kio> <3055132f1003171518o46c4712bk5089a7bab8574019@mail.gmail.com>
In-Reply-To: <3055132f1003171518o46c4712bk5089a7bab8574019@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201003171700.19573.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 March 2010 04:18:27 pm Venkatesh Pallipadi wrote:
> On Wed, Mar 17, 2010 at 10:35 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > PNPACPI already parses _CRS, and does a more complete job than we did here,
> > so let's just take advantage of that.
> 
> Patch looks good.
> One comment is that we now have a dependency on CONFIG_PNP. That
> probably needs to be added in drivers/char/Kconfig. But, that also
> means we may fail for users who do not have PNP in their config today.
> May be just select PNP when HPET is selected?

Good point; I missed that.  I could just add #ifdef CONFIG_PNP around
the relevant code in hpet.c.  That's the typical way we handle this.

drivers/char/hpet.c already depends on ACPI for another reason
(acpi_irq_model), and we do select PNP whenever CONFIG_ACPI=y, so
I don't think the CONFIG_PNP=n case will arise in practice.  But
it'd probably be better to have the #ifdef wrapper than to have the
implicit dependency on the "select PNP" in drivers/acpi/Kconfig.

> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > ---
> >
> >  drivers/char/hpet.c |  103 +++++++++++++--------------------------------------
> >  1 files changed, 27 insertions(+), 76 deletions(-)
> >
> >
> >
> > -       if (!data.hd_address || !data.hd_nirqs) {
> > -               printk("%s: no address or irqs in _CRS\n", __func__);
> > -               return -ENODEV;
> > -       }
> > +       data.hd_address = ioremap(mem->start, resource_size(mem));
> >
> >        return hpet_alloc(&data);
> >  }
> 
> Not a problem with this patch. But, don't we have a problem of rogue
> ioremap when hpet_alloc() fails here?

You're right.  I'll add a patch to fix that while I'm at it.

Bjorn
