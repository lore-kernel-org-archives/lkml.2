Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0CWX44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:56:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42413 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0CWX4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:56:55 -0400
Date: Tue, 23 Mar 2010 21:18:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoffer Dall <christofferdall@christofferdall.dk>
Cc: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [C/R ARM][PATCH 3/3] c/r: ARM implementation of
	checkpoint/restart
Message-ID: <20100323211843.GC19572@n2100.arm.linux.org.uk>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk> <1269219965-23923-4-git-send-email-christofferdall@christofferdall.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269219965-23923-4-git-send-email-christofferdall@christofferdall.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 09:06:05PM -0400, Christoffer Dall wrote:
> The ISA version (given by __LINUX_ARM_ARCH__) is checkpointed and verified
> against the machine architecture on restart.

I think you misunderstand what __LINUX_ARM_ARCH__ signifies.  It is the
build architecture for the kernel, and it indicates the lowest
architecture version that the kernel will run on.

That doesn't indicate what ISA version the system is running on, or even
if the ABI is compatible (we have two ABIs - OABI and EABI).

There's also the matter of FP implementation - whether it is VFP or FPA,
and whether iwMMXt is available or not.  (iwMMXt precludes the use of
FPA.)

> Regarding ThumbEE, the thumbee_state field on the thread_info is stored
> in checkpoints when CONFIG_ARM_THUMBEE and 0 is stored otherwise. If
> a value different than 0 is checkpointed and CONFIG_ARM_THUMBEE is not
> set on the restore system, the restore is aborted. Feedback on this
> implementation is very welcome.

I don't recognise this configuration symbol; it doesn't exist in mainline.

> We checkpoint whether the system is running with CONFIG_MMU or not and
> require the same configuration for the system on which we restore the
> process. It might be possible to allow something more fine-grained,
> if it's worth the energy. Input on this item is also very welcome,
> specifically from someone who knows the exact meaning of the end_brk
> field.

Processes which run on MMU and non-MMU CPUs are unlikely to be
interchangable - the run time environments are quite different.  I
think this is a sane check.

> +/* dump the thread_struct of a given task */
> +int checkpoint_thread(struct ckpt_ctx *ctx, struct task_struct *t)
> +{
> +	int ret;
> +	struct ckpt_hdr_thread *h;
> +	struct thread_info *ti = task_thread_info(t);
> +
> +	h = ckpt_hdr_get_type(ctx, sizeof(*h), CKPT_HDR_THREAD);
> +	if (!h)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Store the syscall information about the checkpointed process
> +	 * as we need to know if the process was doing a syscall (and which)
> +	 * during restart.
> +	 */
> +	h->syscall = ti->syscall;
> +
> +	/*
> +	 * Store remaining thread-specific info.
> +	 */
> +	h->tp_value = ti->tp_value;

How do you safely obtain consistent information from a thread?  Do you
temporarily stop it?
