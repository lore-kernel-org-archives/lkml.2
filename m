Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab1HOAdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 20:33:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57542 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1HOAdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 20:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <1313182881-21266-1-git-send-email-slyfox@gentoo.org>
References: <1313182881-21266-1-git-send-email-slyfox@gentoo.org>
From: Matt Turner <mattst88@gmail.com>
Date: Sun, 14 Aug 2011 20:32:48 -0400
Message-ID: <CAEdQ38EjVZcjDVf=0SwdmMb7+TQETvPtFwGr1CPG4oZVckShtA@mail.gmail.com>
Subject: Re: [PATCH v2] Alpha: unbreak osf_setsysinfo(SSI_NVPAIRS,
 [SSIN_UACPROC, UAC_SIGBUS])
To: Sergei Trofimovich <slyfox@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 5:01 PM, Sergei Trofimovich <slyfox@gentoo.org> wrote:
> The bug was accidentally found by the following program:
>    #include <asm/sysinfo.h>
>    #include <asm/unistd.h>
>    #include <sys/syscall.h>
>    static int setsysinfo(unsigned long op, void *buffer, unsigned long size,
>                          int *start, void *arg, unsigned long flag) {
>        return syscall(__NR_osf_setsysinfo, op, buffer, size, start, arg, flag);
>    }
>
>    int main(int argc, char **argv) {
>        short x[10];
>        unsigned int buf[2] = { SSIN_UACPROC, UAC_SIGBUS, };
>        setsysinfo(SSI_NVPAIRS, buf, 1, 0, 0, 0);
>
>        int  *y = (int*) (x+1);
>        *y = 0;
>        return 0;
>    }
>
> The program shoud fail on SIGBUS, but didn't.
>
> The patch is a second part of userspace flag fix:
>> commit 745dd2405e281d96c0a449103bdf6a895048f28c
>> Author: Michael Cree <mcree@orcon.net.nz>
>> Date:   Mon Nov 30 22:44:40 2009 -0500
>>
>>    Alpha: Rearrange thread info flags fixing two regressions
>>
>>    Both regressions fixed by (1) rearranging TIF_NOTIFY_RESUME flag to be
>>    in lower 8 bits of the thread info flags, and (2) making sure that
>>    ALPHA_UAC_SHIFT matches the rearrangement of the thread info flags.
>
> Deleted outdated out-of-sync 'UAC_SHIFT' (the cause of bug) in favour of 'ALPHA_UAC_SHIFT'.
>
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> Cc: linux-alpha@vger.kernel.org
> Cc: Michael Cree <mcree@orcon.net.nz>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> ---
>  arch/alpha/include/asm/sysinfo.h     |    9 ---------
>  arch/alpha/include/asm/thread_info.h |    8 ++++----
>  arch/alpha/kernel/osf_sys.c          |    7 ++++---
>  3 files changed, 8 insertions(+), 16 deletions(-)
>
> diff --git a/arch/alpha/include/asm/sysinfo.h b/arch/alpha/include/asm/sysinfo.h
> index 086aba2..e77d77c 100644
> --- a/arch/alpha/include/asm/sysinfo.h
> +++ b/arch/alpha/include/asm/sysinfo.h
> @@ -27,13 +27,4 @@
>  #define UAC_NOFIX                      2
>  #define UAC_SIGBUS                     4
>
> -
> -#ifdef __KERNEL__
> -
> -/* This is the shift that is applied to the UAC bits as stored in the
> -   per-thread flags.  See thread_info.h.  */
> -#define UAC_SHIFT                      6
> -
> -#endif
> -
>  #endif /* __ASM_ALPHA_SYSINFO_H */
> diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
> index 6f32f9c..ff73db0 100644
> --- a/arch/alpha/include/asm/thread_info.h
> +++ b/arch/alpha/include/asm/thread_info.h
> @@ -74,9 +74,9 @@ register struct thread_info *__current_thread_info __asm__("$8");
>  #define TIF_NEED_RESCHED       3       /* rescheduling necessary */
>  #define TIF_POLLING_NRFLAG     8       /* poll_idle is polling NEED_RESCHED */
>  #define TIF_DIE_IF_KERNEL      9       /* dik recursion lock */
> -#define TIF_UAC_NOPRINT                10      /* see sysinfo.h */
> -#define TIF_UAC_NOFIX          11
> -#define TIF_UAC_SIGBUS         12
> +#define TIF_UAC_NOPRINT                10      /* ! Preserve sequence of following */
> +#define TIF_UAC_NOFIX          11      /* ! flags as they match            */
> +#define TIF_UAC_SIGBUS         12      /* ! userspace part of 'osf_sysinfo' */
>  #define TIF_MEMDIE             13      /* is terminating due to OOM killer */
>  #define TIF_RESTORE_SIGMASK    14      /* restore signal mask in do_signal */
>  #define TIF_FREEZE             16      /* is freezing for suspend */
> @@ -97,7 +97,7 @@ register struct thread_info *__current_thread_info __asm__("$8");
>  #define _TIF_ALLWORK_MASK      (_TIF_WORK_MASK         \
>                                 | _TIF_SYSCALL_TRACE)
>
> -#define ALPHA_UAC_SHIFT                10
> +#define ALPHA_UAC_SHIFT                TIF_UAC_NOPRINT
>  #define ALPHA_UAC_MASK         (1 << TIF_UAC_NOPRINT | 1 << TIF_UAC_NOFIX | \
>                                 1 << TIF_UAC_SIGBUS)
>
> diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
> index 326f0a2..2032f67 100644
> --- a/arch/alpha/kernel/osf_sys.c
> +++ b/arch/alpha/kernel/osf_sys.c
> @@ -42,6 +42,7 @@
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
>  #include <asm/sysinfo.h>
> +#include <asm/thread_info.h>
>  #include <asm/hwrpb.h>
>  #include <asm/processor.h>
>
> @@ -633,7 +634,7 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned long, op, void __user *, buffer,
>        case GSI_UACPROC:
>                if (nbytes < sizeof(unsigned int))
>                        return -EINVAL;
> -               w = (current_thread_info()->flags >> UAC_SHIFT) & UAC_BITMASK;
> +               w = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) & UAC_BITMASK;
>                if (put_user(w, (unsigned int __user *)buffer))
>                        return -EFAULT;
>                return 1;
> @@ -756,8 +757,8 @@ SYSCALL_DEFINE5(osf_setsysinfo, unsigned long, op, void __user *, buffer,
>                        case SSIN_UACPROC:
>                        again:
>                                old = current_thread_info()->flags;
> -                               new = old & ~(UAC_BITMASK << UAC_SHIFT);
> -                               new = new | (w & UAC_BITMASK) << UAC_SHIFT;
> +                               new = old & ~(UAC_BITMASK << ALPHA_UAC_SHIFT);
> +                               new = new | (w & UAC_BITMASK) << ALPHA_UAC_SHIFT;
>                                if (cmpxchg(&current_thread_info()->flags,
>                                            old, new) != old)
>                                        goto again;
> --
> 1.7.3.4

Thanks for finding and fixing this bug. I've added it to my tree.

Matt
