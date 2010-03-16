Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966045Ab0CPJSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:18:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59421 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab0CPJSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:18:38 -0400
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86\@kernel.org" <x86@kernel.org>,
       "linuxppc-dev\@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct irq_chip.
References: <1268387091.10129.5973.camel@zakaz.uk.xensource.com>
	<1268387116-30522-1-git-send-email-ian.campbell@citrix.com>
	<4B9A954A.40205@kernel.org> <m1ocit5aj1.fsf@fess.ebiederm.org>
	<1268729412.8652.4254.camel@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 16 Mar 2010 02:18:26 -0700
In-Reply-To: <1268729412.8652.4254.camel@localhost.localdomain> (Ian Campbell's message of "Tue\, 16 Mar 2010 08\:50\:12 +0000")
Message-ID: <m1y6hswrod.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: Ian.Campbell@citrix.com, linuxppc-dev@ozlabs.org, x86@kernel.org, paulus@samba.org, benh@kernel.crashing.org, jeremy@goop.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <Ian.Campbell@citrix.com> writes:

> On Sat, 2010-03-13 at 00:29 +0000, Eric W. Biederman wrote: 
>> [...]
>> > after that xen could use
>> > irq_to_desc_alloc_node_f(irq, node, xen_init_chip_data);
>> >
>> > as need...
>> >
>> > at last we don't need to call x86_init_chip_data everywhere.
>
> This was one of the things I was considering. It seems like one of the
> easiest solutions to make work correctly with the current locking in
> e.g. irq_to_desc_alloc_node since the callback would always happen under
> the lock taken in that function.
>
>> So trying to evaluate races.  The worse case for this particular piece
>> of code appears to be create_irq_nr.  As this is the only place where
>> we are setting up irqs and possibly repurposing the structure.
>
> Yes, create_irq_nr was one of the functions I was struggling to solve
> cleanly. There is a similar construct in the Xen code as well.
>
> Part of the problem I'm having is the combination of lookup and allocate
> in irq_to_desc_alloc_node but also the kind of "implicit" repurposing is
> tricky to deal with. (by implicit I just mean that I can't find where
> the previous user explicitly says they are finished with it, if you see
> what I mean)
>
> What do you think of adding an explicit free operation for the irq_desc
> structs? (does one already exist? I couldn't find it). This would go
> along with some tracking of allocation state, trivial in the sparse case
> where you can treat a NULL node in the radix tree as unallocated, I
> guess a flag would suffice in the static array non-sparse case?

We have free_one_irq_desc used in the numa irq migration code.
We have dynamic_irq_cleanup.

I don't expect it would be fundamentally hard to put all of the pieces
together.

> Going further could we split the alloc and lookup functions into
> separate operations instead of combining them in irq_to_desc_alloc_node?
> We already have irq_to_desc for the lookup portion so this would largely
> involve changes to the semantics of irq_to_desc_alloc_node, perhaps
> returning ERR_PTR(-EBUSY) if the node was already allocated.
>
> Having a variant which found a free IRQ rather than operating on a
> specific requested IRQ could also be useful for create_irq_nr as well as
> find_unbound_irq on the Xen side. I'm not convinced irq_alloc_virt on
> powerpc isn't implementing broadly the same concept as well, although it
> seems to work very differently from the other two.
>
>>   Today
>> we figure out if an irq has been assigned by looking at irq_cfg->vector,
>> and if it is non-zero the irq has been assigned.
>
> Which is tricky to move into generic code hence my suggestions of
> explicitly freeing the irq_desc and tracking the allocation status in
> the generic code. 

Agreed.  Getting an allocation assist into the generic code sounds
nlike something for the next round of patches after your current one.
At least for msi irqs, hi irqs and other irqs that are totally software
constructs this makes a lot of sense.

We really need to get to the point on x86 where sparse irq has no penalties
and stop making it an option.  Otherwise it gets a bit tricky to rely
on sparse irq for an allocation helper.

I need to go look up my old patchset.  I did something different with
create_irq(), that I think was cleaner and it may be worth resurrecting.
At the very least I generalized the msi case and the ht irq case into
using the same pointer in struct irq_desc.

>> The logic in x86_init_chip_data is correct we only assign desc->chip_data
>> if the generic layers are above it.  However we need a lock to ensure that
>> two paths don't race in that comparison and that assignment.  There is
>> no lock in x86_init_chip_data.  Which unfortunately means as it stands
>> this patchset is buggy.
>
> Yes, unfortunately I think you are right. The callback idea fixes this.
> I'll respin with that.

Thanks.

Eric

