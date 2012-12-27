Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2L0NaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 08:30:03 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:46794 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2L0N37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 08:29:59 -0500
Message-ID: <50DC4D4B.6030408@synopsys.com>
Date: Thu, 27 Dec 2012 18:59:47 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 11/31] ARC: Low level IRQ/Trap/Exception(non-MMU)
 Handling
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-12-git-send-email-vgupta@synopsys.com> <20121116045828.GB22671@ZenIV.linux.org.uk> <50DC0E21.90503@synopsys.com>
In-Reply-To: <50DC0E21.90503@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 December 2012 02:30 PM, Vineet Gupta wrote:
> On Friday 16 November 2012 10:28 AM, Al Viro wrote:
>>> +	; --------- check for signals/restore-sigmask ------------
>>> +	bbit0  r9, TIF_SIGPENDING, chk_next_work
>>> +
>>> +	; save CALLEE Regs.
>>> +	; (i)  If this signal causes coredump - full regfile needed
>>> +	; (ii) If signal is SIGTRAP/SIGSTOP, task is being traced thus
>>> +	;      tracer might call PEEKUSR for a CALLEE reg
>>> +	;
>>> +	; NOTE: SP will grow up by size of CALLEE Reg-File
>>> +	SAVE_CALLEE_SAVED_USER		; clobbers r12
>>> +
>>> +	; save location of saved Callee Regs @ thread_struct->callee
>>> +	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r10
>>> +	st  sp, [r10, THREAD_CALLEE_REG]
>>> +
>>> +	bl  @do_signal
>>> +
>>> +	; unwind SP for cheap discard of Callee saved Regs
>>> +	DISCARD_CALLEE_SAVED_USER
>> Uh-oh...  And what if tracer wanted to modify callee-saved regs?
> 
> So the solution would be to either unconditionally restore all the 13 callee regs
> - or add additional state (struct thread) where ptrace makes a note that it wrote
> to a callee reg which is used here to conditional-ize the restore. Former is
> simpler to do - although it might ill-affect micro-benchmarks such as LMBench
> lat_sig. Anyhow correctness comes before optimization.

Havign coded above, I just couldn't accept the anti-optimization here. Is it
absolute sin to take a look at current->ptrace != 0 in deciding whether to
save/restore the regs. However that won't work for coredump case.
