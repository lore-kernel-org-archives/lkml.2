Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2EAUcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:32:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29964 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2EAUce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:32:34 -0400
Date: Tue, 1 May 2012 16:26:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        mingo@kernel.org, suresh.b.siddha@intel.com, mlin@ss.pku.edu.cn
Subject: Re: [GIT PULL] stable/for-ingo-v3.5 of IOAPIC abstraction (and then
 some users) for v3.5
Message-ID: <20120501202640.GB16209@phenom.dumpdata.com>
References: <20120501194240.GA15237@phenom.dumpdata.com>
 <CA+5PVA4OorzAkkBe+PayPPHa1k7=X6Y0ALg=jRWLyKxabAPpiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CA+5PVA4OorzAkkBe+PayPPHa1k7=X6Y0ALg=jRWLyKxabAPpiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 04:08:19PM -0400, Josh Boyer wrote:
> On Tue, May 1, 2012 at 3:42 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > -static void __init __ioapic_init_mappings(void)
> > +void __init native_io_apic_init_mappings(void)
> >  {
> >        unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
> >        struct resource *ioapic_res;
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index 1a29015..8526317 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -1012,7 +1012,7 @@ void __init setup_arch(char **cmdline_p)
> >        init_cpu_to_node();
> >
> >        init_apic_mappings();
> > -       ioapic_and_gsi_init();
> > +       x86_io_apic_ops.init();
> >
> >        kvm_guest_init();
> >
> > diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> > index 9cf71d0..35c5e54 100644
> > --- a/arch/x86/kernel/x86_init.c
> > +++ b/arch/x86/kernel/x86_init.c
> > @@ -18,6 +18,7 @@
> >  #include <asm/e820.h>
> >  #include <asm/time.h>
> >  #include <asm/irq.h>
> > +#include <asm/io_apic.h>
> >  #include <asm/pat.h>
> >  #include <asm/tsc.h>
> >  #include <asm/iommu.h>
> > @@ -119,3 +120,10 @@ struct x86_msi_ops x86_msi = {
> >        .teardown_msi_irqs = default_teardown_msi_irqs,
> >        .restore_msi_irqs = default_restore_msi_irqs,
> >  };
> > +
> > +struct x86_io_apic_ops x86_io_apic_ops = {
> > +       .init   = native_io_apic_init_mappings,
> > +       .read   = native_io_apic_read,
> > +       .write  = native_io_apic_write,
> > +       .modify = native_io_apic_modify,
> > +};
> 
> You'll get a section mismatch warning on this struct.  It's not a huge
> deal, but native_io_apic_init_mappings is annotated as __init whereas
> this struct isn't.  In practice it doesn't seem to matter as
> x86_io_apic_ops.init is only called in setup_arch, but it's still a
> valid warning.

I think that the mismatch disappears if the structure has the word
_ops in it. At least that is what I saw (when I ran with the MODULE_SECTION=y
with the initial implementation of this and then fixed it up).

However, let me double check - I might have seen that with something
else and misremebered it.

> 
> (First noticed in https://bugzilla.redhat.com/show_bug.cgi?id=817645 )
> 
> josh
