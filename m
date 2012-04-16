Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2DPPxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:53:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48528 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2DPPxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:53:14 -0400
Date: Mon, 16 Apr 2012 11:47:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: mingo@elte.hu, suresh.b.siddha@intel.com, jwboyer@redhat.com,
        hpa@zytor.com, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        xiantao.zhang@intel.com
Subject: Re: [PATCH 2/2] xen/x86: Implement x86_apic_ops
Message-ID: <20120416154746.GC4654@phenom.dumpdata.com>
References: <20120328092358.GD22885@gmail.com>
 <1332956242-5352-1-git-send-email-konrad.wilk@oracle.com>
 <1332956242-5352-3-git-send-email-konrad.wilk@oracle.com>
 <CAF1ivSagwO9PLQwwbLmTZik8xpfDncY=aXdhugT5Rivuu14K9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAF1ivSagwO9PLQwwbLmTZik8xpfDncY=aXdhugT5Rivuu14K9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F8C404F.00B4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 12:49:02PM +0800, Lin Ming wrote:
> On Thu, Mar 29, 2012 at 1:37 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > Or rather just implement one different function as opposed
> > to the native one : the read function.
> >
> > We synthesize the values.
> >
> > Acked-by:  Suresh Siddha <suresh.b.siddha@intel.com>
> > [v1: Rebased on top of tip/x86/urgent]
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/Makefile    |    2 +-
> >  arch/x86/xen/apic.c      |   17 +++++++++++++++++
> >  arch/x86/xen/enlighten.c |    2 ++
> >  arch/x86/xen/xen-ops.h   |    4 ++++
> >  4 files changed, 24 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/x86/xen/apic.c
> >
> > diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> > index add2c2d..96ab2c0 100644
> > --- a/arch/x86/xen/Makefile
> > +++ b/arch/x86/xen/Makefile
> > @@ -20,5 +20,5 @@ obj-$(CONFIG_EVENT_TRACING) += trace.o
> >  obj-$(CONFIG_SMP)              += smp.o
> >  obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
> >  obj-$(CONFIG_XEN_DEBUG_FS)     += debugfs.o
> > -obj-$(CONFIG_XEN_DOM0)         += vga.o
> > +obj-$(CONFIG_XEN_DOM0)         += apic.o vga.o
> >  obj-$(CONFIG_SWIOTLB_XEN)      += pci-swiotlb-xen.o
> > diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
> > new file mode 100644
> > index 0000000..aee16ab
> > --- /dev/null
> > +++ b/arch/x86/xen/apic.c
> > @@ -0,0 +1,17 @@
> > +#include <linux/init.h>
> > +#include <asm/x86_init.h>
> > +
> > +unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
> > +{
> > +       if (reg == 0x1)
> > +               return 0x00170020;
> > +       else if (reg == 0x0)
> > +               return apic << 24;
> 
> Why is fixed value returned?
> 
> Can't we implement it with hypercall(PHYSDEVOP_apic_read)?

We sure can. But this was meant to fix the regression - so I
figured we would do that later on. But the more important question
is - do we actually need to do the hypercall? We aren't using the
IOAPIC for anything - we don't program the pins from dom0.

> 
> Lin Ming
> 
> > +
> > +       return 0xff;
> > +}
> > +
> > +void __init xen_init_apic(void)
> > +{
> > +       x86_io_apic_ops.read = xen_io_apic_read;
> > +}
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 4172af8..a7df080 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1271,6 +1271,8 @@ asmlinkage void __init xen_start_kernel(void)
> >                xen_start_info->console.domU.mfn = 0;
> >                xen_start_info->console.domU.evtchn = 0;
> >
> > +               xen_init_apic();
> > +
> >                /* Make sure ACS will be enabled */
> >                pci_request_acs();
> >        }
> > diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> > index b095739..45c0c06 100644
> > --- a/arch/x86/xen/xen-ops.h
> > +++ b/arch/x86/xen/xen-ops.h
> > @@ -92,11 +92,15 @@ struct dom0_vga_console_info;
> >
> >  #ifdef CONFIG_XEN_DOM0
> >  void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size);
> > +void __init xen_init_apic(void);
> >  #else
> >  static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
> >                                       size_t size)
> >  {
> >  }
> > +static inline void __init xen_init_apic(void)
> > +{
> > +}
> >  #endif
> >
> >  /* Declare an asm function, along with symbols needed to make it
> > --
> > 1.7.7.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
