Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1GABwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:52:32 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54681 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1GABwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:52:31 -0400
X-AuditID: b753bd60-a32aeba0000019f4-c8-4e0d285c191c
X-AuditID: b753bd60-a32aeba0000019f4-c8-4e0d285c191c
Message-ID: <4E0D285A.7040000@hitachi.com>
Date: Fri, 01 Jul 2011 10:52:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        MartinSchwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for kprobes
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>	 <1309449117.26417.90.camel@gandalf.stny.rr.com>	 <1309470997.12449.614.camel@twins>  <4E0D2141.4080608@hitachi.com> <1309484297.26417.126.camel@gandalf.stny.rr.com>
In-Reply-To: <1309484297.26417.126.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/01 10:38), Steven Rostedt wrote:
> [ Added some of the affected maintainers, left off David Howells and
> David Miller due to LKML Cc limit ]
> 
> On Fri, 2011-07-01 at 10:22 +0900, Masami Hiramatsu wrote:
>> (2011/07/01 6:56), Peter Zijlstra wrote:
>>> On Thu, 2011-06-30 at 11:51 -0400, Steven Rostedt wrote:
>>>>
>>>> To solve this, I've added a per_cpu variable called
>>>> kprobe_preempt_disabled, that is set by the kprobe code. If it is set,
>>>> the preempt_schedule() will not preempt the code.
>>
>> Sorry for replying so late :(
> 
> Heh, who can blame you? Timezones make open source development a
> wait-and-see affair.

Yeah, we can't go over light speed.

>>> Damn this is ugly. Can we step back and see if we can make the
>>> requirement for kprobe to disable preemption go away?
>>
>> As I replied right now, I think we can just eliminate that
>> disabling preemption code. At least we'd better try it.
>> I agree with you, introducing this kind of complexity
>> just for kprobes is not what I want. :(
> 
> Note, I did clean up this patch, so it is not as fugly.

Hm, I think you don't need to introduce new flag for that
purpose, there is current_kprobe and kprobe status flag.

if (kprobe_running() &&
    get_kprobe_ctlblk()->kprobe_status == KPROBE_HIT_SS)
	/*Running under kprobe's single stepping*/

But I'm not sure that is there any code which can run
under TF=1. (maybe NMI code? but it would not cause preemption)

>>> Why does it have to do that anyway? Isn't it keeping enough per-task
>>> state to allow preemption over the single step?
>>
>> preemption itself must not happen on single stepping, but it seems
>> impossible to do heavy context switching with setting TF bit...
> 
> Yeah, if all archs single step with interrupts disabled, then we should
> be fine with removing preemption.

OK, I'll check that.

Thank you ;)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
