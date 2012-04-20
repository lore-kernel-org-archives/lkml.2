Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2DTLOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:14:46 -0400
Received: from [124.207.24.138] ([124.207.24.138]:44321 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2DTLOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:14:45 -0400
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4F913340.4000202@citrix.com>
References: <1334913957.2863.1.camel@hp6530s>  <4F913340.4000202@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 20 Apr 2012 19:13:16 +0800
Message-ID: <1334920396.2863.16.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 10:58 +0100, Andrew Cooper wrote:
> On 20/04/12 10:25, Lin Ming wrote:
> > Implements xen_io_apic_read with hypercall, so it returns proper IO-APIC
> > information instead of fabricated one.
> >
> > Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
> > ---
> >  arch/x86/xen/apic.c |   16 +++++++++++-----
> >  1 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
> > index aee16ab..f1f392d 100644
> > --- a/arch/x86/xen/apic.c
> > +++ b/arch/x86/xen/apic.c
> > @@ -1,14 +1,20 @@
> >  #include <linux/init.h>
> >  #include <asm/x86_init.h>
> > +#include <asm/apic.h>
> > +#include <xen/interface/physdev.h>
> > +#include <asm/xen/hypercall.h>
> >  
> >  unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
> >  {
> > -	if (reg == 0x1)
> > -		return 0x00170020;
> > -	else if (reg == 0x0)
> > -		return apic << 24;
> > +	struct physdev_apic apic_op;
> > +	int ret;
> >  
> > -	return 0xff;
> > +	apic_op.apic_physbase = mpc_ioapic_addr(apic);
> > +	apic_op.reg = reg;
> > +	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
> > +	if (ret)
> > +		return ret;
> > +	return apic_op.value;
> 
> Hypercall ret errors are negative, yet this function is unsigned.  Given
> that the previous function had no possible way to fail, perhaps on error
> you should fake up the values as before.

How about return -1 on error?
The calling function can check -1 for error. 

unsigned int ret = apic_read(...);
if (ret == -1)
	//handle error.

Thanks,
Lin Ming


