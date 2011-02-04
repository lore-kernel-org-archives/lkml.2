Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab1BDV1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:27:41 -0500
Received: from claw.goop.org ([74.207.240.146]:52354 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab1BDV1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:27:40 -0500
Message-ID: <4D4C6F45.6010204@goop.org>
Date: Fri, 04 Feb 2011 13:27:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] x86: hold mm->page_table_lock while doing vmalloc_sync
References: <4CB76E8B.2090309@goop.org> <4CC0AB73.8060609@goop.org> <20110203024838.GI5843@random.random> <4D4B1392.5090603@goop.org> <20110204012109.GP5843@random.random>
In-Reply-To: <20110204012109.GP5843@random.random>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 05:21 PM, Andrea Arcangeli wrote:
> On Thu, Feb 03, 2011 at 12:44:02PM -0800, Jeremy Fitzhardinge wrote:
>> On 02/02/2011 06:48 PM, Andrea Arcangeli wrote:
>>> Hello,
>>>
>>> Larry (CC'ed) found a problem with the patch in subject. When
>>> USE_SPLIT_PTLOCKS is not defined (NR_CPUS == 2) it will deadlock in
>>> ptep_clear_flush_notify in rmap.c because it's sending IPIs with the
>>> page_table_lock already held, and the other CPUs now spins on the
>>> page_table_lock with irq disabled, so the IPI never runs. With
>>> CONFIG_TRANSPARENT_HUGEPAGE=y this deadlocks happens even with
>>> USE_SPLIT_PTLOCKS defined so it become visible but it needs to be
>>> fixed regardless (for NR_CPUS == 2).
>> What's "it" here?  Do you mean vmalloc_sync_all?  vmalloc_sync_one?
>> What's the callchain?
> Larry just answered to that. If something is unclear let me know. I
> never reproduced it, but it also can happen without THP enabled, you
> just need to set NR_CPUS to 2 during "make menuconfig".
>
>>> spin_lock_irqsave(pgd_lock) so I guess it's either common code, or
>>> it's superfluous and not another Xen special requirement.
>> There's no special Xen requirement here.
> That was my thought too considering the other archs...
>
>> mmdrop() can be called from interrupt context, but I don't know if it
>> will ever drop the last reference from interrupt, so maybe you can get
>> away with it.
> Yes the issue is __mmdrop, so it'd be nice to figure if __mmdrop can
> also run from irq (or only mmdrop fast path which would be safe even
> without _irqsave).
>
> Is this a Xen only thing? Or is mmdrop called from regular
> linux. Considering other archs also _irqsave I assume it's common code
> calling mmdrop (otherwise it means they cut-and-pasted a Xen
> dependency). This comment doesn't really tell me much.

No, I don't think there's any xen-specific code which calls mmdrop (at
all, let alone in interrupt context).  Erm, but I'm not sure where it
does.  I had a thinko that "schedule" would be one of those places, but
calling that from interrupt context would cause much bigger problems :/
> static void pgd_dtor(pgd_t *pgd)
> {
> 	unsigned long flags; /* can be called from interrupt context 	*/
>
> 	if (SHARED_KERNEL_PMD)
> 	   return;
>
> 	   VM_BUG_ON(in_interrupt());
> 	   spin_lock(&pgd_lock);
>
> This comment tells the very __mmdrop can be called from irq context,
> not just mmdrop. But I didn't find where yet... Can you tell me?

No.  I don't think I wrote that comment.  It possibly just some ancient
lore that could have been correct at one point, or perhaps it never true.

>>> @@ -247,7 +248,7 @@ void vmalloc_sync_all(void)
>>>  			if (!ret)
>>>  				break;
>>>  		}
>>> -		spin_unlock_irqrestore(&pgd_lock, flags);
>>> +		spin_unlock(&pgd_lock, flags);
>> Urp.  Did this compile?
> Yes it builds

(spin_unlock() shouldn't take a "flags" arg.)


> I'm not reposting a version that builds for 32bit x86 too until we
> figure out the mmdrop thing...

Stick it in next and look for explosion reports?

    J

