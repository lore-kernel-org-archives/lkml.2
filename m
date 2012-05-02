Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2EBM7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:59:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab2EBM7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:59:02 -0400
Date: Wed, 2 May 2012 14:58:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 02/16] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120502125830.GF1548@m.brq.redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
 <1334661441-4420-3-git-send-email-jolsa@redhat.com>
 <CABPqkBRqG5WhWYY5viVW3j89WUrpmkk1j7VA=oUhY_TGXg=14g@mail.gmail.com>
 <20120423103350.GB1720@m.brq.redhat.com>
 <20120426152840.GC1659@m.brq.redhat.com>
 <CABPqkBSC02vBxAPLrS6j4bVFGme3ibKH=VOkT0yHVCP=pJMnYA@mail.gmail.com>
 <20120502122618.GE1548@m.brq.redhat.com>
 <CABPqkBTFfHtqd0Zk7go4w6aC26vdjHirOyWRqXFct_5Q-ndx5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTFfHtqd0Zk7go4w6aC26vdjHirOyWRqXFct_5Q-ndx5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


SNIP

> >
> > I just sent v3, with changed design to be more generic, please check
> >
> > anyway, currently there's no way to mix 32 and 64 bit registers in sample.
> >
> > As I mentioned above, once running compat task, 64 bit registers
> > are stored anyway. Given that all 32 bit registers have 64 equiv.
> > you can ask to store RAX|RBX|R15.
> >
> Well, R8-R15 do not exist in 32-bit mode. So I wonder what is saved
> on the stack for those, probably nothing. And in that case, how do you
> handle the case where the user asked for R15 but it is not available and
> you know that only on PMU interrupt.

right, R8-R15 do not exist in 32 bit mode, meaning that the 32 bit task
do not use them... but when you enter 64 bit kernel from 32 bit compat
task, still 64bits registers are saved.. as for native 64 process,
there's no difference.. so even for 32 bit task you get 64 bits
registers described below.


The availbility of registers is tricky for user space register dump.

We dump whatever we got in pt_regs structure from perf_sample_regs_user.
The problem is, that exception do not store all of the registers.. the rest
of the registers is whatever is in stack occupying the pt_regs space.

When kernel is entered (by exception or irq), following is saved by CPU
(both 32 and 64 bits):
 ss, sp, flags, cs ip

followed by SAVE_ARGS  (for exception):
        movq_cfi rdi, 8*8
        movq_cfi rsi, 7*8
        movq_cfi rdx, 6*8

        .if \save_rcx
        movq_cfi rcx, 5*8
        .endif

        movq_cfi rax, 4*8

        .if \save_r891011
        movq_cfi r8,  3*8
        movq_cfi r9,  2*8
        movq_cfi r10, 1*8
        movq_cfi r11, 0*8

SAVE_REST - saves the whole pt_regs structure just for the
sake of the syscall_trace_enter function, once finished it's
poped out..

As for unwind we should get the most important ones. Of course
the unwind could be based on any register, and with bogus value
the unwind just stops.

I think we are in better shape for irqs but I'd need to check.

jirka
