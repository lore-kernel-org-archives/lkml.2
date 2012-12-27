Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab2L0JAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:00:34 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:49628 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2L0JAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:00:31 -0500
Message-ID: <50DC0E21.90503@synopsys.com>
Date: Thu, 27 Dec 2012 14:30:17 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 11/31] ARC: Low level IRQ/Trap/Exception(non-MMU)
 Handling
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-12-git-send-email-vgupta@synopsys.com> <20121116045828.GB22671@ZenIV.linux.org.uk>
In-Reply-To: <20121116045828.GB22671@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2012 10:28 AM, Al Viro wrote:
>> +	; --------- check for signals/restore-sigmask ------------
>> +	bbit0  r9, TIF_SIGPENDING, chk_next_work
>> +
>> +	; save CALLEE Regs.
>> +	; (i)  If this signal causes coredump - full regfile needed
>> +	; (ii) If signal is SIGTRAP/SIGSTOP, task is being traced thus
>> +	;      tracer might call PEEKUSR for a CALLEE reg
>> +	;
>> +	; NOTE: SP will grow up by size of CALLEE Reg-File
>> +	SAVE_CALLEE_SAVED_USER		; clobbers r12
>> +
>> +	; save location of saved Callee Regs @ thread_struct->callee
>> +	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r10
>> +	st  sp, [r10, THREAD_CALLEE_REG]
>> +
>> +	bl  @do_signal
>> +
>> +	; unwind SP for cheap discard of Callee saved Regs
>> +	DISCARD_CALLEE_SAVED_USER
> Uh-oh...  And what if tracer wanted to modify callee-saved regs?

So the solution would be to either unconditionally restore all the 13 callee regs
- or add additional state (struct thread) where ptrace makes a note that it wrote
to a callee reg which is used here to conditional-ize the restore. Former is
simpler to do - although it might ill-affect micro-benchmarks such as LMBench
lat_sig. Anyhow correctness comes before optimization.

>
>> +	b      resume_user_mode_begin	; loop back to start of U mode ret
>> +
>> +	; --- notify_resume ---
>> +chk_next_work:
>> +	btst   r9, TIF_NOTIFY_RESUME
>> +	blnz   @do_notify_resume
>> +
>> +	;--------- All things done, go back to Userland ------
>> +
>> +	b restore_regs
> No.  After NOTIFY_RESUME stuff you need to recheck SIGPENDING.  This should
> go to resume_user_mode_begin, not restore regs.  

Thanks for pointing this - fixed in v2 series.

> Another problem here is
> IRQ handling - you hit do_signal()/do_notify_resume() with IRQs disabled,
> which is broken - you need to re-enable it before going into either.

Thanks - fixed that as well. I presume it is broken for "interrupt latency
reasons" and not because IRQs could remain disabled all the way into usermode -
since given the way RTIE insn works - that won't happen. Although independently
this was indeed cause of a WARN_ON_ONCE when bh were enabled with IRQs disabled.

