Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab0I2S2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:28:10 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16351 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab0I2S2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:28:08 -0400
Message-ID: <4CA38538.8000007@caviumnetworks.com>
Date: Wed, 29 Sep 2010 11:28:08 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 3/5] mips: sanitize restart logics
References: <E1P0eK5-0006j5-4q@ZenIV.linux.org.uk>
In-Reply-To: <E1P0eK5-0006j5-4q@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 18:28:08.0304 (UTC) FILETIME=[107E4F00:01CB6004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 10:50 AM, Al Viro wrote:
>
> Put the original syscall number into ->regs[0] when we leave syscall
> with error.  Use it in restart logics.  Everything else will have
> it 0 since we pass through SAVE_SOME on all the ways in.  Note that
> in places like bad_stack and inllegal_syscall we leave it 0 - it's
> not restartable.
>

IIRC Userspace getcontext/setcontext rely on regs[0] having a value of 
zero in the when the signal handlers are invoked.

I haven't fully traced through the code, but I hope that this 
'invariant' holds both before and after this patch.  I think Maciej did 
the work on getcontext/setcontext, he may know for sure what the 
requirements are.

David Daney


> Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>
> ---
>   arch/mips/kernel/branch.c      |    1 -
>   arch/mips/kernel/scall32-o32.S |    9 ++++-----
>   arch/mips/kernel/scall64-64.S  |    7 ++++---
>   arch/mips/kernel/scall64-n32.S |    6 ++++--
>   arch/mips/kernel/scall64-o32.S |    7 ++++---
>   arch/mips/kernel/signal.c      |   37 ++++++++++++++++++-------------------
>   arch/mips/kernel/unaligned.c   |    2 --
>   7 files changed, 34 insertions(+), 35 deletions(-)
>
> diff --git a/arch/mips/kernel/branch.c b/arch/mips/kernel/branch.c
> index 0176ed0..32103cc 100644
> --- a/arch/mips/kernel/branch.c
> +++ b/arch/mips/kernel/branch.c
> @@ -40,7 +40,6 @@ int __compute_return_epc(struct pt_regs *regs)
>   		return -EFAULT;
>   	}
>
> -	regs->regs[0] = 0;
>   	switch (insn.i_format.opcode) {
>   	/*
>   	 * jr and jalr are in r_format format.
> diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
> index 17202bb..d3edb9f 100644
> --- a/arch/mips/kernel/scall32-o32.S
> +++ b/arch/mips/kernel/scall32-o32.S
> @@ -63,9 +63,9 @@ stack_done:
>   	sw	t0, PT_R7(sp)		# set error flag
>   	beqz	t0, 1f
>
> +	lw	t1, PR_R2(sp)		# syscall number
>   	negu	v0			# error
> -	sw	v0, PT_R0(sp)		# set flag for syscall
> -					# restarting
> +	sw	t1, PT_R0(sp)		# save it for syscall restarting
>   1:	sw	v0, PT_R2(sp)		# result
>
>   o32_syscall_exit:
> @@ -104,9 +104,9 @@ syscall_trace_entry:
>   	sw	t0, PT_R7(sp)		# set error flag
>   	beqz	t0, 1f
>
> +	lw	t1, PT_R2(sp)		# syscall number
>   	negu	v0			# error
> -	sw	v0, PT_R0(sp)		# set flag for syscall
> -					# restarting
> +	sw	t1, PT_R0(sp)		# save it for syscall restarting
>   1:	sw	v0, PT_R2(sp)		# result
>
>   	j	syscall_exit
> @@ -170,7 +170,6 @@ stackargs:
>   	 */
>   bad_stack:
>   	negu	v0				# error
> -	sw	v0, PT_R0(sp)
>   	sw	v0, PT_R2(sp)
>   	li	t0, 1				# set error flag
>   	sw	t0, PT_R7(sp)
> diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
> index a8a6c59..eb0bb73 100644
> --- a/arch/mips/kernel/scall64-64.S
> +++ b/arch/mips/kernel/scall64-64.S
> @@ -66,9 +66,9 @@ NESTED(handle_sys64, PT_SIZE, sp)
>   	sd	t0, PT_R7(sp)		# set error flag
>   	beqz	t0, 1f
>
> +	ld	t1, PT_R2(sp)		# syscall number
>   	dnegu	v0			# error
> -	sd	v0, PT_R0(sp)		# set flag for syscall
> -					# restarting
> +	sd	t1, PT_R0(sp)		# save it for syscall restarting
>   1:	sd	v0, PT_R2(sp)		# result
>
>   n64_syscall_exit:
> @@ -109,8 +109,9 @@ syscall_trace_entry:
>   	sd	t0, PT_R7(sp)		# set error flag
>   	beqz	t0, 1f
>
> +	ld	t1, PT_R2(sp)		# syscall number
>   	dnegu	v0			# error
> -	sd	v0, PT_R0(sp)		# set flag for syscall restarting
> +	sd	t1, PT_R0(sp)		# save it for syscall restarting
>   1:	sd	v0, PT_R2(sp)		# result
>
>   	j	syscall_exit
> diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
> index a3d6613..4da3faf 100644
> --- a/arch/mips/kernel/scall64-n32.S
> +++ b/arch/mips/kernel/scall64-n32.S
> @@ -65,8 +65,9 @@ NESTED(handle_sysn32, PT_SIZE, sp)
>   	sd	t0, PT_R7(sp)		# set error flag
>   	beqz	t0, 1f
>
> +	ld	t1, PT_R2(sp)		# syscall number
>   	dnegu	v0			# error
> -	sd	v0, PT_R0(sp)		# set flag for syscall restarting
> +	sd	t1, PT_R0(sp)		# save it for syscall restarting
>   1:	sd	v0, PT_R2(sp)		# result
>
>   	local_irq_disable		# make sure need_resched and
> @@ -106,8 +107,9 @@ n32_syscall_trace_entry:
>   	sd	t0, PT_R7(sp)		# set error flag
>   	beqz	t0, 1f
>
> +	ld	t1, PT_R2(sp)		# syscall number
>   	dnegu	v0			# error
> -	sd	v0, PT_R0(sp)		# set flag for syscall restarting
> +	sd	t1, PT_R0(sp)		# save it for syscall restarting
>   1:	sd	v0, PT_R2(sp)		# result
>
>   	j	syscall_exit
> diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
> index 813689e..7ce0a36 100644
> --- a/arch/mips/kernel/scall64-o32.S
> +++ b/arch/mips/kernel/scall64-o32.S
> @@ -93,8 +93,9 @@ NESTED(handle_sys, PT_SIZE, sp)
>   	sd	t0, PT_R7(sp)		# set error flag
>   	beqz	t0, 1f
>
> +	ld	t1, PT_R2(sp)		# syscall number
>   	dnegu	v0			# error
> -	sd	v0, PT_R0(sp)		# flag for syscall restarting
> +	sd	t1, PT_R0(sp)		# save it for syscall restarting
>   1:	sd	v0, PT_R2(sp)		# result
>
>   o32_syscall_exit:
> @@ -142,8 +143,9 @@ trace_a_syscall:
>   	sd	t0, PT_R7(sp)		# set error flag
>   	beqz	t0, 1f
>
> +	ld	t1, PT_R2(sp)		# syscall number
>   	dnegu	v0			# error
> -	sd	v0, PT_R0(sp)		# set flag for syscall restarting
> +	sd	t1, PT_R0(sp)		# save it for syscall restarting
>   1:	sd	v0, PT_R2(sp)		# result
>
>   	j	syscall_exit
> @@ -155,7 +157,6 @@ trace_a_syscall:
>   	 */
>   bad_stack:
>   	dnegu	v0			# error
> -	sd	v0, PT_R0(sp)
>   	sd	v0, PT_R2(sp)
>   	li	t0, 1			# set error flag
>   	sd	t0, PT_R7(sp)
> diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
> index b3273ae..604f077 100644
> --- a/arch/mips/kernel/signal.c
> +++ b/arch/mips/kernel/signal.c
> @@ -550,23 +550,26 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
>   	struct mips_abi *abi = current->thread.abi;
>   	void *vdso = current->mm->context.vdso;
>
> -	switch(regs->regs[0]) {
> -	case ERESTART_RESTARTBLOCK:
> -	case ERESTARTNOHAND:
> -		regs->regs[2] = EINTR;
> -		break;
> -	case ERESTARTSYS:
> -		if (!(ka->sa.sa_flags&  SA_RESTART)) {
> +	if (regs->regs[0]) {
> +		switch(regs->regs[2]) {
> +		case ERESTART_RESTARTBLOCK:
> +		case ERESTARTNOHAND:
>   			regs->regs[2] = EINTR;
>   			break;
> +		case ERESTARTSYS:
> +			if (!(ka->sa.sa_flags&  SA_RESTART)) {
> +				regs->regs[2] = EINTR;
> +				break;
> +			}
> +		/* fallthrough */
> +		case ERESTARTNOINTR:
> +			regs->regs[7] = regs->regs[26];
> +			regs->regs[2] = regs->regs[0];
> +			regs->cp0_epc -= 4;
>   		}
> -	/* fallthrough */
> -	case ERESTARTNOINTR:		/* Userland will reload $v0.  */
> -		regs->regs[7] = regs->regs[26];
> -		regs->cp0_epc -= 8;
> -	}
>
> -	regs->regs[0] = 0;		/* Don't deal with this again.  */
> +		regs->regs[0] = 0;		/* Don't deal with this again.  */
> +	}
>
>   	if (sig_uses_siginfo(ka))
>   		ret = abi->setup_rt_frame(vdso + abi->rt_signal_return_offset,
> @@ -625,17 +628,13 @@ static void do_signal(struct pt_regs *regs)
>   		return;
>   	}
>
> -	/*
> -	 * Who's code doesn't conform to the restartable syscall convention
> -	 * dies here!!!  The li instruction, a single machine instruction,
> -	 * must directly be followed by the syscall instruction.
> -	 */
>   	if (regs->regs[0]) {
>   		if (regs->regs[2] == ERESTARTNOHAND ||
>   		    regs->regs[2] == ERESTARTSYS ||
>   		    regs->regs[2] == ERESTARTNOINTR) {
> +			regs->regs[2] = regs->regs[0];
>   			regs->regs[7] = regs->regs[26];
> -			regs->cp0_epc -= 8;
> +			regs->cp0_epc -= 4;
>   		}
>   		if (regs->regs[2] == ERESTART_RESTARTBLOCK) {
>   			regs->regs[2] = current->thread.abi->restart;
> diff --git a/arch/mips/kernel/unaligned.c b/arch/mips/kernel/unaligned.c
> index 69b039c..33d5a5c 100644
> --- a/arch/mips/kernel/unaligned.c
> +++ b/arch/mips/kernel/unaligned.c
> @@ -109,8 +109,6 @@ static void emulate_load_store_insn(struct pt_regs *regs,
>   	unsigned long value;
>   	unsigned int res;
>
> -	regs->regs[0] = 0;
> -
>   	/*
>   	 * This load never faults.
>   	 */

