Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab0IWXSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:18:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34094 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0IWXSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KkqqJZatjIN/UgBVaYVJuqSlz4svhV5jWdA6PsXI83wyPRAk6l88QQEkqENum0Ylh7
         Rsx3/TYdLenp5bsGh0q76IcuLjkr9glfSCUx0mAUzBrMjTx9DeOU8UaW2gAaN00DVWKZ
         YficmykaolHfDsTzpEizb5GBbzHb3WDcbnN+Q=
MIME-Version: 1.0
In-Reply-To: <20100923144826.GA29015@dumpdata.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
	<1280945955-14229-17-git-send-email-konrad.wilk@oracle.com>
	<20100831183140.GA3431@dumpdata.com>
	<20100923144826.GA29015@dumpdata.com>
Date: Thu, 23 Sep 2010 16:18:42 -0700
Message-ID: <AANLkTinor8_okhpQ1M_DGubAp50M4j2T1RFO-TTi0Q2b@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 16/20] x86: Introduce x86_msi_ops
From: Bruce Edge <bruce.edge@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com, hpa@zytor.com,
        alex.williamson@redhat.com, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 7:48 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Aug 31, 2010 at 02:31:40PM -0400, Konrad Rzeszutek Wilk wrote:
>> On Wed, Aug 04, 2010 at 02:19:11PM -0400, Konrad Rzeszutek Wilk wrote:
>> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> >
>> > Introduce an x86 specific indirect mechanism to setup MSIs.
>> > The MSI setup functions become function pointers in an x86_msi_ops
>> > struct, that defaults to the implementation in io_apic.c
>>
>> Hey Peter,
>>
>> I was wondering if you have time to take a look at this?
>
> ping?
>>
>> The patchset introduces a driver which takes care of allowing
>> pci_conf_read/write in a virtualized environements with PCI
>> passthrough devices. Unfortunatly for MSI operations that is not
>> so simple, so this patch alongside with the previous one
>> (https://patchwork.kernel.org/patch/117105/)
>> expands the arch_* calls. This makes it possible to register on top
>> of the native callback (the virtualized ones can), if required.
>>

Is this patch required for PCI passthrough devices that use MSI interrupts?

I'm wondering because I'm seeing drivers for PCI passthrough  are able
to init the MSI interrupts OK, but never get any interrupts with pvops
domU kernels.

-Bruce

>> >
>> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> > Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > Cc: "H. Peter Anvin" <hpa@zytor.com>
>> > Cc: x86@kernel.org
>> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>> > ---
>> >  arch/x86/include/asm/pci.h      |   26 +++++++++++++++++++++++---
>> >  arch/x86/include/asm/x86_init.h |    9 +++++++++
>> >  arch/x86/kernel/apic/io_apic.c  |    8 ++++----
>> >  arch/x86/kernel/x86_init.c      |    6 ++++++
>> >  4 files changed, 42 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
>> > index bcf84e1..861d0d0 100644
>> > --- a/arch/x86/include/asm/pci.h
>> > +++ b/arch/x86/include/asm/pci.h
>> > @@ -7,6 +7,7 @@
>> >  #include <linux/string.h>
>> >  #include <asm/scatterlist.h>
>> >  #include <asm/io.h>
>> > +#include <asm/x86_init.h>
>> >
>> >  #ifdef __KERNEL__
>> >
>> > @@ -92,9 +93,28 @@ static inline void early_quirks(void) { }
>> >
>> >  extern void pci_iommu_alloc(void);
>> >
>> > -/* MSI arch hook */
>> > -#define arch_setup_msi_irqs arch_setup_msi_irqs
>> > -#define arch_teardown_msi_irqs arch_teardown_msi_irqs
>> > +/* MSI arch specific hooks */
>> > +static inline int x86_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>> > +{
>> > +   return x86_msi.setup_msi_irqs(dev, nvec, type);
>> > +}
>> > +
>> > +static inline void x86_teardown_msi_irqs(struct pci_dev *dev)
>> > +{
>> > +   x86_msi.teardown_msi_irqs(dev);
>> > +}
>> > +
>> > +static inline void x86_teardown_msi_irq(unsigned int irq)
>> > +{
>> > +   x86_msi.teardown_msi_irq(irq);
>> > +}
>> > +
>> > +#define arch_setup_msi_irqs x86_setup_msi_irqs
>> > +#define arch_teardown_msi_irqs x86_teardown_msi_irqs
>> > +#define arch_teardown_msi_irq x86_teardown_msi_irq
>> > +int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
>> > +void native_teardown_msi_irq(unsigned int irq);
>> > +void native_teardown_msi_irqs(struct pci_dev *dev);
>> >
>> >  #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
>> >
>> > diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
>> > index baa579c..64642ad 100644
>> > --- a/arch/x86/include/asm/x86_init.h
>> > +++ b/arch/x86/include/asm/x86_init.h
>> > @@ -154,9 +154,18 @@ struct x86_platform_ops {
>> >     int (*i8042_detect)(void);
>> >  };
>> >
>> > +struct pci_dev;
>> > +
>> > +struct x86_msi_ops {
>> > +   int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
>> > +   void (*teardown_msi_irq)(unsigned int irq);
>> > +   void (*teardown_msi_irqs)(struct pci_dev *dev);
>> > +};
>> > +
>> >  extern struct x86_init_ops x86_init;
>> >  extern struct x86_cpuinit_ops x86_cpuinit;
>> >  extern struct x86_platform_ops x86_platform;
>> > +extern struct x86_msi_ops x86_msi;
>> >
>> >  extern void x86_init_noop(void);
>> >  extern void x86_init_uint_noop(unsigned int unused);
>> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> > index a8d069e..0b552ec 100644
>> > --- a/arch/x86/kernel/apic/io_apic.c
>> > +++ b/arch/x86/kernel/apic/io_apic.c
>> > @@ -3531,7 +3531,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
>> >     return 0;
>> >  }
>> >
>> > -int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>> > +int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>> >  {
>> >     unsigned int irq;
>> >     int ret, sub_handle;
>> > @@ -3592,12 +3592,12 @@ error:
>> >     return ret;
>> >  }
>> >
>> > -void arch_teardown_msi_irq(unsigned int irq)
>> > +void native_teardown_msi_irq(unsigned int irq)
>> >  {
>> >     destroy_irq(irq);
>> >  }
>> >
>> > -void arch_teardown_msi_irqs(struct pci_dev *dev)
>> > +void native_teardown_msi_irqs(struct pci_dev *dev)
>> >  {
>> >     struct msi_desc *entry;
>> >
>> > @@ -3607,7 +3607,7 @@ void arch_teardown_msi_irqs(struct pci_dev *dev)
>> >                     continue;
>> >             nvec = 1 << entry->msi_attrib.multiple;
>> >             for (i = 0; i < nvec; i++)
>> > -                   arch_teardown_msi_irq(entry->irq + i);
>> > +                   x86_msi.teardown_msi_irq(entry->irq + i);
>> >     }
>> >  }
>> >
>> > diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
>> > index cd6da6b..91b5209 100644
>> > --- a/arch/x86/kernel/x86_init.c
>> > +++ b/arch/x86/kernel/x86_init.c
>> > @@ -6,6 +6,7 @@
>> >  #include <linux/init.h>
>> >  #include <linux/ioport.h>
>> >  #include <linux/module.h>
>> > +#include <linux/pci.h>
>> >
>> >  #include <asm/bios_ebda.h>
>> >  #include <asm/paravirt.h>
>> > @@ -99,3 +100,8 @@ struct x86_platform_ops x86_platform = {
>> >  };
>> >
>> >  EXPORT_SYMBOL_GPL(x86_platform);
>> > +struct x86_msi_ops x86_msi = {
>> > +   .setup_msi_irqs = native_setup_msi_irqs,
>> > +   .teardown_msi_irq = native_teardown_msi_irq,
>> > +   .teardown_msi_irqs = native_teardown_msi_irqs,
>> > +};
>> > --
>> > 1.7.0.1
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>
