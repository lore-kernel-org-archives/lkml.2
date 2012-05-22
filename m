Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705Ab2EVPqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:46:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759276Ab2EVPqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:46:00 -0400
Message-ID: <4FBBB4A0.7010500@redhat.com>
Date: Tue, 22 May 2012 18:45:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: NMI vs #PF clash
References: <4FBB8C40.6080304@redhat.com> <1337693441.13348.36.camel@gandalf.stny.rr.com> <4FBB986F.5030306@redhat.com> <1337695780.13348.41.camel@gandalf.stny.rr.com> <4FBBA094.3090703@redhat.com> <1337696825.13348.44.camel@gandalf.stny.rr.com> <CA+55aFwx3QjNB2ckQfsThhDn7=Bm1d=n0Ai8zawbpLKBKgugGg@mail.gmail.com>
In-Reply-To: <CA+55aFwx3QjNB2ckQfsThhDn7=Bm1d=n0Ai8zawbpLKBKgugGg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 06:33 PM, Linus Torvalds wrote:
> On Tue, May 22, 2012 at 7:27 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> Is reading it fast? Then we could do a two reads and only write when
>> needed.
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

do_page_fault() is not the only code that relies on cr2; vmx_vcpu_run()
is the other.  If an NMI happens there, and takes a #PF, then the guest
will run with a bad cr2.

(svm saves and restores cr2 in microcode, and also provides a way to
mask NMIs, so it isn't vulnerable to this issue).

-- 
error compiling committee.c: too many arguments to function
