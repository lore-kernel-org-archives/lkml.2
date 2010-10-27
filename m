Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0J0SvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:51:12 -0400
Received: from claw.goop.org ([74.207.240.146]:38068 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab0J0SvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:51:10 -0400
Message-ID: <4CC87499.9050207@goop.org>
Date: Wed, 27 Oct 2010 11:51:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Borislav Petkov <bp@alien8.de>, Ian Campbell <ian.campbell@citrix.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org> <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org> <4CC8649F.5060408@linux.intel.com> <4CC866B0.8000802@goop.org> <4CC86B4A.2050408@linux.intel.com>
In-Reply-To: <4CC86B4A.2050408@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/27/2010 11:11 AM, H. Peter Anvin wrote:
> On 10/27/2010 10:51 AM, Jeremy Fitzhardinge wrote:
>>>
>>> This is what makes me absolutely hate paravirt with a passion...
>>> "let's hid things away in<obscure place>  and make it absolutely
>>> impossible to either follow the code flow or figure out what the
>>> intended semantics are supposed to be."
>>
>> Its not really an obscure place; it's where x86-32 does the rest of its
>> boot-time pagetable adjustments (like cleaning out the low identity
>> maps, etc).  Having those clone_pgd_ranges() floating around in
>> setup_arch() is out of place.
>>
>
> "Cleaning out the low identity maps" is part of what this patchset
> eliminates.

Sorry, I didn't look closely enough; its actually removing mappings
beyond the end of physical memory (though I'm not sure why it is 32-bit
only?).

>   This is exactly a good reason why paravirt_ops damages the kernel --
> it makes it impossible to make forward process.

I don't follow.  Why is it impossible to make forward progress?  How
specifically does pvops make it impossible?

>> It would be a pagefault from Xen preventing a direct write to the pgd
>> level of an active pagetable.  At the point in setup_arch() where it
>> does the first clone_pgd_range() we're already running on swapper_pg_dir
>> and the copy from initial_page_table is outright wrong.
>>
>> As Ian suggests, we could switch Xen to use initial_page_table at boot
>> then move to swapper_pg_dir in the same way native does.
>
> Once the failure was explained, it makes more sense.  Either that or
> just skip this setting if we're already running on swapper_pg_dir.

Yes, that's probably the simplest answer (Ian just proposed it
independently).

> Let me state this clearly: if Xen is going to continue to live as a
> merged platform, it has to have an obligation to follow changes on the
> native platform.  This is not unique to Xen, but rather a universal
> rule for integrated platforms.  Xen is more widely used than a lot of
> the other minority platforms, which means it legitimately gets allowed
> more slack, but that is moderated by its tremendous invasiveness.
>
> Quite frankly, the single biggest thing you could improve is to
> improve documentation about what you expect in terms of semantics of
> various entry points.  There are a number of cleanups which we
> currently cannot do because they are directly mapped to paravirt_ops
> which unclear or nonsensical semantics.  

What do you have in mind?  I'm always pro-cleanup.

> Having a more explicit description of the design space would help there.

I agree.  The hot-path pvops (interrupt control, context switch, mmu
updates, etc) are fairly easily defined, but the init time ops are
pretty ad-hoc and often defy simple definition. 

> paravirt_ops is fundamentally misdesigned as a large monolithic
> driverization layer which combines a lot of unrelated things.  In a
> whole lot of cases it directly duplicates driverization layers already
> in the kernel, meaning we take the cost both in cost clarity and
> performance multiple times.

Again, do you have something specific in mind?  We always adopted the
view that we should use an existing abstraction if one is available,
rather than always extending pvops. If a new common layer comes into
existence that subsumes or obsoletes pvops (or can be easily adoped to
do so), then I'm always eager to do that.

>   The patching technology is nice, and it would be good to have that
> available to other platform layers as well, but paravirt_ops as it
> currently sits is going to have to go at some point.

"pvops" as a single thing is a bit of a misnomer these days, in that it
has been devolving into a number of different functional pieces specific
to different problem domains, with the only unifying thing is that they
share the patching machinery.  They're also all controlled by a single
fat CONFIG_PARAVIRT, but someone posted a patch to separate them out
into distinct config options so they could be enabled/disabled
independently as needed, but it seems it was never merged.  I even
remember acking it.

Aside from that, the notion of pvops has been extending into this
broader notion of supporting non-traditional x86 platforms, and indeed
the hooks I'm referring to here are now part of that (or at least tglx
factored them out of the pvops infrastructure at the same time as the
things like timers and the like).  So really what you're complaining
about is that we have lots of indirection and late binding - and yes,
well, there is rather a lot of that in the kernel overall.

    J
