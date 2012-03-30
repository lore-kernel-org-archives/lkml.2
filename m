Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab2C3Aw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:52:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40130 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903Ab2C3Aww convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <1333068279.2960.20.camel@laptop>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
	<CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com>
	<1333065559.2960.8.camel@laptop>
	<CABPqkBQfy0CgSiDZ+KXd4fP9XxDxPTipyGbABZdEuTu4LkrsRQ@mail.gmail.com>
	<1333068279.2960.20.camel@laptop>
Date: Thu, 29 Mar 2012 17:52:50 -0700
Message-ID: <CABPqkBQbYs7JgGqfZD3ng6QMK0OpiVL=8gfyxn5aRgtYpPVjsw@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 5:44 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-03-29 at 17:38 -0700, Stephane Eranian wrote:
>> What I'd like to have is something similar to:
>>     attr->sample_type |= PERF_SAMPLE_REGS
>>     attr->sample_regs = EAX | EBX | EDI | ESI |.....
>>     attr->sample_reg_mode = { INTR, PRECISE, USER }
>>
>> Then in each sample for the event you dump the u64 values
>> of the requested registers.  The order is that of the enum
>> enum regs {}. That enum is arch specific.
>>
>> When you are in precise mode on Intel, you extract the regs
>> from PEBS. You already know the registers supported by PEBS
>> so you can reject any request for  unsupported regs.
>>
>> When you are in intr they you get the regs from pt_regs.
>> The user mode case is taken care of by the this patch series
>> already.
>>
>> I am not sure the sample_reg_mode needs to be a bitmask, i.e.,
>> do we need the reg state for INTR+PRECISE or USER+INTR?
>> But if so, then we would need attr->sample_regs[3] as not all
>> registers may be available in each mode.
>
> I'm really having trouble seeing how useful this is. You mentioned
> sampling function arguments, but most samples would be in the middle of
> functions where the regs are completely unrelated to arguments. Also
> isn't the 'normal' C ABI passing args on stack rather than registers?
>
If you look at the SNB events, you'll see that br_inst_retired:near_call
supports PEBS. The sample is taken at retirement of the call, i.e., the
first instruction of the function, exactly where you want it to be.

Unless I am mistaken, the x86_64 calling convention passes the first 6
integer arguments in registers.
