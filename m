Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab2CHTcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:32:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47414 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2CHTb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:31:59 -0500
MIME-Version: 1.0
In-Reply-To: <20120308165112.GF21812@moon>
References: <20120308165112.GF21812@moon>
Date: Thu, 8 Mar 2012 11:31:58 -0800
X-Google-Sender-Auth: JwVDYTLNZ3yLlYea47TRKI-uJlo
Message-ID: <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 8:51 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> When we do restore we would like to have a way to setup
> a former mm_struct::exe_file so that /proc/pid/exe would
> point to the original executable file a process had at
> checkpoint time.
>
> For this the PR_SET_MM_EXE_FILE code is introduced.
> This option takes a file descriptor which will be
> set as new /proc/$pid/exe symlink.
>
> This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.
> [...]
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> [...]
> +       exe_file = fget(fd);
> +       if (!exe_file)
> +               return -EBADF;
> +
> +       dentry = exe_file->f_path.dentry;
> +
> +       /*
> +        * Because the original mm->exe_file
> +        * points to executable file, make sure
> +        * this one is executable as well to not
> +        * break "big" picture and proc/pid/exe
> +        * symlink will be still pointing to
> +        * executable one.
> +        */
> +       err = -EACCES;
> +       if (!S_ISREG(dentry->d_inode->i_mode)   ||
> +           exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> +               goto exit;

I'm starting to notice that this pattern (testing ISREG and
MNT_NOEXEC) is getting repeated a few times in the kernel, and at
least the no-new-privs patch (not yet in -mm but hopefully soon given
the seccomp_filter work) updates this pattern everywhere. Perhaps this
should be extracted into a helper first, and then this patch can call
that helper here? (And then nnp can just update the single helper.)

-Kees

-- 
Kees Cook
ChromeOS Security
