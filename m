Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab2ECAqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:46:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22568 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2ECAql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:46:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6699"; a="184816121"
Date: Wed, 2 May 2012 19:46:38 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: Re: [patch 10/29] hexagon: Use generic idle_task
Message-ID: <20120503004638.GA3541@codeaurora.org>
References: <20120430194725.763322463@linutronix.de>
 <20120430194846.162247700@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430194846.162247700@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:15:56PM -0000, Thomas Gleixner wrote:
> Same code. Use the generic version. The special Makefile treatment is
> pointless anyway as init_task.o contains only data which is handled by
> the linker script. So no point on being treated like head text.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> ---
>  arch/hexagon/Kconfig            |    1 
>  arch/hexagon/Makefile           |    3 --
>  arch/hexagon/kernel/Makefile    |    2 -
>  arch/hexagon/kernel/init_task.c |   54 ----------------------------------------
>  4 files changed, 3 insertions(+), 57 deletions(-)
> 
> Index: tip/arch/hexagon/Kconfig
> ===================================================================
> --- tip.orig/arch/hexagon/Kconfig
> +++ tip/arch/hexagon/Kconfig
> @@ -28,6 +28,7 @@ config HEXAGON
>  	select NO_IOPORT
>  	select GENERIC_IOMAP
>  	select GENERIC_SMP_IDLE_THREAD
> +	select HAVE_GENERIC_INIT_TASK
>  	# mostly generic routines, with some accelerated ones
>  	---help---
>  	  Qualcomm Hexagon is a processor architecture designed for high
> Index: tip/arch/hexagon/Makefile
> ===================================================================
> --- tip.orig/arch/hexagon/Makefile
> +++ tip/arch/hexagon/Makefile
> @@ -45,8 +45,7 @@ KBUILD_AFLAGS += -DTHREADINFO_REG=$(TIR_
>  LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
>  libs-y += $(LIBGCC)
>  
> -head-y := arch/hexagon/kernel/head.o \
> -	arch/hexagon/kernel/init_task.o
> +head-y := arch/hexagon/kernel/head.o
>  
>  core-y += arch/hexagon/kernel/ \
>  	arch/hexagon/mm/ \
> Index: tip/arch/hexagon/kernel/Makefile
> ===================================================================
> --- tip.orig/arch/hexagon/kernel/Makefile
> +++ tip/arch/hexagon/kernel/Makefile
> @@ -1,4 +1,4 @@
> -extra-y := head.o vmlinux.lds init_task.o
> +extra-y := head.o vmlinux.lds
>  
>  obj-$(CONFIG_SMP) += smp.o topology.o
>  
> Index: tip/arch/hexagon/kernel/init_task.c
> ===================================================================
> --- tip.orig/arch/hexagon/kernel/init_task.c
> +++ /dev/null
> @@ -1,54 +0,0 @@
> -/*
> - * Init task definition
> - *
> - * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 and
> - * only version 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> - * 02110-1301, USA.
> - */
> -
> -#include <linux/mm.h>
> -#include <linux/module.h>
> -#include <linux/sched.h>
> -#include <linux/init_task.h>
> -#include <linux/fs.h>
> -#include <linux/mqueue.h>
> -#include <asm/thread_info.h>
> -#include <asm/uaccess.h>
> -#include <asm/pgtable.h>
> -
> -static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
> -static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
> -
> -/*
> - * Initial thread structure.
> - *
> - * We need to make sure that this is 8192-byte aligned due to the
> - * way process stacks are handled. This is done by making sure
> - * the linker maps this in the .text segment right after head.S,
> - * and making head.S ensure the proper alignment.
> - */
> -union thread_union init_thread_union
> -	__attribute__((__section__(".data.init_task"),
> -		__aligned__(THREAD_SIZE))) = {
> -			INIT_THREAD_INFO(init_task)
> -		};
> -
> -/*
> - * Initial task structure.
> - *
> - * All other task structs will be allocated on slabs in fork.c
> - */
> -struct task_struct init_task = INIT_TASK(init_task);
> -EXPORT_SYMBOL(init_task);
> 
> 

Acked-and-tested-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
