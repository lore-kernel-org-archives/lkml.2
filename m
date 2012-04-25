Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2DYKHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:07:04 -0400
Received: from [124.207.24.138] ([124.207.24.138]:45100 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab2DYKHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:07:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120424162321.GH3213@phenom.dumpdata.com>
References: <1334913957.2863.1.camel@hp6530s>
	<4F913340.4000202@citrix.com>
	<1334920396.2863.16.camel@hp6530s>
	<1334925508.28331.63.camel@zakaz.uk.xensource.com>
	<20120420164150.GC31062@phenom.dumpdata.com>
	<CAF1ivSamaYzQDwjFqRGrnQ+fCr0D4vLGuG4JRBZ3_GD_y8yY=A@mail.gmail.com>
	<20120423151123.GC24481@phenom.dumpdata.com>
	<CAF1ivSY1GAkqU2gN0P22Tb0pmwagam5UUVMABSgnoH3+C+TY+A@mail.gmail.com>
	<20120424162321.GH3213@phenom.dumpdata.com>
Date: Wed, 25 Apr 2012 18:06:21 +0800
Message-ID: <CAF1ivSYFp7duSCNb+_5teM83icx1O-rY0YVFm7Laq_JLZuzerw@mail.gmail.com>
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

On Wed, Apr 25, 2012 at 12:23 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Apr 24, 2012 at 10:43:53PM +0800, Lin Ming wrote:
>> On Mon, Apr 23, 2012 at 11:11 PM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>> >> >> > How about return -1 on error?
>> >> >> > The calling function can check -1 for error.
>> >> >>
>> >> >> Isn't -1 potentially (at least theoretically) a valid value to read from
>> >> >> one of these registers?
>> >> >
>> >> > Yeah, but then we are back to crashing at bootup (with dom0) :-)
>> >> >
>> >> > Perhaps the fallback is to emulate (so retain some of the original code)
>> >> > as we have been since .. uh 3.0?
>> >>
>> >> Do you mean the return value of io_apic_read in 3.0?
>> >
>> > No. I meant that we would continue to emulate. The improvement
>> > is that now we do:
>> >
>> >       if (reg == 0x1)
>> >               return 0x00170020;
>> >       else if (reg == 0x0)
>> >               return apic << 24;
>> >
>> > instead of 0xfdfdfdfd.
>> >
>> >> It's 0xffffffff.
>> >
>> > Now it is 0xfdfdfdfd.
>> >
>> > I am suggesting that instead of BUG_ON(), we fallback to do returning
>> > an emulatated IO_APIC values - like the ones that this original patch
>> > cooked up..
>>
>> But we still need to return some value if the register is not emulated.
>
> Right. 0xfd;
>>
>> How about below?
>
>
> Almost perfect.
>>
>> unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
>> {
>>         struct physdev_apic apic_op;
>>         int ret;
>>
>>         apic_op.apic_physbase = mpc_ioapic_addr(apic);
>>         apic_op.reg = reg;
>>         ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
>>         if (!ret)
>>                 return apic_op.value;
>>
>>         /* emulate register */
>>         if (reg == 0x1)
>>                 return 0x00170020;
>>         else if (reg == 0x0)
>>                 return apic << 24;
>>         else
>>                 return -1;
>
>        return 0xfd;

Where does this magic number 0xfd come from?

Both native_io_apic_read and xen_io_apic_read does not return 0xfd on error.
