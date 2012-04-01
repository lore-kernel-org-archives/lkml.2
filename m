Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2DAReU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:34:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36836 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2DAReR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <201204011221.GAG51016.JQFSFFOtLOMVHO@I-love.SAKURA.ne.jp>
References: <CA+1xoqfA9FMowOmAXYHtkXB+D6FqgjCRREKPOk_m2c9ZCyaN4A@mail.gmail.com>
 <1333227549.2325.4051.camel@edumazet-glaptop> <20120331213423.GA21219@redhat.com>
 <CA+1xoqcAXyh306=2=QKWyM3BE44=MT+nsuRQn5YLOLgbtZqicA@mail.gmail.com>
 <CA+1xoqe1Wc_uifrKsko6hu+py9Ahz3Q0p1tRxup09jmh2NZ1rw@mail.gmail.com> <201204011221.GAG51016.JQFSFFOtLOMVHO@I-love.SAKURA.ne.jp>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 1 Apr 2012 19:33:56 +0200
Message-ID: <CA+1xoqe+T=iUtUeFdeqmRvMZ7TMCgkLs_1QYv-4YNtn-jCoMCQ@mail.gmail.com>
Subject: Re: ipv6: tunnel: hang when destroying ipv6 tunnel
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: oleg@redhat.com, eric.dumazet@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 5:21 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Sasha Levin wrote:
>> While it seems that 9p is the culprit, I have to point out that this
>> bug is easily reproducible, and it happens each time due to a
>> call_usermode_helper() call. Other than that 9p behaves perfectly and
>> I'd assume that I'd be seeing other things break besides
>> call_usermode_helper() related ones.
>
> I think one of below two patches can catch the bug if this is a usermodehelper
> related bug. Please try.
>
> ----- Patch 1 -----
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 01394b6..3e63319 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -571,7 +571,7 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
>         * flag, for khelper thread is already waiting for the thread at
>         * wait_for_completion() in do_fork().
>         */
> -       if (wait != UMH_NO_WAIT && current == kmod_thread_locker) {
> +       if (WARN_ON(wait != UMH_NO_WAIT && current == kmod_thread_locker)) {
>                retval = -EBUSY;
>                goto out;
>        }
>
>
> ----- Patch 2 -----
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index 9efeae6..1350670 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -48,10 +48,10 @@ static inline int request_module_nowait(const char *name, ...) { return -ENOSYS;
>  struct cred;
>  struct file;
>
> -#define UMH_NO_WAIT    0       /* don't wait at all */
> -#define UMH_WAIT_EXEC  1       /* wait for the exec, but not the process */
> -#define UMH_WAIT_PROC  2       /* wait for the process to complete */
> -#define UMH_KILLABLE   4       /* wait for EXEC/PROC killable */
> +#define UMH_NO_WAIT    0x10    /* don't wait at all */
> +#define UMH_WAIT_EXEC  0x11    /* wait for the exec, but not the process */
> +#define UMH_WAIT_PROC  0x12    /* wait for the process to complete */
> +#define UMH_KILLABLE   0x04    /* wait for EXEC/PROC killable */
>
>  struct subprocess_info {
>        struct work_struct work;
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 957a7aa..ecfd3d5 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -483,6 +483,18 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
>        DECLARE_COMPLETION_ONSTACK(done);
>        int retval = 0;
>
> +       if (unlikely(wait == -1 || wait == 0 || wait == 1)) {
> +               WARN(1, "Requesting for usermode helper with hardcoded wait "
> +                    "flag. Change to use UMH_* symbols and recompile, or "
> +                    "this request will fail on Linux 3.4.\n");
> +               if (wait == -1)
> +                       wait = UMH_NO_WAIT;
> +               else if (wait == 0)
> +                       wait = UMH_WAIT_EXEC;
> +               else
> +                       wait = UMH_WAIT_PROC;
> +       }
> +
>        helper_lock();
>        if (sub_info->path[0] == '\0')
>                goto out;

Neither of these patches did the trick (no warnings showing up and
still seeing the hangs). However, the following patch has fixed it:

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 1a91efa..8ecc377 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -309,7 +309,7 @@ int kobject_uevent_env(struct kobject *kobj, enum
kobject_action action,
                        goto exit;

                retval = call_usermodehelper(argv[0], argv,
-                                            env->envp, UMH_WAIT_EXEC);
+                                            env->envp, UMH_NO_WAIT);
        }

 exit:

Not sure if that info helps any, but just in case.
