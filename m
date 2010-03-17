Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CQEa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:30:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:22628 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0CQEa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:30:27 -0400
Subject: Re: [PATCH v1 2/3] x86/PCI: trim _CRS windows when they conflict
	with	previous reservations
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
In-Reply-To: <4BA04BB9.2090501@jp.fujitsu.com>
References: <20100311235954.4355.23100.stgit@bob.kio>
	 <20100312000114.4355.58189.stgit@bob.kio> <4BA04BB9.2090501@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 16 Mar 2010 22:22:05 -0600
Message-Id: <1268799725.13147.29.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 12:25 +0900, Kenji Kaneshige wrote:
> Bjorn Helgaas wrote:
> > Yanko's GA-MA78GM-S2H (BIOS F11) reports a host bridge window that overlaps
> > system memory:
> > 
> >     PCI window: [mem 0xcff00000-0x10ed0ffff]
> >     System RAM: [mem 0x100000000-0x22fffffff]
> > 
> > We can be pretty confident that the System RAM region is correct (if it
> > were wrong, we'd crash as soon as we tried to use any memory in that area),
> > so this patch tries to correct the PCI window by trimming it so it doesn't
> > conflict with any previous reservations.
> 
> Though I might misunderstand something, it looks Yanko's machine specific
> workaround. I'm wondering if trimming _CRS is a generic workaround for
> broken _CRS machine.
> 
> How about doing this when GA-MA78GM-S2H (BIOS F11) (and known machines
> that have the same problem) is detected? Or how about switching nocrs
> mode if the problem (resource conflict) is detected?

It's certainly a possibility to do this only for specific machines, but
I'd like to avoid tripping over issues one-by-one.

I think there are three ways to address BIOS _CRS defects:

  1) Ship an OEM-specific host bridge driver
  2) Put a platform- or BIOS-specific quirk into Windows
  3) Change the BIOS

The first two sound like such a hassle to me that I doubt they would be
practical.

But it's clear that there are systems like this with what appear to be
_CRS defects.  It's quite possible that it's not really a defect, and we
just don't understand how to parse _CRS correctly yet.  Or, Windows
might have a few heuristics to clean up obvious errors.

For example, I think Windows aligns host bridge windows, as documented
here: http://bugzilla.kernel.org/show_bug.cgi?id=14337

I think Windows also knows to ignore the Consumer/Producer bit in
Address Space Descriptors, and assume that all resources on bridges are
Producers.

Hmm, what we really need is a way to run Windows in a virtualized
environment where we could manipulate the _CRS method and see what
Windows does with it...

Anyway, I'd like to make Linux behave as much like Windows as possible
in this area so we can take advantage of all the testing that's done
with Windows.

Bjorn

> > http://bugzilla.kernel.org/show_bug.cgi?id=15480
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Reported-by: Yanko Kaneti <yaneti@declera.com>
> > ---
> > 
> >  arch/x86/pci/acpi.c |   48 +++++++++++++++++++++++++++++++++++-------------
> >  1 files changed, 35 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > index 6e22454..d255ce8 100644
> > --- a/arch/x86/pci/acpi.c
> > +++ b/arch/x86/pci/acpi.c
> > @@ -114,11 +114,19 @@ align_resource(struct acpi_device *bridge, struct resource *res)
> >  	}
> >  }
> >  
> > +static bool
> > +resource_contains(struct resource *res, resource_size_t n)
> > +{
> > +	if (n < res->start || n > res->end)
> > +		return false;
> > +	return true;
> > +}
> > +
> >  static acpi_status
> >  setup_resource(struct acpi_resource *acpi_res, void *data)
> >  {
> >  	struct pci_root_info *info = data;
> > -	struct resource *res;
> > +	struct resource *res, *conflict;
> >  	struct acpi_resource_address64 addr;
> >  	acpi_status status;
> >  	unsigned long flags;
> > @@ -157,21 +165,35 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> >  		return AE_OK;
> >  	}
> >  
> > -	if (insert_resource(root, res)) {
> > +	conflict = insert_resource_conflict(root, res);
> > +	while (conflict) {
> >  		dev_err(&info->bridge->dev,
> > -			"can't allocate host bridge window %pR\n", res);
> > -	} else {
> > -		pci_bus_add_resource(info->bus, res, 0);
> > -		info->res_num++;
> > -		if (addr.translation_offset)
> > -			dev_info(&info->bridge->dev, "host bridge window %pR "
> > -				 "(PCI address [%#llx-%#llx])\n",
> > -				 res, res->start - addr.translation_offset,
> > -				 res->end - addr.translation_offset);
> > +		        "host bridge window %pR conflicts with %s %pR\n",
> > +			res, conflict->name, conflict);
> > +
> > +		if (resource_contains(res, conflict->end))
> > +			res->start = conflict->end + 1;
> > +		else if (resource_contains(res, conflict->start))
> > +			res->end = conflict->start - 1;
> >  		else
> > -			dev_info(&info->bridge->dev,
> > -				 "host bridge window %pR\n", res);
> > +			return AE_OK;
> > +
> > +		if (res->start >= res->end)
> > +			return AE_OK;
> > +
> > +		conflict = insert_resource_conflict(root, res);
> >  	}
> > +
> > +	pci_bus_add_resource(info->bus, res, 0);
> > +	info->res_num++;
> > +	if (addr.translation_offset)
> > +		dev_info(&info->bridge->dev, "host bridge window %pR "
> > +			 "(PCI address [%#llx-%#llx])\n",
> > +			 res, res->start - addr.translation_offset,
> > +			 res->end - addr.translation_offset);
> > +	else
> > +		dev_info(&info->bridge->dev,
> > +			 "host bridge window %pR\n", res);
> >  	return AE_OK;
> >  }
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> 

