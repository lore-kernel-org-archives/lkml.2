Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2A3Afm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 19:35:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:35215 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab2A3Afk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 19:35:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111880310"
Message-ID: <1327883738.7922.64.camel@yhuang-dev>
Subject: Re: [PATCH 2/3] ACPI, APEI: Add RAM mapping support to ACPI
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: Myron Stowe <myron.stowe@redhat.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, rjw@sisk.pl, trenn@suse.de,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Jan 2012 08:35:38 +0800
In-Reply-To: <CAErSpo5hrWz81SSS7Tg0HmTZ2seg76pa8kAe4iauAoqL6YAoOw@mail.gmail.com>
References: <20120121021318.14723.45698.stgit@amt.stowe>
	 <20120121021330.14723.72537.stgit@amt.stowe>
	 <CAErSpo5KDxkcMn3OrvujeSHhzF7PjG0hsYqMXe1HmpPJaLHvDg@mail.gmail.com>
	 <1327798687.7922.44.camel@yhuang-dev>
	 <CAErSpo5hrWz81SSS7Tg0HmTZ2seg76pa8kAe4iauAoqL6YAoOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-29 at 13:41 -0700, Bjorn Helgaas wrote:
> On Sat, Jan 28, 2012 at 5:58 PM, Huang Ying <ying.huang@intel.com> wrote:
> > Hi, Bjorn,
> >
> > Sorry for late.  Just return from Chinese new year holiday.
> >
> > On Sat, 2012-01-21 at 08:04 -0700, Bjorn Helgaas wrote:
> > [snip]
> >> > +
> >> > +static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz)
> >> > +{
> >> > +       unsigned long pfn;
> >> > +
> >> > +       pfn = pg_off >> PAGE_SHIFT;
> >> > +       if (should_use_kmap(pfn)) {
> >> > +               if (pg_sz > PAGE_SIZE)
> >> > +                       return NULL;
> >> > +               return (void __iomem __force *)kmap(pfn_to_page(pfn));
> >> > +       } else
> >> > +               return acpi_os_ioremap(pg_off, pg_sz);
> >>
> >> This implies that ioremap() works differently on ia64 than on x86.
> >> Apparently one can ioremap() RAM on x86, but not on ia64.  Why is this
> >> different?  Shouldn't we instead fix ioremap() on ia64 so it works the
> >> same as on x86?
> >
> > If my understanding were correct, ioremap can not work for RAM on x86.
> > So we need to use kmap for RAM.  And on IA64, ioremap works for RAM and
> > will take care of cache attributes while kmap will not.  So ioremap is
> > used on IA64, while kmap is used on x86.
> 
> My point is that the *user* of ioremap() shouldn't need to care what
> architecture we're on.  For example, maybe the ioremap()
> implementation could be changed so that it uses kmap() internally when
> necessary.

I think that is about the semantics of ioremap().

Hi, Ingo,

Can you describe why normal RAM is not allowed to be mapped by
ioremap()?

> >> I looked at the ia64 ioremap(), and I can't see the reason it fails
> >> for RAM.  Huang, do you remember the details from 76da3fb3575?
> 
> This question is still open.  Do you remember anything about it?

Copy from Tony's mail,

This (Ying: use kmap insted of ioremap to map RAM) might be a problem on
ia64 - it is s/w responsibility to make sure that we don't map the same
underlying physical address using different cache attributes - e.g. we
must not map memory both cacheable and uncacheable at the same time.
Accessing such a mis-attributed page will result in a machine check.

So I'd worry that if the memory in question was being used as
uncacheable, this code might result in a cached access, which would
crash the machine.

Best Regards,
Huang Ying

