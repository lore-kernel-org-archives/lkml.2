Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0CSWdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:33:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52565 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0CSWda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:33:30 -0400
Message-ID: <4BA3FBB5.2050008@zytor.com>
Date: Fri, 19 Mar 2010 15:33:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86-32: Split cache flush handler from simd handler
References: <1268936453-3727-1-git-send-email-brgerst@gmail.com> <1268936453-3727-2-git-send-email-brgerst@gmail.com>
In-Reply-To: <1268936453-3727-2-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 11:20 AM, Brian Gerst wrote:
> Make the cache flush handler a seperate function, and use
> an alternative to call the appropriate handler.
>  
> +#ifdef CONFIG_X86_32
> +dotraplinkage void
> +do_cache_flush_error(struct pt_regs *regs, long error_code)
> +{
> +	conditional_sti(regs);
> +
> +	/*
> +	 * Handle strange cache flush from user space exception.
> +	 * This is undocumented behaviour.
> +	 */
> +	if (regs->flags & X86_VM_MASK) {
> +		handle_vm86_fault((struct kernel_vm86_regs *)regs, error_code);
> +		return;
> +	}
> +	current->thread.trap_no = 19;
> +	current->thread.error_code = error_code;
> +	die_if_kernel("cache flush denied", regs, error_code);
> +	force_sig(SIGSEGV, current);
> +}
> +#endif

Does anyone have *any idea* what processor this applies to?  I've
tracked the code back all the way to the original inclusion in the
kernel, and there isn't even the slightest hint.

The comment, of course, is a great example on how *not* to write
comments... it should have mentioned the CPU in question.

	-hpa
