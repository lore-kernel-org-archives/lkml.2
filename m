Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1HRLxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:53:18 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:1796 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1HRLxR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 18 Aug 2011 07:53:17 -0400
Message-Id: <4E4D19820200007800051D19@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 18 Aug 2011 12:54:10 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <tj@kernel.org>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: Re: x86_32_early_logical_apicid() -> one warning per CPU on
	 late-determined BIGSMP systems
References: <4E43EBDF0200007800050CA7@nat28.tlf.novell.com>
 <20110812101556.GM23842@htj.dyndns.org>
In-Reply-To: <20110812101556.GM23842@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.08.11 at 12:15, Tejun Heo <tj@kernel.org> wrote:
> Hello,
> 
> On Thu, Aug 11, 2011 at 01:49:03PM +0100, Jan Beulich wrote:
>> with generic_processor_info() getting run before generic_bigsmp_probe(),
>> the values obtained by the former though apic->x86_32_early_logical_apicid()
>> (still pointing to default_x86_32_early_logical_apicid() at that time) and
>> stored into early_per_cpu(x86_cpu_to_logical_apicid, cpu) can't possibly
>> match the ones obtained by setup_local_APIC() (since only at this point
>> apic->x86_32_early_logical_apicid() points to bigsmp_early_logical_apicid()),
>> thus causing the warning there to generally trigger on each CPU.
> 
> Ooh, okay, bigsmp switches apic pretty late in the init.  Wouldn't it
> be better to move that to right after dmi init regardless of this
> problem?

No, because this depends on knowing num_possible_cpus(), which
in turn can't be done until after the firmware tables got parsed (and
that's where the ->x86_32_early_logical_apicid() call happens).

>> Except for removing the warning, all other possible solutions to this that
>> I can think of seem ugly to me (i.e. somehow re-initializing
>> x86_cpu_to_logical_apicid for all CPUs), but I wonder why setting up
>> x86_cpu_to_logical_apicid needs to be done this early if prior to
>> setup_local_APIC() doing it a second time the value can't be used for
>> anything anyway (because it could validly be BAD_APICID). If there
>> aren't any future plans (honestly, I can't really make much sense of
>> commit acb8bc09c6185e4d3d582d0076aaa6a89f19d8c5's comment),
>> perhaps x86_32_early_logical_apicid() could get removed again?
> 
> Yeah, the future already came and went.  On x86_32, cpu -> numa node
> mapping API used to require logical apicid and that's the reason why
> logical apicid mapping was needed before processor init so that percpu
> area affinity can be set up correctly.  This is also why the
> requirement was soft - it only affected percpu memory layout.  The API
> is now unified with 64bit and based on cpu number (and physical
> apicid).  Please take a look at commit 89e5dc218e "x86: Replace
> apic->apicid_to_node() with ->x86_32_numa_cpu_node()".
> 
> It's interesting that numaq was the only apic which required logical
> apicid to calculate numa node and it can't even do that before SMP
> bring up making acquiring logical apic ID early rather pointless -
> but, well, it was a necessary transition step as logical apicid was
> entangled with the rest of 32bit numa init.  Anyways, it's untangled
> now and we no longer need early cpu -> logical apicid mapping.
> 
> So, yeah, please go ahead and remove it.

There are quite a few references to this, and some from code that
if I change it I would have no way of testing (Summit, ES7000, NUMAQ).
So no, I don't think I'm in the position to do this cleanup (if it really is
just that).

So for the time being I'll put together a patch re-writing
early_per_cpu(x86_cpu_to_logical_apicid, ...) right after overriding
apic_default with apic_bigsmp.

Jan

