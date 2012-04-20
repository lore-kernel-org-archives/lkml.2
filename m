Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab2DTMwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 08:52:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43896 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2DTMwY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 20 Apr 2012 08:52:24 -0400
Message-Id: <4F917823020000780007EDDF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 20 Apr 2012 13:52:19 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>, "Lin Ming" <mlin@ss.pku.edu.cn>
Cc: "Andrew Cooper" <Andrew.Cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
References: <1334913957.2863.1.camel@hp6530s> <4F913340.4000202@citrix.com>
 <1334920396.2863.16.camel@hp6530s>
 <1334925508.28331.63.camel@zakaz.uk.xensource.com>
In-Reply-To: <1334925508.28331.63.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.04.12 at 14:38, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> On Fri, 2012-04-20 at 12:13 +0100, Lin Ming wrote:
>> On Fri, 2012-04-20 at 10:58 +0100, Andrew Cooper wrote:
>> > On 20/04/12 10:25, Lin Ming wrote:
>> > > Implements xen_io_apic_read with hypercall, so it returns proper IO-APIC
>> > > information instead of fabricated one.
>> > >
>> > > Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
>> > > ---
>> > >  arch/x86/xen/apic.c |   16 +++++++++++-----
>> > >  1 files changed, 11 insertions(+), 5 deletions(-)
>> > >
>> > > diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
>> > > index aee16ab..f1f392d 100644
>> > > --- a/arch/x86/xen/apic.c
>> > > +++ b/arch/x86/xen/apic.c
>> > > @@ -1,14 +1,20 @@
>> > >  #include <linux/init.h>
>> > >  #include <asm/x86_init.h>
>> > > +#include <asm/apic.h>
>> > > +#include <xen/interface/physdev.h>
>> > > +#include <asm/xen/hypercall.h>
>> > >  
>> > >  unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
>> > >  {
>> > > -	if (reg == 0x1)
>> > > -		return 0x00170020;
>> > > -	else if (reg == 0x0)
>> > > -		return apic << 24;
>> > > +	struct physdev_apic apic_op;
>> > > +	int ret;
>> > >  
>> > > -	return 0xff;
>> > > +	apic_op.apic_physbase = mpc_ioapic_addr(apic);
>> > > +	apic_op.reg = reg;
>> > > +	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
>> > > +	if (ret)
>> > > +		return ret;
>> > > +	return apic_op.value;
>> > 
>> > Hypercall ret errors are negative, yet this function is unsigned.  Given
>> > that the previous function had no possible way to fail, perhaps on error
>> > you should fake up the values as before.
>> 
>> How about return -1 on error?
>> The calling function can check -1 for error. 
> 
> Isn't -1 potentially (at least theoretically) a valid value to read from
> one of these registers?
> 
> Under what circumstances can these hypercalls fail?

Only when the input is wrong (or it's not a privileged domain).

> Would a BUG_ON be appropriate/

Probably.

Jan

