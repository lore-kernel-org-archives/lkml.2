Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab2EVPdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:33:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52379 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2EVPdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <1337696825.13348.44.camel@gandalf.stny.rr.com>
References: <4FBB8C40.6080304@redhat.com> <1337693441.13348.36.camel@gandalf.stny.rr.com>
 <4FBB986F.5030306@redhat.com> <1337695780.13348.41.camel@gandalf.stny.rr.com>
 <4FBBA094.3090703@redhat.com> <1337696825.13348.44.camel@gandalf.stny.rr.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 May 2012 08:33:18 -0700
X-Google-Sender-Auth: Kr1VhqUutxEXtZJzQaQh6c655jc
Message-ID: <CA+55aFwx3QjNB2ckQfsThhDn7=Bm1d=n0Ai8zawbpLKBKgugGg@mail.gmail.com>
Subject: Re: NMI vs #PF clash
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 7:27 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Is reading it fast? Then we could do a two reads and only write when
> needed.

Even better: we could do nothing at all.

We could just say: let's make sure that any #PF case that can happen
in #NMI can also be re-done with arbitrary 'error_code' and 'struct
regs' contents.

At that point, what could happen is
 - #PF
  - NMI
   - #PF
    - read cr2 for NMI fault
    - handle the NMI #PF
    - return from #PF
  - return from #NMI
  - read cr2 for original #PF fault - but get the NMI cr2 again
  - hande the #PF again (this should be a no-op now)
  - return from #PF
 - instruction restart causes new #PF
  - now we do the original page fault

So one option is to just make sure that the few cases (just the
vmalloc area?) that NMI can trigger are all ok to be re-done with
other state.

I note that right now we have

        if (unlikely(fault_in_kernel_space(address))) {
                if (!(error_code & (PF_RSVD | PF_USER | PF_PROT))) {
                        if (vmalloc_fault(address) >= 0)
                                return;

and that the error_code check means that the retried NMI #PF would not
go through that. But maybe we don't even need that check?

That error_code thing seems to literally be the only thing that keeps
us from just re-doing the vmalloc_fault() silently.

                          Linus
