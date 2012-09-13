Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2IMLDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:03:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58475 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab2IMLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:03:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 21/31] arm64: 32-bit (compat) applications support
Date: Thu, 13 Sep 2012 11:03:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <201209071947.45313.arnd@arndb.de> <20120913090732.GA25131@arm.com>
In-Reply-To: <20120913090732.GA25131@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131103.27387.arnd@arndb.de>
X-Provags-ID: V02:K0:vrqEJjz3Lg5RKXiB1duHym4+n2QNPk6r+PflEhUK3zJ
 AOc4otyxSwSQj/NwXfjsHuE6nW5iNz5Trc6RglSH8Nnn7oCe21
 Lqsjysda1/FLFUujuluZHUIHBCoXRJYbxlB5W4UpN+M3pyVMmQ
 pf7vbDkmXO7ziDrQKRoB0FDnLa1mFKtBONszL7kI0l63RpU0w1
 DJOEsyIBTP+Syle18W9gaPM3u+A5ZeWnisGJ9i/uDHEX4nb3ra
 K7KTpa4OcwNOCUL16xZc/IRYS/Qlwk4fynt4JP08BDSBJfTd6e
 cADEslwrTv4PSaCbqaohOOiVS/eLEBwdsdbPtYbtwJe2fjkU8d
 7g245K1+o0DNzFLqw6JA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2012, Catalin Marinas wrote:
> Here they are. For converting the other architectures, I'll post
> separate patches as I don't want to add an extra dependency to the
> arm64 series.

Ok, thanks!


> diff --git a/kernel/compat.c b/kernel/compat.c
> index c28a306..5f07388 100644
> --- a/kernel/compat.c
> +++ b/kernel/compat.c
> @@ -1215,6 +1215,50 @@ compat_sys_sysinfo(struct compat_sysinfo __user *info)
>         return 0;
>  }
>  
> +#ifdef __ARCH_WANT_COMPAT_SYS_SENDFILE
> +asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
> +                                  compat_off_t __user *offset, s32 count)
> +{
> +       mm_segment_t old_fs = get_fs();
> +       int ret;
> +       off_t of;
> +
> +       if (offset && get_user(of, offset))
> +               return -EFAULT;
> +
> +       set_fs(KERNEL_DS);
> +       ret = sys_sendfile(out_fd, in_fd,
> +                          offset ? (off_t __user *)&of : NULL, count);
> +       set_fs(old_fs);
> +
> +       if (offset && put_user(of, offset))
> +               return -EFAULT;
> +       return ret;
> +}
> +#endif /* __ARCH_WANT_COMPAT_SYS_SENDFILE */

Looking at this code in detail now, I think it's better to move the functions to
fs/read_write.c and get rid of the get_fs/set_fs hack, like

asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
                                   compat_off_t __user *offset, s32 count)
{       
        loff_t pos;
        compat_off_t off;
        ssize_t ret;
        
        if (offset) {
                if (unlikely(get_user(off, offset)))
                        return -EFAULT;
                pos = off;
                ret = do_sendfile(out_fd, in_fd, &pos, count, MAX_NON_LFS);
                if (unlikely(put_user(pos, offset)))
                        return -EFAULT;
                return ret;
        }
        
        return do_sendfile(out_fd, in_fd, NULL, count, 0);
}

This implementation is smaller and more efficient than the common one.

Same for compat_sys_sendfile64, although I don't think there is ever
a case where loff_t is defined differently from compat_loff_t, so
you can probably just use the native sys_sendfile64 for the compat
case.

>  
> +#ifdef __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
> +asmlinkage int compat_sys_sched_rr_get_interval(compat_pid_t pid,
> +                                               struct compat_timespec __user *interval)
> +{
> +       struct timespec t;
> +       int ret;
> +       mm_segment_t old_fs = get_fs();
> +
> +       set_fs(KERNEL_DS);
> +       ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
> +       set_fs(old_fs);
> +       if (put_compat_timespec(&t, interval))
> +               return -EFAULT;
> +       return ret;
> +}
> +#endif /* __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL */
> +

This one looks reasonable. It would be nice to kill the get_fs/set_fs but here
it would just make the native code slower or duplicate a lot of it.

Acked-by: Arnd Bergmann <arnd@arndb.de>
