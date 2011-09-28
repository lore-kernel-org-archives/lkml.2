Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1I1RSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:18:08 -0400
Received: from claw.goop.org ([74.207.240.146]:38473 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab1I1RR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:17:57 -0400
Message-ID: <4E834EE9.70102@goop.org>
Date: Wed, 28 Sep 2011 09:44:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        KVM <kvm@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <3300108.XQUp9Wrktc@chlor> <4E81FD52.50106@goop.org> <33782147.oLTY4kzH1r@chlor>
In-Reply-To: <33782147.oLTY4kzH1r@chlor>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 06:58 AM, Stephan Diestelhorst wrote:
> I have tested this and have not seen it fail on publicly released AMD
> systems. But as I have tried to point out, this does not mean it is
> safe to do in software, because future microarchtectures may have more
> capable forwarding engines.

Sure.

>> Have you tested this, or is this just from code analysis (which I
>> agree with after reviewing the ordering rules in the Intel manual).
> We have found a similar issue in Novell's PV ticket lock implementation
> during internal product testing.

Jan may have picked it up from an earlier set of my patches.

>>> Since you want to get that addb out to global memory before the second
>>> read, either use a LOCK prefix for it, add an MFENCE between addb and
>>> movzwl, or use a LOCKed instruction that will have a fencing effect
>>> (e.g., to top-of-stack)between addb and movzwl.
>> Hm.  I don't really want to do any of those because it will probably
>> have a significant effect on the unlock performance; I was really trying
>> to avoid adding any more locked instructions.  A previous version of the
>> code had an mfence in here, but I hit on the idea of using aliasing to
>> get the ordering I want - but overlooked the possible effect of store
>> forwarding.
> Well, I'd be curious about the actual performance impact. If the store
> needs to commit to memory due to aliasing anyways, this would slow down
> execution, too. After all it is better to write working than fast code,
> no? ;-)

Rule of thumb is that AMD tends to do things like lock and fence more
efficiently than Intel - at least historically.  I don't know if that's
still true for current Intel microarchitectures.

>> I guess it comes down to throwing myself on the efficiency of some kind
>> of fence instruction.  I guess an lfence would be sufficient; is that
>> any more efficient than a full mfence?
> An lfence should not be sufficient, since that essentially is a NOP on
> WB memory. You really want a full fence here, since the store needs to
> be published before reading the lock with the next load.

The Intel manual reads:

    Reads cannot pass earlier LFENCE and MFENCE instructions.
    Writes cannot pass earlier LFENCE, SFENCE, and MFENCE instructions.
    LFENCE instructions cannot pass earlier reads.

Which I interpreted as meaning that an lfence would prevent forwarding. 
But I guess it doesn't say "lfence instructions cannot pass earlier
writes", which means that the lfence could logically happen before the
write, thereby allowing forwarding?  Or should I be reading this some
other way?

>> Could you give me a pointer to AMD's description of the ordering rules?
> They should be in "AMD64 Architecture Programmer's Manual Volume 2:
> System Programming", Section 7.2 Multiprocessor Memory Access Ordering.
>
> http://developer.amd.com/documentation/guides/pages/default.aspx#manuals
>
> Let me know if you have some clarifying suggestions. We are currently
> revising these documents...

I find the English descriptions of these kinds of things frustrating to
read because of ambiguities in the precise meaning of words like "pass",
"ahead", "behind" in these contexts.  I find the prose useful to get an
overview, but when I have a specific question I wonder if something more
formal would be useful.
I guess it's implied that anything that is not prohibited by the
ordering rules is allowed, but it wouldn't hurt to say it explicitly.
That said, the AMD description seems clearer and more explicit than the
Intel manual (esp since it specifically discusses the problem here).

Thanks,
    J
