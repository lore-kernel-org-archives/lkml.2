Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690Ab2FVV3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:29:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2FVV3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:29:37 -0400
Date: Fri, 22 Jun 2012 14:29:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sadasivan Shaiju <sshaiju@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: crash in filesytem during reboot . (and proposed patch)
Message-Id: <20120622142936.a6e6b4d8.akpm@linux-foundation.org>
In-Reply-To: <797b2bac7e6fb198ea25433e302856b9@mail.gmail.com>
References: <797b2bac7e6fb198ea25433e302856b9@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 11:12:09 -0700
Sadasivan Shaiju <sshaiju@mvista.com> wrote:

> Hi
> 
> 
> 

Your email is quadruple-spaced.  Please, fix that.

> I  am  getting  the  following  crashes during  a  reboot of   the  system
> .  It  looks  like  a  race  condition   during  unmount .
> 
> <4>Call Trace:
> <4>[] clear_inode+0x28/0xe8
> <4>[] generic_drop_inode+0x3c/0xa8
> <4>[] d_kill+0x4c/0x78
> <4>[] __shrink_dcache_sb+0x258/0x360
> <4>[] shrink_dcache_parent+0x140/0x190
> <4>[] proc_flush_task+0xac/0x2e8
> <4>[] release_task+0x80/0x4c0
> <4>[] wait_consider_task+0x608/0xa80
> <4>[] do_wait+0x10c/0x2b8
> <4>[] SyS_wait4+0x88/0x120
> <4>[] compat_sys_wait4+0xc8/0xd0
> <4>[] handle_sysn32+0x44/0x84
> 
> Call Trace:
> [] file_ra_state_init+0x0/0x20
> [] __dentry_open+0x26c/0x3d0
> [] do_filp_open+0x70c/0xbc8
> [] do_sys_open+0x78/0x1e0
> [] handle_sysn32+0x44/0x84
> 
> Call Trace:
> [<ffffffff812ae3e4>] iput+0x3c/0x88
> [<ffffffff812aaa84>] d_kill+0x4c/0x78
> [<ffffffff812aad08>] __shrink_dcache_sb+0x258/0x360
> [<ffffffff812ab300>] shrink_dcache_parent+0x140/0x190
> [<ffffffff812eea14>] proc_flush_task+0xac/0x2e8
> [<ffffffff811e6538>] release_task+0x80/0x4c0
> [<ffffffff811e80c8>] do_exit+0x6f8/0x908
> [<ffffffff8121dee8>] unregister_module_notifier+0x0/0x10
> 
> Call Trace:
> [<ffffffff812ae3e4>] iput+0x3c/0x88
> [<ffffffff812aaa84>] d_kill+0x4c/0x78
> [<ffffffff812ab6b8>] dput+0x120/0x220
> [<ffffffff812a0f1c>] do_lookup+0xdc/0x210 [<ffffffff812a33e8>]
> __link_path_walk+0x910/0x1408 [<ffffffff812a4194>] path_walk+0x64/0x108
> [<ffffffff812a4350>] do_path_lookup+0x60/0x68 [<ffffffff812a519c>]
> do_filp_open+0xdc/0xbc8 [<ffffffff81293768>] do_sys_open+0x78/0x1e0
> [<ffffffff81103844>] handle_sysn32+0x44/0x84
> 
> ...
>
> I  am  thinking  of  putting  the  following  fix  in
>  shrink_dcache_parent() .   Please  let  me  know  is  there  any  problem
> with  this  fix .
>
> ...
> 
> --- linux-2.6.32.orig/fs/dcache.c       2012-05-30 15:59:18.000000000 -0700
> +++ linux-2.6.32/fs/dcache.c    2012-06-11 17:10:33.000000000 -0700
> @@ -881,8 +881,14 @@
>         struct super_block *sb = parent->d_sb;
>         int found;
> 
> -       while ((found = select_parent(parent)) != 0)
> -               __shrink_dcache_sb(sb, &found, 0);
> +       while ((found = select_parent(parent)) != 0) {
> +               if (down_read_trylock(&sb->s_umount)) {
> +                        if ((sb->s_root != NULL)) {
> +                               __shrink_dcache_sb(sb, &found, 0);
> +                }
> +                  up_read(&sb->s_umount);
> +             }
> +        }
>  }

Please fully describe the race which you believe you have found.  What
races against what?

Please also confirm that the bug is still present in current kernels -
2.6.32 is rather old.

Thanks.
