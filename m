Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1KJTw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:52:29 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:40508 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1KJTw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:52:27 -0500
Date: Thu, 10 Nov 2011 14:52:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 1/5] x86: add user_mode_vm check in
 stack_overflow_check
Message-ID: <20111110195203.GA22646@phenom.dumpdata.com>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
 <20111107055235.7928.85338.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107055235.7928.85338.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EBC2B6E.003D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:52:35PM +0900, Mitsuo Hayasaka wrote:
> The kernel stack overflow is checked in stack_overflow_check(),
> which may wrongly detect the overflow if the stack pointer
> pointed to the kernel stack accidentally.

I think you mean to say 'points'.

How do we accidently point the stack pointer to the kernel stack?

> 
> This patch adds user-mode-vm checking before it to avoid this
> misdetection and bails out early if the user stack is used.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
> 
>  arch/x86/kernel/irq_64.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
> index acf8fbf..69bca46 100644
> --- a/arch/x86/kernel/irq_64.c
> +++ b/arch/x86/kernel/irq_64.c
> @@ -38,6 +38,9 @@ static inline void stack_overflow_check(struct pt_regs *regs)
>  #ifdef CONFIG_DEBUG_STACKOVERFLOW
>  	u64 curbase = (u64)task_stack_page(current);
>  
> +	if (user_mode_vm(regs))
> +		return;
> +
>  	WARN_ONCE(regs->sp >= curbase &&
>  		  regs->sp <= curbase + THREAD_SIZE &&
>  		  regs->sp <  curbase + sizeof(struct thread_info) +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
