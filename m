Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab1CCQrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:47:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61137 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1CCQrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FvotxYa6q79c9ifWfmvBhbQJkAZ+PkSG+amqYZPpD2tuBqmDt68BEr8gPRpUdJvzgE
         v5trTghhz+ll7J0+VzPyJy7YknhucpiP9kdVi8cAYfRghsMwZ7oTZUTnKY23uQevbZLm
         XnkLFxDOcIGQcmLM6+ZjiEpKjtN6v5tWyoxb4=
Date: Thu, 3 Mar 2011 17:47:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -tip] x86: correct stack dump info when
 CONFIG_FRAME_POINTER=y
Message-ID: <20110303164723.GA1807@nowhere>
References: <1299086232-29639-1-git-send-email-namhyung@gmail.com>
 <1299151037-5881-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299151037-5881-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 08:17:17PM +0900, Namhyung Kim wrote:
> Current stack dump code scans entire stack and check each entry
> contains a pointer to kernel code. If CONFIG_FRAME_POINTER=y it
> could mark whether the pointer is valid or not based on value of
> the frame pointer. A invalid entry could be preceded by '?' sign.
> 
> However this was not going to happen because scan start point was
> always higher than the frame pointer so that they could not meet.
> So all of the entries were marked invalid.
> 
> This patch fixes this by unwinding the frame pointer up to desired
> stack frame. End result looks like below.
> 
> before:
> [    3.508329] Call Trace:
> [    3.508551]  [<ffffffff814f35c9>] ? panic+0x91/0x199
> [    3.508662]  [<ffffffff814f3739>] ? printk+0x68/0x6a
> [    3.508770]  [<ffffffff81a981b2>] ? mount_block_root+0x257/0x26e
> [    3.508876]  [<ffffffff81a9821f>] ? mount_root+0x56/0x5a
> [    3.508975]  [<ffffffff81a98393>] ? prepare_namespace+0x170/0x1a9
> [    3.509216]  [<ffffffff81a9772b>] ? kernel_init+0x1d2/0x1e2
> [    3.509335]  [<ffffffff81003894>] ? kernel_thread_helper+0x4/0x10
> [    3.509442]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
> [    3.509542]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
> [    3.509641]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
> 
> after:
> [    3.522991] Call Trace:
> [    3.523351]  [<ffffffff814f35b9>] panic+0x91/0x199
> [    3.523468]  [<ffffffff814f3729>] ? printk+0x68/0x6a
> [    3.523576]  [<ffffffff81a981b2>] mount_block_root+0x257/0x26e
> [    3.523681]  [<ffffffff81a9821f>] mount_root+0x56/0x5a
> [    3.523780]  [<ffffffff81a98393>] prepare_namespace+0x170/0x1a9
> [    3.523885]  [<ffffffff81a9772b>] kernel_init+0x1d2/0x1e2
> [    3.523987]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
> [    3.524228]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
> [    3.524345]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
> [    3.524445]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10

Ah that must explain the bugs reports I've seen lately.

> @@ -60,25 +60,39 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
>  
>  #ifdef CONFIG_FRAME_POINTER
>  static inline unsigned long
> -stack_frame(struct task_struct *task, struct pt_regs *regs)
> +stack_frame(struct task_struct *task, struct pt_regs *regs,
> +	    unsigned long *stack)
>  {
> -	unsigned long bp;
> +	unsigned long bp, old_bp;
>  
> -	if (regs)
> -		return regs->bp;
> -
> -	if (task == current) {
> +	if (regs) {
> +		bp = regs->bp;
> +	} else if (task == current) {
>  		/* Grab bp right from our regs */
>  		get_bp(bp);
> -		return bp;
> +	} else {
> +		/* bp is the last reg pushed by switch_to */
> +		bp = *(unsigned long *)task->thread.sp;
> +	}
> +
> +	old_bp = bp;
> +	/* unwind up to desired stack frame */
> +	while (bp < (unsigned long) stack) {
> +		bp = *(unsigned long *) bp;
> +
> +		/* check the frame is corrupted */
> +		if (bp <= old_bp || (bp - old_bp) > THREAD_SIZE) {
> +			bp = old_bp;
> +			break;
> +		}
>  	}
>  
> -	/* bp is the last reg pushed by switch_to */
> -	return *(unsigned long *)task->thread.sp;
> +	return bp;
>  }

So, we shouldn't do this. This fixes up the effects and not the real cause.
Plus that bp dereference is rather unsafe because we don't check we don't overlap
the real boundaries of the stack.

In fact if a caller of dump_trace() passes a stack, it should pass a
frame pointer as well.

That means we need to revert 9c0729dc8062bed96189bd14ac6d4920f3958743
("x86: Eliminate bp argument from the stack tracing routines").
It would be nice to keep the unified stack_frame() helper out of the revert though, 

Would you like to do it?

Thanks.
