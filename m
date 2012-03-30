Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab2C3MKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:10:31 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:32889 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2C3MKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:10:23 -0400
X-AuditID: b753bd60-a1286ba000000655-0f-4f75a2ac6323
X-AuditID: b753bd60-a1286ba000000655-0f-4f75a2ac6323
Message-ID: <4F75A2AA.4010604@hitachi.com>
Date: Fri, 30 Mar 2012 21:10:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC 00/15] perf: Add backtrace post dwarf unwind
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com> <CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com> <1333065559.2960.8.camel@laptop> <CABPqkBQfy0CgSiDZ+KXd4fP9XxDxPTipyGbABZdEuTu4LkrsRQ@mail.gmail.com> <1333068279.2960.20.camel@laptop> <CABPqkBQbYs7JgGqfZD3ng6QMK0OpiVL=8gfyxn5aRgtYpPVjsw@mail.gmail.com>
In-Reply-To: <CABPqkBQbYs7JgGqfZD3ng6QMK0OpiVL=8gfyxn5aRgtYpPVjsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/30 9:52), Stephane Eranian wrote:
> On Thu, Mar 29, 2012 at 5:44 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Thu, 2012-03-29 at 17:38 -0700, Stephane Eranian wrote:
>>> What I'd like to have is something similar to:
>>>     attr->sample_type |= PERF_SAMPLE_REGS
>>>     attr->sample_regs = EAX | EBX | EDI | ESI |.....
>>>     attr->sample_reg_mode = { INTR, PRECISE, USER }
>>>
>>> Then in each sample for the event you dump the u64 values
>>> of the requested registers.  The order is that of the enum
>>> enum regs {}. That enum is arch specific.
>>>
>>> When you are in precise mode on Intel, you extract the regs
>>> from PEBS. You already know the registers supported by PEBS
>>> so you can reject any request for  unsupported regs.
>>>
>>> When you are in intr they you get the regs from pt_regs.
>>> The user mode case is taken care of by the this patch series
>>> already.
>>>
>>> I am not sure the sample_reg_mode needs to be a bitmask, i.e.,
>>> do we need the reg state for INTR+PRECISE or USER+INTR?
>>> But if so, then we would need attr->sample_regs[3] as not all
>>> registers may be available in each mode.

Would you have any good reason why we use INTR? Without PEBS,
it may mislead users because the register value can be changed
before interrupted. Personally, I would not like to use such
values for debugging use :)
So, I think this regs options may be good for the option of
PEBS events.

>> I'm really having trouble seeing how useful this is. You mentioned
>> sampling function arguments, but most samples would be in the middle of
>> functions where the regs are completely unrelated to arguments. Also
>> isn't the 'normal' C ABI passing args on stack rather than registers?
>>
> If you look at the SNB events, you'll see that br_inst_retired:near_call
> supports PEBS. The sample is taken at retirement of the call, i.e., the
> first instruction of the function, exactly where you want it to be.
> 
> Unless I am mistaken, the x86_64 calling convention passes the first 6
> integer arguments in registers.

Right, almost all function arguments are passed by register on x86-64.
Hmm, this might be useful because it can trace function register-arguments
in user-space applications... even though it causes interruption on every
sampling calls...


Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
