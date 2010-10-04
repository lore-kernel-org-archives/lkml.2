Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0JDNbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:31:50 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56648 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab0JDNbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:31:48 -0400
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201010010229.o912T3rT089958@www262.sakura.ne.jp>
	<201010010519.o915Jv7v026590@www262.sakura.ne.jp>
	<20101004135524.E8A5.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101004135524.E8A5.A69D9226@jp.fujitsu.com>
Message-Id: <201010042231.EEG13079.OFSFtOMJHVFLQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 4 Oct 2010 22:31:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> > fs/binfmt_elf.c:
> >  77 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
> Can do_brk() return BAD_ADDR() _and_ !IS_ERR_VALUE() value? when?

For example, arch/mips/include/asm/processor.h has below definitions
which is smaller than INT_MAX

 47 #ifdef CONFIG_32BIT
(...snipped...)
 52 #define TASK_SIZE       0x7fff8000UL
(...snipped...)
 63 #endif
 64 
 65 #ifdef CONFIG_64BIT
(...snipped...)
 74 #define TASK_SIZE       0x10000000000UL
(...snipped...)
 91 #endif

Also, several architectures define TASK_SIZE as

  #define TASK_SIZE               PAGE_OFFSET

and PAGE_OFFSET could be 0 if CONFIG_KERNEL_RAM_BASE_ADDRESS is not defined.

include/asm-generic/page.h
 68 #ifdef CONFIG_KERNEL_RAM_BASE_ADDRESS
 69 #define PAGE_OFFSET             (CONFIG_KERNEL_RAM_BASE_ADDRESS)
 70 #else
 71 #define PAGE_OFFSET             (0)
 72 #endif

If TASK_SIZE == 0, BAD_ADDR(x) is always true and !IS_ERR_VALUE(x) can be true.
Although I don't know which combination makes such environment,
I think "BAD_ADDR() _and_ !IS_ERR_VALUE()" can happen.
