Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2HAOvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:51:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:51505 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2HAOvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:51:45 -0400
Message-ID: <5019427B.1070002@linutronix.de>
Date: Wed, 01 Aug 2012 16:51:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
References: <1343735548-18101-2-git-send-email-bigeasy@linutronix.de> <20120731175108.GC14576@redhat.com> <50183273.9070304@linutronix.de> <20120801122616.GA32705@redhat.com> <20120801130118.GA2386@redhat.com> <50192FF5.1060208@linutronix.de> <20120801134652.GA4707@redhat.com> <50193528.3070503@linutronix.de> <20120801140121.GA5333@redhat.com> <50193B5C.90404@linutronix.de> <20120801143132.GA7550@redhat.com>
In-Reply-To: <20120801143132.GA7550@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 04:31 PM, Oleg Nesterov wrote:
> And I think you missed my point. I'll try again.
Okay.

> We have the GDB process and the (stopped) tracee T. And we have
> another task X which have TIF_SINGLESTEP but not TIF_BLOCKSTEP.
> To simplify, suppose that X is already TASK_RUNNING but not on rq.
>
> GDB does ptrace(PTRACE_SINGLEBLOCK, T). This sets X->TIF_BLOCKSTEP.
> Now suppose that GDB is preempted right after it does
> update_debugctlmsr(), and the scheduler choses X as the next task.
>
> Both GDB and X do not have TIF_BLOCKSTEP, so __switch_to_extra()
> does not update DEBUGCTLMSR_BTF.
>
> X returns to the user-mode with TIF_SINGLESTEP and TIF_BLOCKSTEP,
> the latter is wrong.
>
> No?

Yup, correct, you are right sir. Thank you for trying so hard to make
me see this :)

So a patch like
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -173,8 +173,8 @@ static void enable_step(struct task_struct *child, 
bool block)
                 unsigned long debugctl = get_debugctlmsr();

                 debugctl |= DEBUGCTLMSR_BTF;
-               update_debugctlmsr(debugctl);
                 set_tsk_thread_flag(child, TIF_BLOCKSTEP);
+               update_debugctlmsr(debugctl);
         } else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
                 unsigned long debugctl = get_debugctlmsr();

should fix the race and _yes_ I also would follow your suggestion to
remove this update_debugctlmsr() here since switch_to() should do this.

>
> Oleg.
>

Sebastian
