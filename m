Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2HANEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab2HANEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:04:40 -0400
Date: Wed, 1 Aug 2012 15:01:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roland McGrath <roland@hack.frob.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, a.p.zijlstra@chello.nl,
        mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Q: user_enable_single_step() && update_debugctlmsr()
Message-ID: <20120801130118.GA2386@redhat.com>
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de> <1343735548-18101-2-git-send-email-bigeasy@linutronix.de> <20120731175108.GC14576@redhat.com> <50183273.9070304@linutronix.de> <20120801122616.GA32705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801122616.GA32705@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Oleg Nesterov wrote:
>
> And btw, this is offtopic, but the usage of update_debugctlmsr()
> doesn't look right to me (I can be easily wrong though). I'll write
> another email.

user_enable_single_step() does

	if (enable_single_step(child) && block) {
		unsigned long debugctl = get_debugctlmsr();

		debugctl |= DEBUGCTLMSR_BTF;
		update_debugctlmsr(debugctl);
		set_tsk_thread_flag(child, TIF_BLOCKSTEP);
	}

and I do not understand update_debugctlmsr() above (and other
callsites).

Lets ignore uprobes which needs the changes anyway. This is
only used by ptrace and the task is stopped. So, unless I missed
something obvious, this update_debugctlmsr() is simply unneeded,
__switch_to/__switch_to_xtra should notice _TIF_BLOCKSTEP and do
update_debugctlmsr(DEBUGCTLMSR_BTF).

But, worse, isn't it wrong? Suppose that debugger switches to
another TIF_SINGLESTEP && !TIF_BLOCKSTEP task, in this case
we "leak" DEBUGCTLMSR_BTF, no?

IOW, it seems to me we could safely remove update_debugctlmsr()
arch/x86/kernel/step.c. However, if we want to re-use this code
in uprobes, then we probably need to add "if (child == current)".

Or I am totally confused. Help!

Oleg.

