Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2CASap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:30:45 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:16999
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028Ab2CASam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:30:42 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F4FC037.4060201@am.sony.com>
Date: Thu, 1 Mar 2012 10:30:15 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        linux kernel <linux-kernel@vger.kernel.org>, <tj@kernel.org>
Subject: Re: Questions about ptrace on a dying process
References: <4F4E6915.1010209@am.sony.com> <m2mx81pi7x.fsf@firstfloor.org> <4F4E8E6A.2020601@am.sony.com> <201203010812.54769.vda.linux@googlemail.com>
In-Reply-To: <201203010812.54769.vda.linux@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 11:12 PM, Denys Vlasenko wrote:
> On Wednesday 29 February 2012 21:45, Tim Bird wrote:
>> On 02/29/2012 11:12 AM, Andi Kleen wrote:
>>> Tim Bird <tim.bird@am.sony.com> writes:
>>>
>>>> ptrace maintainers (and interested parties)...
>>>>
>>>> I'm working on a crash handler for Linux, which uses ptrace to retrieve information
>>>> about a process during it's coredump.  Specifically, from within a core handler
>>>> program (started within do_coredump() as a user_mode_helper), I would like to make
>>>> ptrace calls against the dying process.
>>>
>>> The standard approach is to define a core pipe handler and parse the
>>> elf memory dump.
>>
>> Yeah - I may be doing something new here.  Android uses ptrace
>> in debuggerd, which is their crash reporting tool, but they wake
>> it up with signals before the dying program goes into coredump.
> 
> I think ptrace API does not provide guarantees that it is possible
> to attach to the process when it coredumps.
> 
> It might work in current kernels, but might break in new ones.

If it's not too much trouble, it would be nice to continue
this behaviour.   Admittedly, my style of crash handling appears
to be new, and I don't want to unnecessarily burden the code,
but so far it works really well, and currently requires very
minimal change to the existing ptrace code.  One thing that's
nice about what I'm doing, is that I don't rely on the
whole signal state machine of the process to interact with it
(since a dying process can't respond correctly).

So hopefully, continuing to support ptrace for a dying process
won't interfere or burden the existing (rather complex)
state processing in the current code.

Just for reference, below is the patch I settled on for my own kernel.
I'm planning taking a look at the PTRACE_SEIZE code to see if it
accomplishes what I need, but haven't done that yet.

I do have a question, though - how will a tracer know that it can
use PTRACE_SEIZE?  Is there some introspection API?  My code will
be running mainly against a patched 3.0 for some time (a few years),
but if I could make it interoperate with a kernel that supports
PTRACE_SEIZE (when it is mainlined), that would be great.

 -- Tim

commit dd54b901759428e60ed57b2d6cb77d25a8db767f
Author: tbird <tim.bird@am.sony.com>
Date:   Tue Feb 28 14:13:08 2012 -0800

    Support ptrace_attach with no signal side-effects.

    In the normal case, a ptrace_attach operation will convert
    a process to TASK_TRACED by sending it a SIGSTOP signal,
    after setting task->ptrace.  This won't work on a dying
    process because during do_coredump(), the dying process won't
    process the STOP signal and change state.

    Modify ptrace_attach() so that the tracee task state is modified
    directly.  This allows subsequent ptrace_check_attach() calls
    to work correctly, and avoids having a pending SIGSTOP signal
    on the tree process (which interferes with waiting for
    the core pipe handler).

    Note that a more full-featured implementation of this is in the
    works (as of March, 2012) by Tejun Heo, called PTRACE_SEIZE.
    Once that gets mainlined, this patch may not be needed, or might
    need to be reworked.

    Signed-off-by: Tim Bird <tim.bird@am.sony.com>

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 26147d1..9c7bf8e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -223,7 +223,16 @@ static int ptrace_attach(struct task_struct *task)
 		task->ptrace |= PT_PTRACE_CAP;

 	__ptrace_link(task, current);
-	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
+	
+	/*
+ 	 * If doing coredump, just convert directly to TASK_TRACED.
+ 	 * A dying process doesn't process signals normally.
+ 	 */
+	if (unlikely(task->mm->core_state)) {
+		set_task_state(task, TASK_TRACED);
+	} else {
+		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
+	}

 	spin_lock(&task->sighand->siglock);


=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

