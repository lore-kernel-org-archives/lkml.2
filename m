Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2BVQUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:20:39 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41968 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2BVQUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:20:36 -0500
MIME-Version: 1.0
In-Reply-To: <1329914744.2193.73.camel@perseus.themaw.net>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
 <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
 <1329889428.2193.45.camel@perseus.themaw.net> <1329890027.2193.48.camel@perseus.themaw.net>
 <1329890251.2193.50.camel@perseus.themaw.net> <1329903139.2193.66.camel@perseus.themaw.net>
 <1329912927.2193.68.camel@perseus.themaw.net> <1329914392.2193.71.camel@perseus.themaw.net>
 <1329914744.2193.73.camel@perseus.themaw.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 08:20:15 -0800
X-Google-Sender-Auth: daokr0uUF4yx0SONEUqtDmO71ec
Message-ID: <CA+55aFzGc7UmDK5OG7Vog0cQDuuP1MWmX1Xn=7Y+M_k+9+zHFg@mail.gmail.com>
Subject: Re: compat: autofs v5 packet size ambiguity - update
To: Ian Kent <raven@themaw.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 4:45 AM, Ian Kent <raven@themaw.net> wrote:
> diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> index 76741d8..85f1fcd 100644
> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -385,6 +385,7 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
>                sbi->pipefd = pipefd;
>                sbi->pipe = pipe;
>                sbi->catatonic = 0;
> +               sbi->compat_daemon = is_compat_task();
>        }
>  out:
>        mutex_unlock(&sbi->wq_mutex);

Yes, this part should do the reconnect correctly (assuming it's the
daemon that does that itself, but I assume it is).

But

> diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
> index e16980b..06858d9 100644
> --- a/fs/autofs4/inode.c
> +++ b/fs/autofs4/inode.c
> @@ -224,6 +225,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
>        set_autofs_type_indirect(&sbi->type);
>        sbi->min_proto = 0;
>        sbi->max_proto = 0;
> +       sbi->compat_daemon = is_compat_task();
>        mutex_init(&sbi->wq_mutex);
>        mutex_init(&sbi->pipe_mutex);
>        spin_lock_init(&sbi->fs_lock);

the above really is wrong, at least for the autofs sources I looked at.

Because autofs does "spawn()" to fork+exec the mount() system call,
the is_compat_task() check really will be checking the wrong binary.

Now, it's true that in *most* cases you'd hope that 'mount' and
'autofs' both come from the same distro, and have been the compiled
for the same model. So it probably works in practice, and might be
good enough.

But I could easily see somebody building their own 'autofs' tools (or
building their own 'mount', although that sounds less likely to me)
and if they started out with a 32-bit distro but are slowly  upgrading
(like they've upgraded the kernel) the above would get that wrong.

I could also imagine a 64-bit environment wanting to "cross" compile
(and test) a 32-bit binary, and trying that. In fact, I suspect that
is something that you could test yourself: I assume you build your own
'autofs' daemon on a system where you don't build everything else, and
just adding "-m32" to the build should do this and show the problem.

                           Linus
