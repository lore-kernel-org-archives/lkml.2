Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0JECzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 22:55:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53153 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab0JECzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 22:55:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
Cc: kosaki.motohiro@jp.fujitsu.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101005113840.28C9.A69D9226@jp.fujitsu.com>
References: <20101005102446.28C3.A69D9226@jp.fujitsu.com> <20101005113840.28C9.A69D9226@jp.fujitsu.com>
Message-Id: <20101005115656.28D1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  5 Oct 2010 11:55:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > KOSAKI Motohiro wrote:
> > > > > fs/binfmt_elf.c:
> > > > >  77 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
> > > > Can do_brk() return BAD_ADDR() _and_ !IS_ERR_VALUE() value? when?
> > > 
> > > For example, arch/mips/include/asm/processor.h has below definitions
> > > which is smaller than INT_MAX
> > > 
> > >  47 #ifdef CONFIG_32BIT
> > > (...snipped...)
> > >  52 #define TASK_SIZE       0x7fff8000UL
> > > (...snipped...)
> > >  63 #endif
> > >  64 
> > >  65 #ifdef CONFIG_64BIT
> > > (...snipped...)
> > >  74 #define TASK_SIZE       0x10000000000UL
> > > (...snipped...)
> > >  91 #endif
> > > 
> > > Also, several architectures define TASK_SIZE as
> > > 
> > >   #define TASK_SIZE               PAGE_OFFSET
> > > 
> > > and PAGE_OFFSET could be 0 if CONFIG_KERNEL_RAM_BASE_ADDRESS is not defined.
> > > 
> > > include/asm-generic/page.h
> > >  68 #ifdef CONFIG_KERNEL_RAM_BASE_ADDRESS
> > >  69 #define PAGE_OFFSET             (CONFIG_KERNEL_RAM_BASE_ADDRESS)
> > >  70 #else
> > >  71 #define PAGE_OFFSET             (0)
> > >  72 #endif
> > > 
> > > If TASK_SIZE == 0, BAD_ADDR(x) is always true and !IS_ERR_VALUE(x) can be true.
> > > Although I don't know which combination makes such environment,
> > > I think "BAD_ADDR() _and_ !IS_ERR_VALUE()" can happen.
> > 
> > I think you should read do_brk() itself. the spec is
> > 
> > success case:
> > 	return addr argument
> > 
> > error case: 
> > 	return error code
> > 
> > When does it return invalid address?
> 
> Does this makes a bit cleanups?
> 
> 
> 
> From 5f5556d30ac1876ec2211a2eae77e8372183a9b1 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 15 Oct 2010 05:13:40 +0900
> Subject: [cleanup][PATCH] elf: kill BAD_ADDR() macro
> 
> BAD_ADDR() macro is useless because 1) do_brk() and do_mmap() return
> only either valid pointer or error code 2) when kernel and userland have
> perfectly different address space (such as old 4G:4G separation), to
> compare TASK_SIZE has no good meaning.
> 
> Then, this patch change it to use IS_ERR_VALUE instead (as other a lot
> of places).
> But, this is theorical issue. this patch doesn't have functional change.

Ouch, this patch is completely corrupted. please ignore it.



