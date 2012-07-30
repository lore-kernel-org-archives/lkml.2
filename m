Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2G3RAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:00:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40075 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2G3RAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:00:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120726154144.GA20964@redhat.com>
References: <20120726134748.GA20605@localhost>
	<20120726154144.GA20964@redhat.com>
Date: Mon, 30 Jul 2012 10:00:00 -0700
X-Google-Sender-Auth: fNvJrYCq5_bVXbKDiezjCi2cEIQ
Message-ID: <CAGXu5jKEtJ-ySq-PgU7hvzVgnQrJ91pxSALCoMpqJigeNmRzLg@mail.gmail.com>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 8:41 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/26, Fengguang Wu wrote:
>>
>> Here is a recursive lock possibility:
>>
>>         ptrace_may_access()
>> =>        task_lock(task);
>>             yama_ptrace_access_check()
>>               get_task_comm()
>> =>              task_lock(task);
>
> I think yama_ptrace_access_check() can simply use ->comm
>
> Oleg.
>
> --- x/security/yama/yama_lsm.c
> +++ x/security/yama/yama_lsm.c
> @@ -279,12 +279,9 @@ static int yama_ptrace_access_check(stru
>         }
>
>         if (rc) {
> -               char name[sizeof(current->comm)];
>                 printk_ratelimited(KERN_NOTICE
>                         "ptrace of pid %d was attempted by: %s (pid %d)\n",
> -                       child->pid,
> -                       get_task_comm(name, current),
> -                       current->pid);
> +                       child->pid, current->comm, current->pid);
>         }
>
>         return rc;
>

Great catch, thanks! I've sent Oleg's suggestion (with an added
comment) separately.

-Kees

-- 
Kees Cook
Chrome OS Security
