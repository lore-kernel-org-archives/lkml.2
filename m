Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0GRRh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 13:37:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756756Ab0GRRhX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 13:37:23 -0400
MIME-Version: 1.0
In-Reply-To: <4C42DF9A.5090908@redhat.com>
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
Date: Sun, 18 Jul 2010 10:36:42 -0700
Message-ID: <AANLkTin1noI6IUfuQsbAgVVzj2rSOhm-Cx3WpsMBgdJ6@mail.gmail.com>
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

On Sun, Jul 18, 2010 at 4:03 AM, Avi Kivity <avi@redhat.com> wrote:
>
> By trading off some memory, we don't need this trickery.  We can allocate
> two nmi stacks, so the code becomes:

I really don't think you need even that. See earlier in the discussion
about how we could just test %rsp itself. Which makes all the %rip
testing totally unnecessary, because we don't even need any flags,and
we have no races because %rsp is atomically changed with taking the
exception.

Lookie here, the %rsp comparison really isn't that hard:

  nmi:
      pushq %rax
      pushq %rdx
      movq %rsp,%rdx          # current stack top
      movq 40(%rsp),%rax   # old stack top
      xor %rax,%rdx              # same 8kB aligned area?
      shrq $13,%rdx             # ignore low 13 bits
      je it_is_a_nested_nmi   # looks nested..
  non_nested:
      ...
      ... ok, we're not nested, do normal NMI handling ...
      ...
      popq %rdx
      popq %rax
      iret

  it_is_a_nested_nmi:
      cmpw $0,48(%rsp)     # double-check that it really was a nested exception
      jne non_nested           # from user space or something..
      # this is the nested case
      # NOTE! NMI's are blocked, we don't take any exceptions etc etc
      addq $-160,%rax        # 128-byte redzone on the old stack + 4 words
      movq (%rsp),%rdx
      movq %rdx,(%rax)       # old %rdx
      movq 8(%rsp),%rdx
      movq %rdx,8(%rax)     # old %rax
      movq 32(%rsp),%rdx
      movq %rdx,16(%rax)   # old %rflags
      movq 16(%rsp),%rdx
      movq %rdx,24(%rax)   # old %rip
      movq %rax,%rsp
      popq %rdx
      popq %rax
      popf
      ret $128                     # restore %rip and %rsp

doesn't that look pretty simple?

NOTE! OBVIOUSLY TOTALLY UNTESTED!

                            Linus
