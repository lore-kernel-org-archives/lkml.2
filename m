Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1HWWPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:15:38 -0400
Received: from claw.goop.org ([74.207.240.146]:51024 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab1HWWPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:15:32 -0400
Message-ID: <4E542681.2090703@goop.org>
Date: Tue, 23 Aug 2011 15:15:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com>
In-Reply-To: <4E541154.6090805@zytor.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 01:45 PM, H. Peter Anvin wrote:
> On 08/23/2011 12:53 PM, Jeremy Fitzhardinge wrote:
>> Yes, that would ideal.  The closest you can get is asm goto(), but the
>> syntax for that would be awful; something like:
>>
>> #define cmpxchg_jump(ptr, old, new, fail)\
>> 	asm goto (...)
>>
>>
>> :
>> :
>>
>> again:
>> 	old = *thingp;
>> 	new = frobulate(old);
>> 	cmpxchg_jump(thingp, old, new, again);
>> 	/* worked */
>>
>> Would this be useful enough?
>>
> Actually there is a trick:
>
> static inline bool ....
> {
> 	asm goto(... yes);
> no:
> 	return false;
> yes:
> 	return true;
> }
>
> ... which makes syntax a heckuva lot less awkward.

Yeah, but you'd need to define an inline for each type, since the
function isn't polymorphic.  But it can be done with a macro.

However, having prototyped it, I dunno, it doesn't really seem like much
of a win for all the extra code it adds.  I just can't get too excited
about an extra test instruction adjacent to a monster like a locked
cmpxchg.  The jump variant avoids the test, but gcc still generates some
pretty bogus stuff:

        lock; cmpxchgq %rbx,(%rcx); jne .L88    # D.24853, MEM[(volatile u64 *)top_p_26],
# 0 "" 2
#NO_APP
        jmp     .L87    #
.L88:
        xorl    %esi, %esi      #
        movq    %rbx, %rdi      # D.24853,
        call    free_pages      #
.L87:
        addq    p2m_top_mfn(%rip), %r13 # p2m_top_mfn, D.24896
        movq    p2m_top_mfn_p(%rip), %rax       # p2m_top_mfn_p, p2m_top_mfn_p


and adding unlikely()s doesn't help at all.

    J
