Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab2BWO3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:29:15 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50782 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab2BWO3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:29:11 -0500
X-Greylist: delayed 46044 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 09:29:11 EST
X-AuditID: b753bd60-9f483ba000000655-7b-4f464d347024
X-AuditID: b753bd60-9f483ba000000655-7b-4f464d347024
Message-ID: <4F464D2F.9000302@hitachi.com>
Date: Thu, 23 Feb 2012 23:29:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86/kprobes: Fix to recover instructions on optimized
 path
References: <20120221083621.11350.4716.stgit@localhost.localdomain> <tip-f5dbbb8e1e055d6f02817a1995993b461910b1b7@git.kernel.org> <20120222162224.GA5256@elte.hu> <4F459941.1000006@hitachi.com> <20120223070747.GA14495@elte.hu> <20120223083703.GA26781@elte.hu>
In-Reply-To: <20120223083703.GA26781@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/23 17:37), Ingo Molnar wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>>> Does not build on x86 if CONFIG_OPTPROBES is off:
>>>>
>>>> arch/x86/kernel/kprobes.c:260:8: error: dereferencing pointer to incomplete
type
>>>> arch/x86/kernel/kprobes.c:260:8: error: invalid use of undefined type
‘struct optimized_kprobe’
>>>> arch/x86/kernel/kprobes.c:262:22: error: dereferencing pointer to
incomplete type
>>>> arch/x86/kernel/kprobes.c:264:18: error: dereferencing pointer to
incomplete type
>>>
>>> Oops, should I update this patch or send new diff?
>>
>> Please send a delta fix.
>
> Hm, it was triggering too often so I removed it from perf:core
> for now - please send an updated patch.

I see.

> Please also pick up the slightly updated changelog I've created
> for the commit - you can see it in the -tip notification email.

OK, I'll do that.

> Btw., why are optprobes limited to !PREEMPT, could we make them
> preempt safe?

Hmm, it may be (become) possible. I need to look into preempt code
carefully, since there are many updates after optprobe was merged.

Originally, there are two issues on enabling optprobe with
preemptive kernel.

One problem can happen when inserting a jump. If we put a kprobe
on preemptive place, some threads might be interrupted and
preempted near there.
After we replaces instructions with a jump, the thread is scheduled
and can go back on the instruction which has already been replaced!

For prohibiting that kind of accident, currently optprobe builds a
bypass route with a breakpoint and copied code, and waits for
interrupted tasks by using synchronize_sched().

Another problem is similar to above. When releasing the bypass code
buffer, we need to wait until that all tasks, who run on there,
get out from the buffer (and again, they can be interrupted.)
So, optprobe uses synchronize_sched() again.

I'm not sure that any progress has been done on preemptive kernel.
At least when I made optprobe, I can ensure that any interrupts
has done, but can not wait for the kernel-preempted tasks.

I think optprobe with preemption requires such API which can wait
for that all tasks, who are kernel-preempted at that time, are
scheduled again and return to user-space or yield by themselves.

Please tell me if you know such one :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
