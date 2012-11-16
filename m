Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2KPE6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:58:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58384 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2KPE63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:58:29 -0500
Date: Fri, 16 Nov 2012 04:58:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, arnd@arndb.de
Subject: Re: [RFC PATCH v1 11/31] ARC: Low level IRQ/Trap/Exception(non-MMU)
 Handling
Message-ID: <20121116045828.GB22671@ZenIV.linux.org.uk>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
 <1352281674-2186-12-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352281674-2186-12-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	; --------- check for signals/restore-sigmask ------------
> +	bbit0  r9, TIF_SIGPENDING, chk_next_work
> +
> +	; save CALLEE Regs.
> +	; (i)  If this signal causes coredump - full regfile needed
> +	; (ii) If signal is SIGTRAP/SIGSTOP, task is being traced thus
> +	;      tracer might call PEEKUSR for a CALLEE reg
> +	;
> +	; NOTE: SP will grow up by size of CALLEE Reg-File
> +	SAVE_CALLEE_SAVED_USER		; clobbers r12
> +
> +	; save location of saved Callee Regs @ thread_struct->callee
> +	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r10
> +	st  sp, [r10, THREAD_CALLEE_REG]
> +
> +	bl  @do_signal
> +
> +	; unwind SP for cheap discard of Callee saved Regs
> +	DISCARD_CALLEE_SAVED_USER

Uh-oh...  And what if tracer wanted to modify callee-saved regs?

> +	b      resume_user_mode_begin	; loop back to start of U mode ret
> +
> +	; --- notify_resume ---
> +chk_next_work:
> +	btst   r9, TIF_NOTIFY_RESUME
> +	blnz   @do_notify_resume
> +
> +	;--------- All things done, go back to Userland ------
> +
> +	b restore_regs

No.  After NOTIFY_RESUME stuff you need to recheck SIGPENDING.  This should
go to resume_user_mode_begin, not restore regs.  Another problem here is
IRQ handling - you hit do_signal()/do_notify_resume() with IRQs disabled,
which is broken - you need to re-enable it before going into either.
