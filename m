Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0GNSKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:10:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab0GNSKp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <20100714170617.GB4955@Krystal>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
Date: Wed, 14 Jul 2010 11:10:20 -0700
Message-ID: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:06 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>>
>> This patch (1/2) doesn't look horrible per se. I have no problems with
>> it. I just want to understand why it is needed.

[ And patch 2/2 is much more intrusive, and touches a critical path
too.. If it was just the 1/2 series, I don't think I would care. For
the 2/2, I think I'd want to explore all the alternative options ]

> The problem originally addressed by this patch is the case where a NMI handler
> try to access vmalloc'd per-cpu data, which goes as follow:
>
> - One CPU does a fork(), which copies the basic kernel mappings.
> - Perf allocates percpu memory for buffer control data structures.
>  This mapping does not get copied.
> - Tracing is activated.
> - switch_to() to the newly forked process which missed the new percpu
>  allocation.
> - We take a NMI, which touches the vmalloc'd percpu memory in the Perf tracing
>  handler, therefore leading to a page fault in NMI context. Here, we might be
>  in the middle of switch_to(), where ->current might not be in sync with the
>  current cr3 register.

Ok. I was wondering why anybody would allocate core percpu variables
so late that this would ever be an issue, but I guess perf is a
reasonable such case. And reasonable to do from NMI.

That said - grr. I really wish there was some other alternative than
adding yet more complexity to the exception return path. That "iret
re-enables NMI's unconditionally" thing annoys me.

In fact, I wonder if we couldn't just do a software NMI disable
instead? Hav ea per-cpu variable (in the _core_ percpu areas that get
allocated statically) that points to the NMI stack frame, and just
make the NMI code itself do something like

 NMI entry:
 - load percpu NMI stack frame pointer
 - if non-zero we know we're nested, and should ignore this NMI:
    - we're returning to kernel mode, so return immediately by using
"popf/ret", which also keeps NMI's disabled in the hardware until the
"real" NMI iret happens.
    - before the popf/iret, use the NMI stack pointer to make the NMI
return stack be invalid and cause a fault
  - set the NMI stack pointer to the current stack pointer

 NMI exit (not the above "immediate exit because we nested"):
   clear the percpu NMI stack pointer
   Just do the iret.

Now, the thing is, now the "iret" is atomic. If we had a nested NMI,
we'll take a fault, and that re-does our "delayed" NMI - and NMI's
will stay masked.

And if we didn't have a nested NMI, that iret will now unmask NMI's,
and everything is happy.

Doesn't the above sound like a good solution? In other words, we solve
the whole problem by simply _fixing_ the crazy Intel "iret-vs-NMI"
semantics. And we don't need to change the hotpath, and we'll just
_allow_ nested faults within NMI's.

Am I missing something? Maybe I'm not as clever as I think I am... But
I _feel_ clever.

                   Linus
