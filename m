Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2F3OeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 10:34:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62249 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2F3OeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 10:34:04 -0400
MIME-Version: 1.0
In-Reply-To: <4FEEA5CB.8070809@huawei.com>
References: <4FEEA5CB.8070809@huawei.com>
Date: Sat, 30 Jun 2012 23:34:02 +0900
Message-ID: <CALLJCT3xMMi=CCjuE=KmWa9Xo9419zGSyWw-xufxF8_Hhy6_AQ@mail.gmail.com>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
From: Masanari Iida <standby24x7@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, shyju pv <shyju.pv@huawei.com>,
        Sanil kumar <sanil.kumar@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Apply the patch on top of 3.5-rc4, and confirmed
the symptom has fixed by your patch.
Thank you!

Tested-by: Masanari Iida <standby24x7@gmail.com>

Masanari

On Sat, Jun 30, 2012 at 4:07 PM, Li Zefan <lizefan@huawei.com> wrote:
> To avoid rmdir hang, now we won't drain css references at rmdir, but
> rmdir will proceed regardless of css refs. We still have to wait till
> all css refs have been released before destroying cgroup, and this is
> achieved by holding an extra dentry refcnt for each css, which leads to
> this bug:
>
> BUG: Dentry ffff8801164db490{i=491b,n=/} still in use (1) [unmount of cgroup cgroup]
> ------------[ cut here ]------------
> kernel BUG at fs/dcache.c:965!
> ...
> Call Trace:
>  [<ffffffff811ec19a>] shrink_dcache_for_umount+0x4a/0x90
>  [<ffffffff811cc3c7>] generic_shutdown_super+0x37/0x160
>  [<ffffffff811cc5d9>] kill_anon_super+0x19/0x40
>  [<ffffffff811cc63a>] kill_litter_super+0x3a/0x50
>  [<ffffffff810fb65a>] cgroup_kill_sb+0x20a/0x280
>  [<ffffffff811ccdc5>] deactivate_locked_super+0x65/0xb0
>  [<ffffffff811ce339>] deactivate_super+0x89/0xe0
>  [<ffffffff810f7734>] cgroup_d_release+0x34/0x40
>  [<ffffffff811eb258>] d_free+0x58/0xc0
>  [<ffffffff811ee5f0>] dput+0x220/0x350
>  [<ffffffff810f7429>] css_dput_fn+0x19/0x30
>  [<ffffffff8107b4d9>] process_one_work+0x239/0x800
>  [<ffffffff8107eba3>] worker_thread+0x2e3/0x710
>  [<ffffffff81087e46>] kthread+0xd6/0xf0
>
> If there's a css ref dangling after umount, when the ref goes down
> to 0, dput will drop the cgroup's dentry and then drop the root
> dentry. But kill_sb will be called inbetween, as dropping cgroup dentry
> unpinned sb, and now vfs will find the root dentry's refcnt is not 0.
>
> To fix this, we make css pin cgroup instead of cgroup dentry.
>
> Reported-by: Shyju P V <shyju.pv@huawei.com>
> Reported-by: Masanari Iida <standby24x7@gmail.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
