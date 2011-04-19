Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1DSFjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 01:39:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:51845 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1DSFik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 01:38:40 -0400
Message-ID: <4DAD1F6B.2050006@windriver.com>
Date: Tue, 19 Apr 2011 13:36:43 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-sh@vger.kernel.org>,
        <x86@kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Kgdb-bugreport] [PATCH 5/5] kgdbts: unify/generalize gdb	breakpoint
 adjustment
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <1302760895-13459-6-git-send-email-vapier@gentoo.org>
In-Reply-To: <1302760895-13459-6-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.159.136]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> The Blackfin arch, like the x86 arch, needs to adjust the PC manually
> after a breakpoint is hit as normally this is handled by the remote gdb.
> However, rather than starting another arch ifdef mess, create a common
> GDB_ADJUSTS_BREAK_OFFSET define for any arch to opt-in via their kgdb.h.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>


Acked-by: Dongdong Deng <dongdong.deng@windriver.com>


> ---
>  arch/blackfin/include/asm/kgdb.h |    1 +
>  arch/sh/include/asm/kgdb.h       |    1 +
>  arch/x86/include/asm/kgdb.h      |    1 +
>  drivers/misc/kgdbts.c            |   29 +++++++++++------------------
>  4 files changed, 14 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/blackfin/include/asm/kgdb.h b/arch/blackfin/include/asm/kgdb.h
> index 3ac0c72..aaf8845 100644
> --- a/arch/blackfin/include/asm/kgdb.h
> +++ b/arch/blackfin/include/asm/kgdb.h
> @@ -108,6 +108,7 @@ static inline void arch_kgdb_breakpoint(void)
>  #else
>  # define CACHE_FLUSH_IS_SAFE	1
>  #endif
> +#define GDB_ADJUSTS_BREAK_OFFSET
>  #define HW_INST_WATCHPOINT_NUM	6
>  #define HW_WATCHPOINT_NUM	8
>  #define TYPE_INST_WATCHPOINT	0
> diff --git a/arch/sh/include/asm/kgdb.h b/arch/sh/include/asm/kgdb.h
> index 4235e22..f361395 100644
> --- a/arch/sh/include/asm/kgdb.h
> +++ b/arch/sh/include/asm/kgdb.h
> @@ -34,5 +34,6 @@ static inline void arch_kgdb_breakpoint(void)
>  
>  #define CACHE_FLUSH_IS_SAFE	1
>  #define BREAK_INSTR_SIZE	2
> +#define GDB_ADJUSTS_BREAK_OFFSET
>  
>  #endif /* __ASM_SH_KGDB_H */
> diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
> index 396f5b5..77e95f5 100644
> --- a/arch/x86/include/asm/kgdb.h
> +++ b/arch/x86/include/asm/kgdb.h
> @@ -77,6 +77,7 @@ static inline void arch_kgdb_breakpoint(void)
>  }
>  #define BREAK_INSTR_SIZE	1
>  #define CACHE_FLUSH_IS_SAFE	1
> +#define GDB_ADJUSTS_BREAK_OFFSET
>  
>  extern int kgdb_ll_trap(int cmd, const char *str,
>  			struct pt_regs *regs, long err, int trap, int sig);
> diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
> index 59c118c..d475ce0 100644
> --- a/drivers/misc/kgdbts.c
> +++ b/drivers/misc/kgdbts.c
> @@ -285,33 +285,26 @@ static void hw_break_val_write(void)
>  static int check_and_rewind_pc(char *put_str, char *arg)
>  {
>  	unsigned long addr = lookup_addr(arg);
> +	unsigned long ip;
>  	int offset = 0;
>  
>  	kgdb_hex2mem(&put_str[1], (char *)kgdbts_gdb_regs,
>  		 NUMREGBYTES);
>  	gdb_regs_to_pt_regs(kgdbts_gdb_regs, &kgdbts_regs);
> -	v2printk("Stopped at IP: %lx\n", instruction_pointer(&kgdbts_regs));
> -#ifdef CONFIG_X86
> -	/* On x86 a breakpoint stop requires it to be decremented */
> -	if (addr + 1 == kgdbts_regs.ip)
> -		offset = -1;
> -#elif defined(CONFIG_SUPERH)
> -	/* On SUPERH a breakpoint stop requires it to be decremented */
> -	if (addr + 2 == kgdbts_regs.pc)
> -		offset = -2;
> +	ip = instruction_pointer(&kgdbts_regs);
> +	v2printk("Stopped at IP: %lx\n", ip);
> +#ifdef GDB_ADJUSTS_BREAK_OFFSET
> +	/* On some arches, a breakpoint stop requires it to be decremented */
> +	if (addr + BREAK_INSTR_SIZE == ip)
> +		offset = -BREAK_INSTR_SIZE;
>  #endif
> -	if (strcmp(arg, "silent") &&
> -		instruction_pointer(&kgdbts_regs) + offset != addr) {
> +	if (strcmp(arg, "silent") && ip + offset != addr) {
>  		eprintk("kgdbts: BP mismatch %lx expected %lx\n",
> -			   instruction_pointer(&kgdbts_regs) + offset, addr);
> +			   ip + offset, addr);
>  		return 1;
>  	}
> -#ifdef CONFIG_X86
> -	/* On x86 adjust the instruction pointer if needed */
> -	kgdbts_regs.ip += offset;
> -#elif defined(CONFIG_SUPERH)
> -	kgdbts_regs.pc += offset;
> -#endif
> +	/* Readjust the instruction pointer if needed */
> +	instruction_pointer_set(&kgdbts_regs, ip + offset);
>  	return 0;
>  }
>  

