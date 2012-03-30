Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab2C3RyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:54:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55103 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756677Ab2C3RyL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:54:11 -0400
MIME-Version: 1.0
In-Reply-To: <4F75A2AA.4010604@hitachi.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
	<CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com>
	<1333065559.2960.8.camel@laptop>
	<CABPqkBQfy0CgSiDZ+KXd4fP9XxDxPTipyGbABZdEuTu4LkrsRQ@mail.gmail.com>
	<1333068279.2960.20.camel@laptop>
	<CABPqkBQbYs7JgGqfZD3ng6QMK0OpiVL=8gfyxn5aRgtYpPVjsw@mail.gmail.com>
	<4F75A2AA.4010604@hitachi.com>
Date: Fri, 30 Mar 2012 10:54:09 -0700
Message-ID: <CABPqkBRQthysw8V7oq9c9JJg7mtrMLWCxhi77iv6EryGXVGNqw@mail.gmail.com>
Subject: Re: [RFC 00/15] perf: Add backtrace post dwarf unwind
From: Stephane Eranian <eranian@google.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 5:10 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2012/03/30 9:52), Stephane Eranian wrote:
>> On Thu, Mar 29, 2012 at 5:44 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>> On Thu, 2012-03-29 at 17:38 -0700, Stephane Eranian wrote:
>>>> What I'd like to have is something similar to:
>>>>     attr->sample_type |= PERF_SAMPLE_REGS
>>>>     attr->sample_regs = EAX | EBX | EDI | ESI |.....
>>>>     attr->sample_reg_mode = { INTR, PRECISE, USER }
>>>>
>>>> Then in each sample for the event you dump the u64 values
>>>> of the requested registers.  The order is that of the enum
>>>> enum regs {}. That enum is arch specific.
>>>>
>>>> When you are in precise mode on Intel, you extract the regs
>>>> from PEBS. You already know the registers supported by PEBS
>>>> so you can reject any request for  unsupported regs.
>>>>
>>>> When you are in intr they you get the regs from pt_regs.
>>>> The user mode case is taken care of by the this patch series
>>>> already.
>>>>
>>>> I am not sure the sample_reg_mode needs to be a bitmask, i.e.,
>>>> do we need the reg state for INTR+PRECISE or USER+INTR?
>>>> But if so, then we would need attr->sample_regs[3] as not all
>>>> registers may be available in each mode.
>
> Would you have any good reason why we use INTR? Without PEBS,
> it may mislead users because the register value can be changed
> before interrupted. Personally, I would not like to use such
> values for debugging use :)

By INTR I meant PMU interrupt. That gives you the machine
state at the interrupted IP. That is interesting in the case of
stalls (sampling on cycles for instance). You may be able
to backtrack to the cause of the stalls. Take the following
simple example:

     0x1000: ld r1=[r32] <--- long latency miss
     ....
     0x100a: add r2=r1,1 <--- use point

Suppose you get a long latency miss of the load @ 0x1000,
you stall at the use point (not the load), here the add instruction
@ 0x100a. If you sample on cycles, you'll get an IP=0x100a.
No skid on stalls because you have nothing else to execute.

Let's assume r32 is not modified between 0x1000 and
0x100a, then you can figure out the miss address just
by looking at the machine state at 0x100a. You need
some static analysis of the code but this can be done.

In fact, I know that for sure because some tools did that
years ago:
http://www.supercomp.org/sc2003/paperpdfs/pap182.pdf
Section 2.2.3 for instance.

> So, I think this regs options may be good for the option of
> PEBS events.
>
Yes, that one is more obvious and requires no static analysis
of the code in most cases.

>>> I'm really having trouble seeing how useful this is. You mentioned
>>> sampling function arguments, but most samples would be in the middle of
>>> functions where the regs are completely unrelated to arguments. Also
>>> isn't the 'normal' C ABI passing args on stack rather than registers?
>>>
>> If you look at the SNB events, you'll see that br_inst_retired:near_call
>> supports PEBS. The sample is taken at retirement of the call, i.e., the
>> first instruction of the function, exactly where you want it to be.
>>
>> Unless I am mistaken, the x86_64 calling convention passes the first 6
>> integer arguments in registers.
>
> Right, almost all function arguments are passed by register on x86-64.

Including some of the FP registers but that's not captured by PEBS,
unfortunately.

> Hmm, this might be useful because it can trace function register-arguments
> in user-space applications... even though it causes interruption on every
> sampling calls...
>
It's not on every call to a function. This is statistical sampling not tracing.

Also I am not necessarily interested in using the machine state to unwind
the call stack. In the example above it's to support a local static
code analysis
