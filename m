Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab2AYOjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:39:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37384 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab2AYOjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:39:45 -0500
MIME-Version: 1.0
In-Reply-To: <20120110114831.17610.88468.sendpatchset@srdronam.in.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com> <20120110114831.17610.88468.sendpatchset@srdronam.in.ibm.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 25 Jan 2012 15:39:19 +0100
Message-ID: <CAK1hOcMVQN4sQjMnV3YBtd6hi8ZtbxPuguVHGxGgSPGn2scsNQ@mail.gmail.com>
Subject: Re: [PATCH v9 3.2 1/9] uprobes: Install and remove breakpoints.
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 12:48 PM, Srikar Dronamraju
<srikar@linux.vnet.ibm.com> wrote:
> +/*
> + * opcodes we'll probably never support:
> + * 6c-6d, e4-e5, ec-ed - in
> + * 6e-6f, e6-e7, ee-ef - out
> + * cc, cd - int3, int

I imagine desire to set a breakpoint on int 0x80 will be rather typical.
(Same for sysenter).

> + * cf - iret

Iret does work. Test program for 32-bit x86:

/* gcc -nostartfiles -nostdlib -o iret iret.S */
_start: .globl  _start
        pushf
        push    %cs
        push    $_e
        iret  /* will this jump to _e? Yes! */
        hlt   /* segv if reached */
_e:     movl    $42, %ebx
        movl    $1, %eax
        int     $0x80

I guess supporting probes in weird stuff like ancient DOS emulators
(they actually use iret) is not important.

OTOH iret doesn't seem to be too hard: if it fails (bad cs/eflags
on stack), then the location of iret instruction per se is not
terribly important.
If it works, then you need to be careful to not mess up eip,
same as you already do with ordinary [l]ret, nothing more.


Come to think of it, why do you bother checking for
invalid instructions? What can happen if you would just copy
and run all instructions? You already are prepared to handle
exceptions, right?


-- 
vda
