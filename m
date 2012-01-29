Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2A2A6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 19:58:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:3435 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2A2A6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 19:58:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="60910932"
Message-ID: <1327798687.7922.44.camel@yhuang-dev>
Subject: Re: [PATCH 2/3] ACPI, APEI: Add RAM mapping support to ACPI
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, rjw@sisk.pl, trenn@suse.de,
        linux-kernel@vger.kernel.org
Date: Sun, 29 Jan 2012 08:58:07 +0800
In-Reply-To: <CAErSpo5KDxkcMn3OrvujeSHhzF7PjG0hsYqMXe1HmpPJaLHvDg@mail.gmail.com>
References: <20120121021318.14723.45698.stgit@amt.stowe>
	 <20120121021330.14723.72537.stgit@amt.stowe>
	 <CAErSpo5KDxkcMn3OrvujeSHhzF7PjG0hsYqMXe1HmpPJaLHvDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn,

Sorry for late.  Just return from Chinese new year holiday.

On Sat, 2012-01-21 at 08:04 -0700, Bjorn Helgaas wrote:
[snip]
> > +
> > +static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz)
> > +{
> > +       unsigned long pfn;
> > +
> > +       pfn = pg_off >> PAGE_SHIFT;
> > +       if (should_use_kmap(pfn)) {
> > +               if (pg_sz > PAGE_SIZE)
> > +                       return NULL;
> > +               return (void __iomem __force *)kmap(pfn_to_page(pfn));
> > +       } else
> > +               return acpi_os_ioremap(pg_off, pg_sz);
> 
> This implies that ioremap() works differently on ia64 than on x86.
> Apparently one can ioremap() RAM on x86, but not on ia64.  Why is this
> different?  Shouldn't we instead fix ioremap() on ia64 so it works the
> same as on x86?

If my understanding were correct, ioremap can not work for RAM on x86.
So we need to use kmap for RAM.  And on IA64, ioremap works for RAM and
will take care of cache attributes while kmap will not.  So ioremap is
used on IA64, while kmap is used on x86.

> I looked at the ia64 ioremap(), and I can't see the reason it fails
> for RAM.  Huang, do you remember the details from 76da3fb3575?
> 
> > +}
> > +
> > +static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
> > +{
> > +       unsigned long pfn;
> > +
> > +       pfn = pg_off >> PAGE_SHIFT;
> > +       if (page_is_ram(pfn))
> > +               kunmap(pfn_to_page(pfn));
> > +       else
> > +               iounmap(vaddr);
> 
> I hope we can resolve the ioremap() question so we don't need this
> patch at all.  But if we do need this, I don't like the asymmetry here
> -- on x86 RAM, I think we use ioremap() and kunmap(), which seems
> wrong.  We should be able to use ioremap() and iounmap().

Yes.   The asymmetry here is not good.  We should use should_use_kmap()
instead of page_is_ram directly here.

Best Regards,
Huang Ying


