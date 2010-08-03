Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0HCLI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:08:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34027 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab0HCLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:08:56 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>
	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>
	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>
	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org>
	<m17hk8oy5g.fsf@fess.ebiederm.org> <4C57E32A.9070401@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 04:08:49 -0700
In-Reply-To: <4C57E32A.9070401@kernel.org> (Yinghai Lu's message of "Tue\, 03 Aug 2010 02\:36\:42 -0700")
Message-ID: <m18w4onebi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 08/03/2010 02:15 AM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>> 
>> 
>> You can't share an edge triggered ISA irq, it isn't really physically
>> possible.  So I don't see how this extra complexity will change anything.
>> 

>
> Dave's system mptble:

Interesting he has ISA irqs on bus #10 on the same apic id and pin as
pci irqs.  Blink.  I had missed we had that print out.

The immediate issue are these lines:
> Int: type 0, pol 0, trig 0, bus 03, IRQ 00, APIC ID 0, APIC INT 10
> Int: type 0, pol 0, trig 0, bus 04, IRQ 00, APIC ID 0, APIC INT 10
> Int: type 0, pol 0, trig 0, bus 04, IRQ 01, APIC ID 0, APIC INT 11

Which get the apic id wrong, and thus cause us to mishandle them and
get 

You are right Dave's mptable does the  arguably broken:

> Int: type 0, pol 0, trig 0, bus 00, IRQ 28, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 00, IRQ 34, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 01, IRQ 02, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 05, IRQ 01, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 07, IRQ 0c, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 07, IRQ 12, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 07, IRQ 15, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 07, IRQ 28, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 08, IRQ 01, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 09, IRQ 02, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 09, APIC ID 8, APIC INT 09

Where busses 0,1,5,6,7,8,9 result in level triggered interrupts and
bus 0x0a results in an edge triggered interrupt.

As I read the code.  First we will do a generic isa setup, marking the
interrupt ioapic table entry edge triggered.  Then we will do a pci
setup for any pin we use as pci, and then we will set pin_programmed
stopping us from updating the pin any more, during setup.

For the common case I think we still do the right thing, even now, for
these broken bios tables.  There is likely an uncommon case for which
something like your shared_legacy_irq deserves to be used, especially
at it preserves our well tested historical behavior.

Eric

