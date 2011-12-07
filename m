Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab1LGXD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:03:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38348 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1LGXDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <1323225914-23985-1-git-send-email-msb@chromium.org>
References: <1323225914-23985-1-git-send-email-msb@chromium.org>
Date: Wed, 7 Dec 2011 15:03:24 -0800
X-Google-Sender-Auth: E0zWb0gv5V3JF-tA5RbpIXbZEDQ
Message-ID: <CAGXu5j+Epkypk-AKi0QWrKewW9BX8k8xaW0bkPb82mHnYVECtw@mail.gmail.com>
Subject: Re: [PATCH] sys_getppid: add missing rcu_dereference
From: Kees Cook <keescook@chromium.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 6:45 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> In order to safely dereference current->real_parent inside an
> rcu_read_lock, we need an rcu_dereference.
>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Pavel Emelyanov <xemul@openvz.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kees Cook <keescook@chromium.org>
> ---
>  kernel/timer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index dbaa624..9c3c62b 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1368,7 +1368,7 @@ SYSCALL_DEFINE0(getppid)
>        int pid;
>
>        rcu_read_lock();
> -       pid = task_tgid_vnr(current->real_parent);
> +       pid = task_tgid_vnr(rcu_dereference(current->real_parent));
>        rcu_read_unlock();
>
>        return pid;

Should parent and real_parent also be marked in sched.h with __rcu so
sparse can find other missing rcu_dereference()s? And if not, why?
(tasklist lock?)

I think I see at least are few other users (security/apparmor/audit.c,
security/tomoyo/common.h, kernel/sched.c) that need rcu_dereference()
when accessing real_parent, there are probably more.

-Kees

-- 
Kees Cook
ChromeOS Security
