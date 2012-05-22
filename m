Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633Ab2EVPry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:47:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55809 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2EVPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:47:52 -0400
Message-ID: <4FBBB509.4090508@zytor.com>
Date: Tue, 22 May 2012 08:47:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: NMI vs #PF clash
References: <4FBB8C40.6080304@redhat.com> <1337693441.13348.36.camel@gandalf.stny.rr.com> <4FBB986F.5030306@redhat.com> <1337695780.13348.41.camel@gandalf.stny.rr.com> <4FBBA094.3090703@redhat.com> <1337696825.13348.44.camel@gandalf.stny.rr.com> <CA+55aFwx3QjNB2ckQfsThhDn7=Bm1d=n0Ai8zawbpLKBKgugGg@mail.gmail.com>
In-Reply-To: <CA+55aFwx3QjNB2ckQfsThhDn7=Bm1d=n0Ai8zawbpLKBKgugGg@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Even better: we could do nothing at all.
> 
> We could just say: let's make sure that any #PF case that can happen
> in #NMI can also be re-done with arbitrary 'error_code' and 'struct
> regs' contents.
> 
> At that point, what could happen is
>  - #PF
>   - NMI
>    - #PF
>     - read cr2 for NMI fault
>     - handle the NMI #PF
>     - return from #PF
>   - return from #NMI
>   - read cr2 for original #PF fault - but get the NMI cr2 again
>   - hande the #PF again (this should be a no-op now)
>   - return from #PF
>  - instruction restart causes new #PF
>   - now we do the original page fault
> 
> So one option is to just make sure that the few cases (just the
> vmalloc area?) that NMI can trigger are all ok to be re-done with
> other state.
> 
> I note that right now we have
> 
>         if (unlikely(fault_in_kernel_space(address))) {
>                 if (!(error_code & (PF_RSVD | PF_USER | PF_PROT))) {
>                         if (vmalloc_fault(address) >= 0)
>                                 return;
> 
> and that the error_code check means that the retried NMI #PF would not
> go through that. But maybe we don't even need that check?
> 
> That error_code thing seems to literally be the only thing that keeps
> us from just re-doing the vmalloc_fault() silently.
> 

This concerns me for two reasons:

- We would have to process "chimera" pagefaults like the one you showed
above, where we have the right struct regs and the right error code, but
the wrong %cr2 pointing to the page fault context.

- Getting all this right, reliable, tested and robust and have it stay
that way for what is effectively a race between multiple events seems
implausible.  I really worry that we'll have subtle failures in the
field when people are using their debugging tools.

As such I'd prefer if NMI would save and restore %cr2, or, alternately,
NMI can save %cr2 and the #PF handler could check if it is in NMI
context and then restore %cr2 -- the latter depends on the #PF handler
being able to hide the cost of a load - test - not-taken branch in the
common case, otherwise that is an obvious lose.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
