Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2DWInS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:43:18 -0400
Received: from [124.207.24.138] ([124.207.24.138]:60113 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2DWInQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:43:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120420164150.GC31062@phenom.dumpdata.com>
References: <1334913957.2863.1.camel@hp6530s>
	<4F913340.4000202@citrix.com>
	<1334920396.2863.16.camel@hp6530s>
	<1334925508.28331.63.camel@zakaz.uk.xensource.com>
	<20120420164150.GC31062@phenom.dumpdata.com>
Date: Mon, 23 Apr 2012 16:42:36 +0800
Message-ID: <CAF1ivSamaYzQDwjFqRGrnQ+fCr0D4vLGuG4JRBZ3_GD_y8yY=A@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with hypercall
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 12:41 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Apr 20, 2012 at 01:38:28PM +0100, Ian Campbell wrote:
>> On Fri, 2012-04-20 at 12:13 +0100, Lin Ming wrote:
>> > On Fri, 2012-04-20 at 10:58 +0100, Andrew Cooper wrote:
>> > > On 20/04/12 10:25, Lin Ming wrote:
>> > > > Implements xen_io_apic_read with hypercall, so it returns proper IO-APIC
>> > > > information instead of fabricated one.
>> > > >
>> > > > Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
>> > > > ---
>> > > >  arch/x86/xen/apic.c |   16 +++++++++++-----
>> > > >  1 files changed, 11 insertions(+), 5 deletions(-)
>> > > >
>> > > > diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
>> > > > index aee16ab..f1f392d 100644
>> > > > --- a/arch/x86/xen/apic.c
>> > > > +++ b/arch/x86/xen/apic.c
>> > > > @@ -1,14 +1,20 @@
>> > > >  #include <linux/init.h>
>> > > >  #include <asm/x86_init.h>
>> > > > +#include <asm/apic.h>
>> > > > +#include <xen/interface/physdev.h>
>> > > > +#include <asm/xen/hypercall.h>
>> > > >
>> > > >  unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
>> > > >  {
>> > > > -       if (reg == 0x1)
>> > > > -               return 0x00170020;
>> > > > -       else if (reg == 0x0)
>> > > > -               return apic << 24;
>> > > > +       struct physdev_apic apic_op;
>> > > > +       int ret;
>> > > >
>> > > > -       return 0xff;
>> > > > +       apic_op.apic_physbase = mpc_ioapic_addr(apic);
>> > > > +       apic_op.reg = reg;
>> > > > +       ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
>> > > > +       if (ret)
>> > > > +               return ret;
>> > > > +       return apic_op.value;
>> > >
>> > > Hypercall ret errors are negative, yet this function is unsigned.  Given
>> > > that the previous function had no possible way to fail, perhaps on error
>> > > you should fake up the values as before.
>> >
>> > How about return -1 on error?
>> > The calling function can check -1 for error.
>>
>> Isn't -1 potentially (at least theoretically) a valid value to read from
>> one of these registers?
>
> Yeah, but then we are back to crashing at bootup (with dom0) :-)
>
> Perhaps the fallback is to emulate (so retain some of the original code)
> as we have been since .. uh 3.0?

Do you mean the return value of io_apic_read in 3.0?
It's 0xffffffff.

Lin Ming

>
>>
>> Under what circumstances can these hypercalls fail? Would a BUG_ON be
>> appropriate/
>>
>> > unsigned int ret = apic_read(...);
>> > if (ret == -1)
>> >     //handle error.
>> >
>> > Thanks,
>> > Lin Ming
