Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1HQRR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:17:57 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16878 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1HQRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:17:55 -0400
Message-ID: <4E4BF7C0.80703@cavium.com>
Date: Wed, 17 Aug 2011 10:17:52 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Yong Zhang <yong.zhang@windriver.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: use 32-bit wrapper for compat_sys_futex
References: <1313546094-11882-1-git-send-email-yong.zhang@windriver.com>
In-Reply-To: <1313546094-11882-1-git-send-email-yong.zhang@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2011 17:17:53.0680 (UTC) FILETIME=[99653900:01CC5D01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2011 06:54 PM, Yong Zhang wrote:
> We can't trust in the caller(userspace) to give signed-extend
> parameter, thus futex-wait may fail in some special case.
>
> For example, if 'val' is too big and bit-31 is 1,
> the caller may enter endless loop at:
> futex_wait_setup()
> {
> 	...
>
> 	if (uval != val) {
> 		queue_unlock(q, *hb);
> 		ret = -EWOULDBLOCK;
>
> 	...
> }
>
> Below assembler code will make it more easy to understand how
> the patch take effect :)
>
> Dump of assembler code for function SyS_32_futex:
>     0xffffffff811b6fe8<+0>:	sll	a1,a1,0x0
>     0xffffffff811b6fec<+4>:	sll	a2,a2,0x0
>     0xffffffff811b6ff0<+8>:	j	0xffffffff8121a240<compat_sys_futex>
>     0xffffffff811b6ff4<+12>:	sll	a5,a5,0x0
>
> Signed-off-by: Yong Zhang<yong.zhang@windriver.com>
> Cc: Ralf Baechle<ralf@linux-mips.org>
> ---
>   arch/mips/kernel/linux32.c     |    7 +++++++
>   arch/mips/kernel/scall64-n32.S |    2 +-
>   arch/mips/kernel/scall64-o32.S |    2 +-
>   3 files changed, 9 insertions(+), 2 deletions(-)
[...]
> diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
> index 876a75c..922a554 100644
> --- a/arch/mips/kernel/linux32.c
> +++ b/arch/mips/kernel/linux32.c
> @@ -349,3 +349,10 @@ SYSCALL_DEFINE6(32_fanotify_mark, int, fanotify_fd, unsigned int, flags,
>   	return sys_fanotify_mark(fanotify_fd, flags, merge_64(a3, a4),
>   				 dfd, pathname);
>   }
> +
> +SYSCALL_DEFINE6(32_futex, u32 __user *, uaddr, int, op, u32, val,
> +		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
> +		u32, val3)
> +{
> +	return compat_sys_futex(uaddr, op, val, utime, uaddr2, val3);
> +}
> diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
> index b85842f..c956cc9 100644
> --- a/arch/mips/kernel/scall64-n32.S
> +++ b/arch/mips/kernel/scall64-n32.S
> @@ -315,7 +315,7 @@ EXPORT(sysn32_call_table)
>   	PTR	sys_fremovexattr
>   	PTR	sys_tkill
>   	PTR	sys_ni_syscall
> -	PTR	compat_sys_futex
> +	PTR	sys_32_futex
>   	PTR	compat_sys_sched_setaffinity	/* 6195 */
>   	PTR	compat_sys_sched_getaffinity
>   	PTR	sys_cacheflush
> diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
> index 46c4763..f48b18e 100644
> --- a/arch/mips/kernel/scall64-o32.S
> +++ b/arch/mips/kernel/scall64-o32.S
> @@ -441,7 +441,7 @@ sys_call_table:
>   	PTR	sys_fremovexattr		/* 4235 */
>   	PTR	sys_tkill
>   	PTR	sys_sendfile64
> -	PTR	compat_sys_futex
> +	PTR	sys_32_futex

This change is redundant, scall64-o32.S already does the right thing
so additional zero extending is not needed and is just extra
instructions to execute for no reason.

>   	PTR	compat_sys_sched_setaffinity
>   	PTR	compat_sys_sched_getaffinity	/* 4240 */
>   	PTR	compat_sys_io_setup

But really I think this patch fixes things at the wrong level.  Each
architecture potentially needs a similar patch.  What would happen if
we did something like:


diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 5f9e689..74ada65 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -180,9 +180,9 @@ err_unlock:
  	return ret;
  }

-asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
-		struct compat_timespec __user *utime, u32 __user *uaddr2,
-		u32 val3)
+SYSCALL_DEFINE6(compat_sys_futex, u32 __user *, uaddr, int , op, u32, val,
+		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
+		u32, val3)
  {
  	struct timespec ts;
  	ktime_t t, *tp = NULL;

Obviously the function name is wrong, but a varient of
SYSCALL_DEFINE*() could be created so the proper function names are
produced.

David Daney
