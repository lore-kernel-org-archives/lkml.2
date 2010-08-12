Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab0HLFCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 01:02:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0HLFCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 01:02:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=bOkjOTc0kD35yFJRtxM0F/dk0YCoCTB0OkavbnfrhDiOHSt7haM694Ih7G68wNaZA
	btdKG22TnxmDZic+kwMhg==
MIME-Version: 1.0
In-Reply-To: <AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
Date: Wed, 11 Aug 2010 22:02:13 -0700
Message-ID: <AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on 
	active read lock
From: Michel Lespinasse <walken@google.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 6:24 PM, Tony Luck <tony.luck@intel.com> wrote:
> Linus tree this morning[1] was behaving badly on ia64 ... processes would wander
> off into some unkillable state ... and since this happened to processes starting
> from rc*.d I couln't get the system up to a login prompt. System is a 32-way
> (4 sockets * quad-core * hyperthread).
>
> git bisect pins the blame on this change (commit 424acaaeb...).
> Reverting it (and
> it's successor a8618a0e - because I assumed that it depended on 424...) gives
> me a kernel that works fine.

Thanks for the report. FYI, a8618a0e does not depend on 424acaae so it
should be fine if you only revert 424acaae

> Not sure what is wrong with this change. Maybe ia64 needs some more memory
> ordering bits than the changed code provides? I can dig into it a bit
> harder tomorrow,
> but I thought you'd like an early heads-up in case anyone else is seeing similar
> problems.

In arch/ia64/include/asm/rwsem.h I see RWSEM_WAITING_BIAS defined as
-__IA64_UL_CONST(0x0000000100000000)

This makes it a large, positive unsigned value. This is probably
throwing off the rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS
comparison in my patch (supposed to be long versus long, but actually
is long versus unsigned long on ia64).

Also, it looks like ia64 uses intrinsics for the atomic accesses, not
asm (that I could see in a 5 minute look around), so maybe one could
just get rid of the __IA64_UL_CONST macros ???

I can not compile or test on ia64, but could you report as to what
happens if you replace the #defines in arch/ia64/include/asm/rwsem.h
with:
#define RWSEM_UNLOCKED_VALUE __IA64_UL_CONST(0x0000000000000000)
#define RWSEM_ACTIVE_BIAS (1L)
#define RWSEM_ACTIVE_MASK (0xffffffffL)
#define RWSEM_WAITING_BIAS (-0x100000000L)
#define RWSEM_ACTIVE_READ_BIAS RWSEM_ACTIVE_BIAS
#define RWSEM_ACTIVE_WRITE_BIAS (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)


Cheers,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
