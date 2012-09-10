Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2IJQ5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:57:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:51149 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2IJQ5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:57:34 -0400
Date: Mon, 10 Sep 2012 18:57:17 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ptrace: Partly fix
 set_task_blockstep()->update_debugctlmsr() logic
Message-ID: <20120910165717.GA17118@linutronix.de>
References: <20120903152525.GA9028@redhat.com>
 <20120903152609.GA9071@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120903152609.GA9071@redhat.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov | 2012-09-03 17:26:09 [+0200]:

>Afaics the usage of update_debugctlmsr() and TIF_BLOCKSTEP in
>step.c was always very wrong.
>
>1. update_debugctlmsr() was simply unneeded. The child sleeps
>   TASK_TRACED, __switch_to_xtra(next_p => child) should notice
>   TIF_BLOCKSTEP and set/clear DEBUGCTLMSR_BTF after resume if
>   needed.
>
>2. It is wrong. The state of DEBUGCTLMSR_BTF bit in CPU register
>   should always match the state of current's TIF_BLOCKSTEP bit.
>
>3. Even get_debugctlmsr() + update_debugctlmsr() itself does not
>   look right. Irq can change other bits in MSR_IA32_DEBUGCTLMSR
>   register or the caller can be preempted in between.

ptrace and uprobe are calling this function from process context. As
long as you have here get_cpu() instead of local_irq_disable() you should
be safe here.
The only user that is touching this bits in irq context is perf. perf
uses raw_local_irqsave() (raw_* most likely due to -RT). I have no idea
what you can against NMI unless not touching the register in NMI
context.

Sebastian
