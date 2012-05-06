Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2EFR67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:58:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34868 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab2EFR66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:58:58 -0400
Message-ID: <4FA6BBD9.3040308@zytor.com>
Date: Sun, 06 May 2012 10:58:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
References: <20120506162000.GT6871@ZenIV.linux.org.uk> <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com> <20120506175451.GU6871@ZenIV.linux.org.uk>
In-Reply-To: <20120506175451.GU6871@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2012 10:54 AM, Al Viro wrote:
> 
> Note that we have different semantics for is_compat_task() on x86 and
> everywhere (AFAICS) else: "is this a 32bit syscall" vs. "is this a biarch
> syscall with 32bit pointers, etc.".  On architectures where 32bit syscall
> can't be issued by 64bit task and vice versa there's no difference, but for
> e.g. sparc there definitely is one.  is_compat_task() there goes by what
> the task is, not what kind of syscall is it trying to make.  It mostly
> doesn't matter (is_compat_task() has very few users), but I suspect that
> for e.g. ext4 is_32bit_api() it does matter and is currently broken...
> 
> What kind of semantics do we want?  "Thread property" one, set when we
> set personality on execve(), or "syscall property", like e.g. x86 TIF_IRET
> and TS_COMPAT?

It depends on the ABI properties of the platform.  The x86 compat ABI is
that any task can issue a compat ABI request and get a compat ABI
response (a 64-bit task can call int $0x80 for an ia32 syscall
invocation, or use syscall with either an x86-64 or and x32 system call
number.)  So is_compat_task() returns the current system call mode of
the task, because that is what downstream users need.  One of the
biggest users is the input subsystem, which earns the black mark for
worst possible ABI design, and that definitely depends on the system
call type being invoked.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

