Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0HSDH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 23:07:58 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:37206 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751149Ab0HSDHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 23:07:55 -0400
Message-ID: <4C6C9F34.8010207@snapgear.com>
Date: Thu, 19 Aug 2010 13:04:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] m68knommu : Fix strace support for 68328/68360
References: <20100817165829.GA17086@frolo.macqel>
In-Reply-To: <20100817165829.GA17086@frolo.macqel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Aug 2010 03:07:40.0505 (UTC) FILETIME=[AF393490:01CB3F4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Philippe,

Philippe De Muyter wrote:
> m68knommu : Fix strace support for 68328/68360
> 
> strace enabled is marked using the `flags' field of the `thread_info' struct.
> 68360 version of entry.S did test a wrong bit in a wrong structure
> (task_struct).
> 68328 version of entry.S did test the right bit in the right structure,
> but wrongly, because the `flags' field is 32 bit wide, while the used
> assembler insn (btst) only accesses a 8 bit byte in memory.
> 
> Fix both using code already used in the coldfire version of entry.S
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>

Thanks. I add that to the m68knommu git tree.

Regards
Greg



> ---
> diff --git a/arch/m68knommu/platform/68328/entry.S b/arch/m68knommu/platform/68328/entry.S
> index 9d80d2c..74229f7 100644
> --- a/arch/m68knommu/platform/68328/entry.S
> +++ b/arch/m68knommu/platform/68328/entry.S
> @@ -80,7 +80,7 @@ ENTRY(system_call)
>  	movel	%sp,%d1			/* get thread_info pointer */
>  	andl	#-THREAD_SIZE,%d1
>  	movel	%d1,%a2
> -	btst    #TIF_SYSCALL_TRACE,%a2@(TI_FLAGS)
> +	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TI_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
>  	jne	do_trace
>  	cmpl	#NR_syscalls,%d0
>  	jcc	badsys
> diff --git a/arch/m68knommu/platform/68360/entry.S b/arch/m68knommu/platform/68360/entry.S
> index 6d3460a..d5ad408 100644
> --- a/arch/m68knommu/platform/68360/entry.S
> +++ b/arch/m68knommu/platform/68360/entry.S
> @@ -71,7 +71,12 @@ ENTRY(system_call)
>  	jbsr	set_esp0
>  	addql	#4,%sp
>  
> -	btst	#PF_TRACESYS_BIT,%a2@(TASK_FLAGS+PF_TRACESYS_OFF)
> +	movel	%sp@(PT_OFF_ORIG_D0),%d0
> +
> +	movel	%sp,%d1			/* get thread_info pointer */
> +	andl	#-THREAD_SIZE,%d1
> +	movel	%d1,%a2
> +	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TI_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
>  	jne	do_trace
>  	cmpl	#NR_syscalls,%d0
>  	jcc	badsys


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
