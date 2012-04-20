Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2DTMic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 08:38:32 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:40274 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2DTMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 08:38:31 -0400
X-IronPort-AV: E=Sophos;i="4.75,454,1330905600"; 
   d="scan'208";a="12047897"
Message-ID: <1334925508.28331.63.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
CC: Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Date: Fri, 20 Apr 2012 13:38:28 +0100
In-Reply-To: <1334920396.2863.16.camel@hp6530s>
References: <1334913957.2863.1.camel@hp6530s>  <4F913340.4000202@citrix.com>
	 <1334920396.2863.16.camel@hp6530s>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 12:13 +0100, Lin Ming wrote:
> On Fri, 2012-04-20 at 10:58 +0100, Andrew Cooper wrote:
> > On 20/04/12 10:25, Lin Ming wrote:
> > > Implements xen_io_apic_read with hypercall, so it returns proper IO-APIC
> > > information instead of fabricated one.
> > >
> > > Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
> > > ---
> > >  arch/x86/xen/apic.c |   16 +++++++++++-----
> > >  1 files changed, 11 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
> > > index aee16ab..f1f392d 100644
> > > --- a/arch/x86/xen/apic.c
> > > +++ b/arch/x86/xen/apic.c
> > > @@ -1,14 +1,20 @@
> > >  #include <linux/init.h>
> > >  #include <asm/x86_init.h>
> > > +#include <asm/apic.h>
> > > +#include <xen/interface/physdev.h>
> > > +#include <asm/xen/hypercall.h>
> > >  
> > >  unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
> > >  {
> > > -	if (reg == 0x1)
> > > -		return 0x00170020;
> > > -	else if (reg == 0x0)
> > > -		return apic << 24;
> > > +	struct physdev_apic apic_op;
> > > +	int ret;
> > >  
> > > -	return 0xff;
> > > +	apic_op.apic_physbase = mpc_ioapic_addr(apic);
> > > +	apic_op.reg = reg;
> > > +	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
> > > +	if (ret)
> > > +		return ret;
> > > +	return apic_op.value;
> > 
> > Hypercall ret errors are negative, yet this function is unsigned.  Given
> > that the previous function had no possible way to fail, perhaps on error
> > you should fake up the values as before.
> 
> How about return -1 on error?
> The calling function can check -1 for error. 

Isn't -1 potentially (at least theoretically) a valid value to read from
one of these registers?

Under what circumstances can these hypercalls fail? Would a BUG_ON be
appropriate/

> unsigned int ret = apic_read(...);
> if (ret == -1)
> 	//handle error.
> 
> Thanks,
> Lin Ming
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


