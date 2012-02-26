Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab2BZFzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 00:55:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39915 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2BZFzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 00:55:22 -0500
Message-ID: <4F49C931.4010203@zytor.com>
Date: Sat, 25 Feb 2012 21:54:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Bobby Powers <bobbypowers@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, hjl.tools@gmail.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x32: make sure TS_COMPAT is cleared for x32 tasks
References: <1330230338-25077-1-git-send-email-bobbypowers@gmail.com>
In-Reply-To: <1330230338-25077-1-git-send-email-bobbypowers@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2012 08:25 PM, Bobby Powers wrote:
> If a process has a non-x32 ia32 personality and changes to x32, the
> process would keep its TS_COMPAT flag. x32 uses the presence of the
> x32 flag on a syscall to determine compat status, so make sure
> TS_COMPAT is cleared.
> 
> Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
> ---
>  arch/x86/kernel/process_64.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index e9ec8f1..a465973 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -539,6 +539,9 @@ void set_personality_ia32(bool x32)
>  		clear_thread_flag(TIF_IA32);
>  		set_thread_flag(TIF_X32);
>  		current->personality &= ~READ_IMPLIES_EXEC;
> +		/* is_compat_task() uses the presence of the x32
> +		   syscall bit flag to determine compat status */
> +		current_thread_info()->status &= ~TS_COMPAT;
>  	} else {
>  		set_thread_flag(TIF_IA32);
>  		clear_thread_flag(TIF_X32);

I suspect we should also clear TS_COMPAT in set_personality_64() ...
this is not x32-related, but would affect the behavior when execing a
64-bit task from an i386 compatibility task.  I have no idea if it
actually makes any difference, and clearly it can't have been too broken
since noone has found a problem all these years, but it looks wrong...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

