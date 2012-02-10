Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab2BJAIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:08:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758807Ab2BJAIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:08:50 -0500
Subject: Re: [PATCH] ACPI: Fix logic for removing mappings in 'acpi_unmap'
From: Myron Stowe <mstowe@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com, tony.luck@intel.com,
        trenn@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <CAErSpo47+kHmS6477Bne84rPiy+sHGjgtK3mpk6VJc+hM4hhbg@mail.gmail.com>
References: <20120209163641.26858.59399.stgit@amt.stowe>
	 <CAErSpo47+kHmS6477Bne84rPiy+sHGjgtK3mpk6VJc+hM4hhbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Feb 2012 17:08:38 -0700
Message-ID: <1328832518.2404.86.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 08:42 -0800, Bjorn Helgaas wrote:
> On Thu, Feb 9, 2012 at 8:36 AM, Myron Stowe <myron.stowe@redhat.com> wrote:
> > From: Myron Stowe <mstowe@redhat.com>
> >
> > Make sure the removal of mappings uses the same logic that put the
> > mappings in place.
> >
> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > ---
> >
> >  drivers/acpi/osl.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index 412a1e0..5aef087 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -347,7 +347,7 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
> >        unsigned long pfn;
> >
> >        pfn = pg_off >> PAGE_SHIFT;
> > -       if (page_is_ram(pfn))
> > +       if (should_use_kmap(pfn))
> >                kunmap(pfn_to_page(pfn));
> >        else
> >                iounmap(vaddr);
> >
> 
> Whatever happened to the question of why we have arch-specific
> ioremap() behavior?  It's good to make map/unmap symmetric, but it'd
> be better to get rid of the ioremap/kmap hack.

+cc ingo

We never received any explanation for why ioremap() failed for Ying with
RAM on x86.  Last I saw Ying asked Ingo for some input here but there
was never any reply -
http://marc.info/?l=linux-acpi&m=132788392604738&w=2

I like your idea of possibly changing ioremap's implementation so that
it would handle requests related to RAM - by using kmap() internally
when necessary - so that a *user* wouldn't need to care what
architecture we're on.  I, however, feel like I don't have enough
experience with the memory management subsystem to know if such a tactic
would fly or not so was uncomfortable proceeding along those lines.  As
a result, I just wanted to get this in for the meantime.

Myron

> 
> Bjorn


