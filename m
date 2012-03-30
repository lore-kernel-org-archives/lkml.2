Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab2C3AiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:38:12 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48530 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758576Ab2C3AiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:38:02 -0400
MIME-Version: 1.0
In-Reply-To: <1333065559.2960.8.camel@laptop>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
	<CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com>
	<1333065559.2960.8.camel@laptop>
Date: Thu, 29 Mar 2012 17:38:00 -0700
Message-ID: <CABPqkBQfy0CgSiDZ+KXd4fP9XxDxPTipyGbABZdEuTu4LkrsRQ@mail.gmail.com>
Subject: Re: [RFC 00/15] perf: Add backtrace post dwarf unwind
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        rostedt@goodmis.org, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 4:59 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-03-29 at 10:04 -0700, Stephane Eranian wrote:
>> I think the mechanism should allow the user to select which registers
>> (you have that) but also where they are captured. You have
>> the user level state, but you also want the interrupted state or the
>> precise state, i.e., extracting the register at retirement of an
>> instruction
>> that caused the sampling PMU event (PEBS on Intel). Personally, I
>> am interested in the last two. I had a prototype patch for those.
>> It is based on the same approach in terms of register naming. You
>> need to be able to name individual registers. That's obviously arch
>> specific and you have that. Now there needs to be a way to indicate
>> where the registers must to be captured. Note that you may want
>> to combine user + interrupt states. So I think we may need multiple
>> register bitmasks.
>
> This all comes very close to something I suggested to Masami once where
> you could specify data to grab on [ku]probe hits.
>
> That is, when creating a [ku]probe based tracepoint you can specify
> several variable/argument names and the userspace perf-probe bits will
> use the dwarf info to figure out how to obtain the value of said var/arg
> at the probe point (if possible, if not bail).
>
> The kernel would simply get something along the lines of %rax->foo->bar,
> or (%esp+x)->blah along with a size of the data structure to be found
> there and copy whatever it finds out to the raw field.
>
> So what you're saying is you basically want this for any possible
> sample, not just [ku]probes.
>
>
What I'd like to have is something similar to:
    attr->sample_type |= PERF_SAMPLE_REGS
    attr->sample_regs = EAX | EBX | EDI | ESI |.....
    attr->sample_reg_mode = { INTR, PRECISE, USER }

Then in each sample for the event you dump the u64 values
of the requested registers.  The order is that of the enum
enum regs {}. That enum is arch specific.

When you are in precise mode on Intel, you extract the regs
from PEBS. You already know the registers supported by PEBS
so you can reject any request for  unsupported regs.

When you are in intr they you get the regs from pt_regs.
The user mode case is taken care of by the this patch series
already.

I am not sure the sample_reg_mode needs to be a bitmask, i.e.,
do we need the reg state for INTR+PRECISE or USER+INTR?
But if so, then we would need attr->sample_regs[3] as not all
registers may be available in each mode.
