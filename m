Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2CUQpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:45:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36675 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2CUQpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:45:46 -0400
Date: Wed, 21 Mar 2012 12:41:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: jwboyer@redhat.com, mingo@elte.hu, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] xen/x86: Implement x86_apic_ops
Message-ID: <20120321164124.GB16441@phenom.dumpdata.com>
References: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
 <1332288764-10351-1-git-send-email-konrad.wilk@oracle.com>
 <1332288764-10351-4-git-send-email-konrad.wilk@oracle.com>
 <1332293497.16101.90.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332293497.16101.90.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090208.4F6A05B4.0012,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 06:31:37PM -0700, Suresh Siddha wrote:
> On Tue, 2012-03-20 at 20:12 -0400, Konrad Rzeszutek Wilk wrote:
> > Or rather just implement one different function as opposed
> > to the native one : the read function.
> > 
> > We synthesize the values.
> > 
> > Suggested-by:  Suresh Siddha <suresh.b.siddha@intel.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/Makefile    |    2 +-
> >  arch/x86/xen/apic.c      |   17 +++++++++++++++++
> >  arch/x86/xen/enlighten.c |    2 ++
> >  arch/x86/xen/xen-ops.h   |    4 ++++
> >  4 files changed, 24 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/x86/xen/apic.c
> > 
> > diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> > index add2c2d..96ab2c0 100644
> > --- a/arch/x86/xen/Makefile
> > +++ b/arch/x86/xen/Makefile
> > @@ -20,5 +20,5 @@ obj-$(CONFIG_EVENT_TRACING) += trace.o
> >  obj-$(CONFIG_SMP)		+= smp.o
> >  obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
> >  obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
> > -obj-$(CONFIG_XEN_DOM0)		+= vga.o
> > +obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
> >  obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
> > diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
> > new file mode 100644
> > index 0000000..c53b3ef
> > --- /dev/null
> > +++ b/arch/x86/xen/apic.c
> > @@ -0,0 +1,17 @@
> > +#include <linux/init.h>
> > +#include <asm/x86_init.h>
> > +
> > +unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
> > +{
> > +	if (reg == 0x1)
> > +		return 0x00170020;
> > +	else if (reg == 0x0)
> > +		return 0x00000000;
> 
> For IO-APIC ID register (0), you can probably use the argument 'apic' to
> set the ID bits in the returned register.

ok, that would be just
return 0x0000000 | apic

right? Since the last 8 bits are the apic value?
> 
> > +
> > +	return 0xfd;
> 
> 0xff might be better.

<nods> Done!
