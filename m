Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2LMO6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:58:17 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:9878 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2LMO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:58:12 -0500
Message-ID: <50C9ECFF.6070708@tilera.com>
Date: Thu, 13 Dec 2012 09:58:07 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: provide PT_FLAGS_COMPAT value in pt_regs
References: <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com> <20121212234307.GA7694@redhat.com>
In-Reply-To: <20121212234307.GA7694@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 6:43 PM, Oleg Nesterov wrote:
> Hi Chris,
>
> it is too late for me to even try to read this patch, but...

Thanks for the review!

> On 12/12, Chris Metcalf wrote:
>> This flag is set for ptrace GETREGS or PEEKUSER for processes
>> that are COMPAT, i.e. 32-bit.
>            ^^^^^^^^^^^^^^^^^^^
>
> at least on x86 this is not the same. TS_COMPAT can also be set if a 64-bit
> task calls the 32-bit syscall.

There's no way on tile for that to happen.  The OS chooses which syscall implementation to provide based on the Elf class of the loaded executable; the syscall instruction in userspace is the same either way.

In fact, SO MUCH is identical in the two environments that I couldn't think of a good way for strace to be able to easily figure out whether it was a 32- or 64-bit environment - thus this patch :-)

>> --- a/arch/tile/include/uapi/asm/ptrace.h
>> +++ b/arch/tile/include/uapi/asm/ptrace.h
>> @@ -84,5 +84,11 @@ struct pt_regs {
>>  #define PTRACE_O_TRACEMIGRATE	0x00010000
>>  #define PTRACE_EVENT_MIGRATE	16
>>
>> +/*
>> + * Flag bits in pt_regs.flags that are part of the ptrace API.
>> + * We start our numbering higher up to avoid confusion with the
>> + * non-ABI kernel-internal values that use the low 16 bits.
>> + */
>> +#define PT_FLAGS_COMPAT		0x10000  /* process is an -m32 compat process */
> Can't understand how this connects to ptrace (I mean task->ptrace).

The idea is that while other architectures have things in their registers that identify a 32-bit execution environment, tile doesn't.  For example, PPC has a bit in the MSR and x86 has a different value in the CS register.  So for tile I just synthesize a bit to report in the existing "flags" word of the struct pt_regs.

> OK, let it live in asm/ptrace.h, but it seems that it is similar to
> (say) PT_FLAGS_RESTORE_REGS and thus it should be 8?

The other bits that live in that word are kernel-internal only, e.g. PT_FLAGS_RESTORE_REGS.  So they are not in the uapi header.  And in fact, we don't even report them out through the GETREGS API; we just set the single user-visible bit.  In principle we could even overlap the numbering and make PT_FLAGS_COMPAT have value "1" as well, but that seemed excessively confusing.

> And. arch/tile/kernel/ptrace.c:arch_ptrace() does
>
> 	case PTRACE_SETOPTIONS:
> 		/* Support TILE-specific ptrace options. */
> 		child->ptrace &= ~PT_TRACE_MASK_TILE;
> 		tmp = data & PTRACE_O_MASK_TILE;
> 		data &= ~PTRACE_O_MASK_TILE;
>
> AFAICS we need something like BUILD_BUG_ON(PTRACE_O_MASK_TILE & PTRACE_O_MASK),

I don't think so.  These are disjoint namespaces anyway.  PTRACE_O_MASK_TILE is for the actual PTRACE_SETOPTIONS ABI values.  PT_TRACE_MASK_TILE is for the values stored in task->ptrace.

> and
>
> 		ret = ptrace_request(child, request, addr, data);
> 		if (tmp & PTRACE_O_TRACEMIGRATE)
> 			child->ptrace |= PT_TRACE_MIGRATE;
>
> this also needs "ret == 0" check

The question is, what happens if we pass some illegal bit to the generic ptrace_request(), and also pass a valid PTRACE_O_MASK_TILE bit?  Currently we set the tile-specific bit, then report the error.  This is consistent with how ptrace_setoptions() handles a mix of legal and illegal bits.

> and "&= ~PT_TRACE_MASK_TILE" abobe should be moved here, no?

We could move it, but I don't think there's a correctness argument here.  Are you just seeing it would be easier to understand if the manipulation of child->ptrace was all on adjacent lines of code?  I agree that does seem a bit clearer; I'll post a separate patch for that.

> OTOH using /bin/grep I can't see where do we check ">ptrace & PT_TRACE_MIGRATE".

Yes, in our internal tree, this is part of the "dynamic homecache" code that lets us adjust the owner cache for some pages of a task's address space when it migrates to a new core.  It's not actually strictly dependent on that functionality but just got bundled in with it for convenience.  And since we haven't yet tried to return that code (it's somewhat intrusive to the core mm stuff) there's not much point to the ptrace extension. :-)  Oh well, we'll try to push it at some point.

> In short: confused ;)
>
> Oleg.

I hope this clears it up a bit.  Let me know if the patch makes sense to you now! :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

