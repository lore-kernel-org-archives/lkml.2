Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2FTQmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:42:45 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59714 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab2FTQmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:42:43 -0400
Date: Wed, 20 Jun 2012 18:42:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 02/23] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120620164233.GB7714@somewhere.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
 <1340120894-9465-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340120894-9465-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 05:47:53PM +0200, Jiri Olsa wrote:
> This brings a new API to help the selective dump of registers on
> event sampling, and its implementation for x86 arch.
> 
> Added HAVE_PERF_REGS config option to determine if the architecture
> provides perf registers ABI.
> 
> The information about desired registers will be passed in u64 mask.
> It's up to the architecture to map the registers into the mask bits.
> 
> For the x86 arch implementation, both 32 and 64 bit registers
> bits are defined within single enum to ensure 64 bit system can
> provide register dump for compat task if needed in the future.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  arch/Kconfig                     |    6 +++
>  arch/x86/Kconfig                 |    1 +
>  arch/x86/include/asm/perf_regs.h |   34 ++++++++++++++
>  arch/x86/kernel/Makefile         |    2 +
>  arch/x86/kernel/perf_regs.c      |   90 ++++++++++++++++++++++++++++++++++++++
>  include/linux/perf_regs.h        |   19 ++++++++
>  6 files changed, 152 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/include/asm/perf_regs.h
>  create mode 100644 arch/x86/kernel/perf_regs.c
>  create mode 100644 include/linux/perf_regs.h
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 8c3d957..32f4873 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -222,6 +222,12 @@ config HAVE_PERF_EVENTS_NMI
>  	  subsystem.  Also has support for calculating CPU cycle events
>  	  to determine how many clock cycles in a given period.
>  
> +config HAVE_PERF_REGS
> +	bool
> +	help
> +	  Support selective register dumps for perf events. This includes
> +	  bit-mapping of each registers and a unique architecture id.
> +
>  config HAVE_ARCH_JUMP_LABEL
>  	bool
>  
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d35438e..457d8d6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -60,6 +60,7 @@ config X86
>  	select HAVE_MIXED_BREAKPOINTS_REGS
>  	select PERF_EVENTS
>  	select HAVE_PERF_EVENTS_NMI
> +	select HAVE_PERF_REGS
>  	select ANON_INODES
>  	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
>  	select HAVE_CMPXCHG_LOCAL if !M386
> diff --git a/arch/x86/include/asm/perf_regs.h b/arch/x86/include/asm/perf_regs.h
> new file mode 100644
> index 0000000..0397bfc
> --- /dev/null
> +++ b/arch/x86/include/asm/perf_regs.h
> @@ -0,0 +1,34 @@
> +#ifndef _ASM_X86_PERF_REGS_H
> +#define _ASM_X86_PERF_REGS_H
> +
> +enum perf_event_x86_regs {
> +	PERF_REG_X86_AX,
> +	PERF_REG_X86_BX,
> +	PERF_REG_X86_CX,
> +	PERF_REG_X86_DX,
> +	PERF_REG_X86_SI,
> +	PERF_REG_X86_DI,
> +	PERF_REG_X86_BP,
> +	PERF_REG_X86_SP,
> +	PERF_REG_X86_IP,
> +	PERF_REG_X86_FLAGS,
> +	PERF_REG_X86_CS,
> +	PERF_REG_X86_DS,
> +	PERF_REG_X86_ES,
> +	PERF_REG_X86_FS,
> +	PERF_REG_X86_GS,
> +	PERF_REG_X86_R8,
> +	PERF_REG_X86_R9,
> +	PERF_REG_X86_R10,
> +	PERF_REG_X86_R11,
> +	PERF_REG_X86_R12,
> +	PERF_REG_X86_R13,
> +	PERF_REG_X86_R14,
> +	PERF_REG_X86_R15,
> +	PERF_REG_X86_SS,
> +
> +	/* non ABI */
> +	PERF_REG_X86_64_MAX = PERF_REG_X86_SS + 1,

SS also exist in 32 bits, right?
Although I guess userspace doesn't care much.
