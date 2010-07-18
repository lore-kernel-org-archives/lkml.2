Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0GRSSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 14:18:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899Ab0GRSSO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 14:18:14 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTin1noI6IUfuQsbAgVVzj2rSOhm-Cx3WpsMBgdJ6@mail.gmail.com>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714203940.GC22096@Krystal>
	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
	<20100714222115.GA30122@Krystal>
	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>
	<AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>
	<4C42DF9A.5090908@redhat.com>
	<AANLkTin1noI6IUfuQsbAgVVzj2rSOhm-Cx3WpsMBgdJ6@mail.gmail.com>
Date: Sun, 18 Jul 2010 11:17:32 -0700
Message-ID: <AANLkTildediWa_vkY76mLWoAjgdaEgIbWP0DsKu3Ujap@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
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

On Sun, Jul 18, 2010 at 10:36 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Lookie here, the %rsp comparison really isn't that hard:

A few notes on that (still) untested code suggestion:

>  nmi:
>      pushq %rax
>      pushq %rdx
>      movq %rsp,%rdx          # current stack top
>      movq 40(%rsp),%rax   # old stack top
>      xor %rax,%rdx              # same 8kB aligned area?
>      shrq $13,%rdx             # ignore low 13 bits
>      je it_is_a_nested_nmi   # looks nested..
>  non_nested:
>      ...
>      ... ok, we're not nested, do normal NMI handling ...
>      ...

The non_nested case still needs to start off with moving it's stack
frame to a safe area that won't be overwritten by any nesting NMI's
(note that they cannot nest at this point, since we've done nothing
that can fault). So we'd still need that

    7* pushq 48(%rsp)

which copies the five words that got pushed by hardware, and the two
register-save locations that we used for the nesting check and special
return.

After we've done those 7 pushes, we can then run code that may take a
fault. Because when the fault returns with an "iret" and re-enables
NMI's, our nesting code is ready.

So all told, we need a maximum of about 216 bytes of stack for the
nested NMI case: 56 bytes for the seven copied words, and the 160
bytes that we build up _under_ the stack pointer for the nested case.
And we need the NMI stack itself to be aligned in order for that
"ignore low bits" check to work. Although we don't actually have to do
that "xor+shr", we could do the test equally well with a "sub+unsigned
compare against stack size".

Other than that, I think the extra test that we're really nested might
better be done differently:

>  it_is_a_nested_nmi:
>      cmpw $0,48(%rsp)     # double-check that it really was a nested exception
>      jne non_nested           # from user space or something..
>      # this is the nested case

It migth be safer to check the saved CS rather than the saved SS on
the stack to see that we really are in kernel mode. It's possible that
somebody could load a NULL SS in user mode and then just not use the
stack - and try to make it look like they are in kernel mode for when
the NMI happens. Now, I _think_ that loading a zero SS is supposed to
trap, but checking CS is still likely to be the better test for "were
we in kernel mode". That's where the CPL is really encoded, after all.

So that "cmpw $0,48(%rsp)" is probably ok, but it would likely be
better to do it as

   testl $3,24(%rsp)
   jne non_nested

instead. That's what entry_64.S does everywhere else.

Oh, and the non-nested case obviously needs all the regular "make the
kernel state look right" code. Like the swapgs stuff etc if required.
My example code was really meant to just document the nesting
handling, not the existing stuff we already need to do with
save_paranoid etc.

And I really think it should work, but I'd again like to stress that
it's just a RFD code sequence with no testing what-so-ever etc.

                      Linus
