Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab0JPACt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:02:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42323 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0JPACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Q0gjgl+IcLtHzwpHZUVYy0OqbeAGQkLuyQyOFzTMzpsRdsC77n58aonUjSwipBa+S7
         3nB0JPG2cESGKC5JWX2MZBuWF0pWW8qhDrJnr9Oqn2QVQhIb72aMIm/ffwZU8lcJbWw7
         2Prd7U3fTAbIgEYW++Rao2on9ZFLwFBd69FJk=
Date: Sat, 16 Oct 2010 00:58:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
Message-ID: <20101015225722.GA5354@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <1286946421-32202-3-git-send-regression-fweisbec@gmail.com> <1286954453.29097.58.camel@twins> <AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com> <20101014112000.GA5336@nowhere> <AANLkTimVPNntcSexdRnkvd+4VdGf2HU+rM7Zhyu=i7CS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimVPNntcSexdRnkvd+4VdGf2HU+rM7Zhyu=i7CS@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:39:43AM +0200, Stephane Eranian wrote:
> Frederic,
> 
> On Thu, Oct 14, 2010 at 1:20 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Thu, Oct 14, 2010 at 01:06:30PM +0200, Stephane Eranian wrote:
> >> Hi,
> >>
> >>
> >>
> >> On Wed, Oct 13, 2010 at 9:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> >> >> Add new PERF_SAMPLE_UREGS to perf sample type. This will dump the
> >> >> user space context as it was before the user entered the kernel for
> >> >> whatever reason.
> >> >>
> >> >> This is going to be useful to bring Dwarf CFI based stack unwinding
> >> >> on top of samples.
> >> >
> >> > This doesn't address any of the issues that were raised previously.
> >> >
> >> > There's a reason we don't have PERF_SAMPLE_*REGS like things.
> >> >
> >> We definitively need to find a solution to this problem. It is important
> >> to export this kind of information to users when using PEBS, for instance
> >
> >
> >
> > Would you need to export only a part of the regs for cases like PEBS?
> >
> Yes, PEBS does not capture the entire state.
> 
> Here is what you get on Intel Core:
>         u64 flags, ip;
>         u64 ax, bx, cx, dx;
>         u64 si, di, bp, sp;
>         u64 r8,  r9,  r10, r11;
>         u64 r12, r13, r14, r15;



Ok, that seems to cover most of the state. I guess few people care
about cs, ds, es, fs, gs, most of the time.



> 
> In 32-bit, the rXX are zero and would not need to be
> exposed.
> 
> >
> >
> >>
> >> What is exported depends on what is monitored and not just the ABI
> >> of the kernel. On a 64-bit kernel, you may capture samples from
> >> i386 or x86_64. Somehow the record needs to be self describing.
> >>
> >> What about something like:
> >> struct  {
> >>       int type; /* 32-bit, 64-bit */
> >>       int nr;    /* number of regs */
> >>       struct {
> >>           int reg_name; /* taken from an enum with all possible regs */
> >>           u64 reg_value;
> >>       } [0]
> >> };
> >
> >
> >
> > Yeah but in this case we can probably avoid to embed all the regnames
> > in every dumps. This can be retrieved from what we asked in the attrs,
> > which could be a u64 bitmap that tells which regs we want? (that only
> > if we want a per reg granularity).
> >
> Yes, that's another possibility and it may be better because if you want
> only one register,e.g,, EAX, then you can ask for it. That would limit the
> memory consumption in the sampling buffer.


But then I wonder who needs EAX only? If you need eax, then you almost
certainly need most the other general registers.

May be we can group them by "family"? Like one group for general registers
(r0 - r15), one for segment registers (cs - gs) and one for eflags.
We can perhaps isolate single groups for stack pointer, frame pointer and
instruction pointer.

But I can't imagine every possible uses of the regs dump, may be we should
just have one flag per register to enforce a maximum flexibility
and don't bother further.

Hm?


> You need a bitmask to name the registers you want. If the register is not
> accessible in the sampling mode you're requesting, then you should get
> an error.


Yep.


 
> I would not necessarily use the attr.sample_type because we might run out
> of bits on architecture with lots of registers. Another reason is that
> the register
> names are arch-specific, unlike what's in attr.sample_type.


Yeah we really need a new field for that, u64 so that we have enough bits
for every possible regs set (at least I hope...).

