Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2DTQrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:47:03 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22491 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2DTQrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:47:01 -0400
Date: Fri, 20 Apr 2012 12:41:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Lin Ming <mlin@ss.pku.edu.cn>, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
Message-ID: <20120420164150.GC31062@phenom.dumpdata.com>
References: <1334913957.2863.1.camel@hp6530s>
 <4F913340.4000202@citrix.com>
 <1334920396.2863.16.camel@hp6530s>
 <1334925508.28331.63.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334925508.28331.63.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F9192FD.000E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 01:38:28PM +0100, Ian Campbell wrote:
> On Fri, 2012-04-20 at 12:13 +0100, Lin Ming wrote:
> > On Fri, 2012-04-20 at 10:58 +0100, Andrew Cooper wrote:
> > > On 20/04/12 10:25, Lin Ming wrote:
> > > > Implements xen_io_apic_read with hypercall, so it returns proper IO-APIC
> > > > information instead of fabricated one.
> > > >
> > > > Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
> > > > ---
> > > >  arch/x86/xen/apic.c |   16 +++++++++++-----
> > > >  1 files changed, 11 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
> > > > index aee16ab..f1f392d 100644
> > > > --- a/arch/x86/xen/apic.c
> > > > +++ b/arch/x86/xen/apic.c
> > > > @@ -1,14 +1,20 @@
> > > >  #include <linux/init.h>
> > > >  #include <asm/x86_init.h>
> > > > +#include <asm/apic.h>
> > > > +#include <xen/interface/physdev.h>
> > > > +#include <asm/xen/hypercall.h>
> > > >  
> > > >  unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
> > > >  {
> > > > -	if (reg == 0x1)
> > > > -		return 0x00170020;
> > > > -	else if (reg == 0x0)
> > > > -		return apic << 24;
> > > > +	struct physdev_apic apic_op;
> > > > +	int ret;
> > > >  
> > > > -	return 0xff;
> > > > +	apic_op.apic_physbase = mpc_ioapic_addr(apic);
> > > > +	apic_op.reg = reg;
> > > > +	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +	return apic_op.value;
> > > 
> > > Hypercall ret errors are negative, yet this function is unsigned.  Given
> > > that the previous function had no possible way to fail, perhaps on error
> > > you should fake up the values as before.
> > 
> > How about return -1 on error?
> > The calling function can check -1 for error. 
> 
> Isn't -1 potentially (at least theoretically) a valid value to read from
> one of these registers?

Yeah, but then we are back to crashing at bootup (with dom0) :-)

Perhaps the fallback is to emulate (so retain some of the original code)
as we have been since .. uh 3.0?

> 
> Under what circumstances can these hypercalls fail? Would a BUG_ON be
> appropriate/
> 
> > unsigned int ret = apic_read(...);
> > if (ret == -1)
> > 	//handle error.
> > 
> > Thanks,
> > Lin Ming
> > 
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
