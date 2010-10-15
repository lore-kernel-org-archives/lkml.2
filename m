Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0JOIjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:39:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:16456 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0JOIjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o670Pl8AX6i08/qlY1BqJHpOLivlendJmCVxBL0KRJ6p9Ca1GQxs6iV2GHaFcoqMFU
         r1If8HYtEYkHThnG/mXg==
MIME-Version: 1.0
In-Reply-To: <20101014112000.GA5336@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	<1286946421-32202-3-git-send-regression-fweisbec@gmail.com>
	<1286954453.29097.58.camel@twins>
	<AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com>
	<20101014112000.GA5336@nowhere>
Date: Fri, 15 Oct 2010 10:39:43 +0200
Message-ID: <AANLkTimVPNntcSexdRnkvd+4VdGf2HU+rM7Zhyu=i7CS@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

On Thu, Oct 14, 2010 at 1:20 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Oct 14, 2010 at 01:06:30PM +0200, Stephane Eranian wrote:
>> Hi,
>>
>>
>>
>> On Wed, Oct 13, 2010 at 9:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
>> >> Add new PERF_SAMPLE_UREGS to perf sample type. This will dump the
>> >> user space context as it was before the user entered the kernel for
>> >> whatever reason.
>> >>
>> >> This is going to be useful to bring Dwarf CFI based stack unwinding
>> >> on top of samples.
>> >
>> > This doesn't address any of the issues that were raised previously.
>> >
>> > There's a reason we don't have PERF_SAMPLE_*REGS like things.
>> >
>> We definitively need to find a solution to this problem. It is important
>> to export this kind of information to users when using PEBS, for instance
>
>
>
> Would you need to export only a part of the regs for cases like PEBS?
>
Yes, PEBS does not capture the entire state.

Here is what you get on Intel Core:
        u64 flags, ip;
        u64 ax, bx, cx, dx;
        u64 si, di, bp, sp;
        u64 r8,  r9,  r10, r11;
        u64 r12, r13, r14, r15;

In 32-bit, the rXX are zero and would not need to be
exposed.

>
>
>>
>> What is exported depends on what is monitored and not just the ABI
>> of the kernel. On a 64-bit kernel, you may capture samples from
>> i386 or x86_64. Somehow the record needs to be self describing.
>>
>> What about something like:
>> struct  {
>>       int type; /* 32-bit, 64-bit */
>>       int nr;    /* number of regs */
>>       struct {
>>           int reg_name; /* taken from an enum with all possible regs */
>>           u64 reg_value;
>>       } [0]
>> };
>
>
>
> Yeah but in this case we can probably avoid to embed all the regnames
> in every dumps. This can be retrieved from what we asked in the attrs,
> which could be a u64 bitmap that tells which regs we want? (that only
> if we want a per reg granularity).
>
Yes, that's another possibility and it may be better because if you want
only one register,e.g,, EAX, then you can ask for it. That would limit the
memory consumption in the sampling buffer.

You need a bitmask to name the registers you want. If the register is not
accessible in the sampling mode you're requesting, then you should get
an error.

I would not necessarily use the attr.sample_type because we might run out
of bits on architecture with lots of registers. Another reason is that
the register
names are arch-specific, unlike what's in attr.sample_type.
