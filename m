Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2BTQvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:51:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21040 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2BTQvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:51:44 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=7-CSKSCuul8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8 a=Z4Rwk6OoAAAA:8 a=X1x1wx0_NnyAlWOsmR0A:9 a=HhwbPxDDW5hMyJ5LQ78A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=CY6gl2JlH4YA:10 a=jbrJJM5MRmoA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329756701.25686.31.camel@gandalf.stny.rr.com>
Subject: Re: [tip:x86/urgent] x86/nmi: Test saved %cs in NMI to determine
 nested NMI case
From: Steven Rostedt <rostedt@goodmis.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Greg KH <greg@kroah.com>
Cc: linux-tip-commits@vger.kernel.org
Date: Mon, 20 Feb 2012 11:51:41 -0500
In-Reply-To: <tip-45d5a1683c04be28abdf5c04c27b1417e0374486@git.kernel.org>
References: <1329687817.1561.27.camel@acer.local.home>
	 <tip-45d5a1683c04be28abdf5c04c27b1417e0374486@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 03:47 -0800, tip-bot for Steven Rostedt wrote:
> Commit-ID:  45d5a1683c04be28abdf5c04c27b1417e0374486
> Gitweb:     http://git.kernel.org/tip/45d5a1683c04be28abdf5c04c27b1417e0374486
> Author:     Steven Rostedt <rostedt@goodmis.org>
> AuthorDate: Sun, 19 Feb 2012 16:43:37 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 20 Feb 2012 09:09:57 +0100
> 
> x86/nmi: Test saved %cs in NMI to determine nested NMI case
> 
> Currently, the NMI handler tests if it is nested by checking the
> special variable saved on the stack (set during NMI handling)
> and whether the saved stack is the NMI stack as well (to prevent
> the race when the variable is set to zero).
> 
> But userspace may set their %rsp to any value as long as they do
> not derefence it, and it may make it point to the NMI stack,
> which will prevent NMIs from triggering while the userspace app
> is running. (I tested this, and it is indeed the case)
> 
> Add another check to determine nested NMIs by looking at the
> saved %cs (code segment register) and making sure that it is the
> kernel code segment.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: <stable@kernel.org>

Just so that we do not confuse Greg, the bug was introduced in the 3.3
merge window. It does not exist in 3.2 or earlier.

-- Steve



> Link: http://lkml.kernel.org/r/1329687817.1561.27.camel@acer.local.home
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/entry_64.S |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 3fe8239..debd851 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1532,6 +1532,13 @@ ENTRY(nmi)
>  	pushq_cfi %rdx
>  
>  	/*
> +	 * If %cs was not the kernel segment, then the NMI triggered in user
> +	 * space, which means it is definitely not nested.
> +	 */
> +	cmp $__KERNEL_CS, 16(%rsp)
> +	jne first_nmi
> +
> +	/*
>  	 * Check the special variable on the stack to see if NMIs are
>  	 * executing.
>  	 */


