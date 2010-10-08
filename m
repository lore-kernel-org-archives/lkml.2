Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0JHNBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:01:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab0JHNBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:01:14 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: Re: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of permission decisions
Date: Fri, 8 Oct 2010 15:00:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <201009071608.02290.tvrtko.ursulin@sophos.com> <201009080924.04841.tvrtko.ursulin@sophos.com>
In-Reply-To: <201009080924.04841.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010081500.40494.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko,

On Wednesday 08 September 2010 10:24:04 Tvrtko Ursulin wrote:
> 
> Improved version of the fix which does not include the check
> when permission events are not enabled in configuration and
> stops processing if no interesting events remain.
> 
> Current code ignores access replies to permission decisions so
> fix it in a way which will allow all listeners to still receive
> non permission events.

I agree with the patch (see comments below), but this explanation is close
to incomprehensible and not good as a commit message.

> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
> ---
>  fs/notify/fsnotify.c             |   32 ++++++++++++++++++++++++--------
>  include/linux/fsnotify_backend.h |    4 ++++
>  2 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
> index 3680242..2350a53 100644
> --- a/fs/notify/fsnotify.c
> +++ b/fs/notify/fsnotify.c
> @@ -224,7 +224,7 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
>         struct fsnotify_group *inode_group, *vfsmount_group;
>         struct fsnotify_event *event = NULL;
>         struct vfsmount *mnt;
> -       int idx, ret = 0;
> +       int idx, ret = 0, res;
>         /* global tests shouldn't care about events on child only the specific event */
>         __u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
> 
> @@ -275,20 +275,36 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
> 
>                 if (inode_group > vfsmount_group) {
>                         /* handle inode */
> -                       send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
> -                                     data_is, cookie, file_name, &event);
> +                       res = send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
> +                                           data_is, cookie, file_name, &event);
>                         /* we didn't use the vfsmount_mark */
>                         vfsmount_group = NULL;
>                 } else if (vfsmount_group > inode_group) {
> -                       send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
> -                                     data_is, cookie, file_name, &event);
> +                       res = send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
> +                                           data_is, cookie, file_name, &event);
>                         inode_group = NULL;
>                 } else {
> -                       send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
> -                                     mask, data, data_is, cookie, file_name,
> -                                     &event);
> +                       res = send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
> +                                           mask, data, data_is, cookie, file_name,
> +                                           &event);
>                 }
> 
> +#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> +               /* If a listener denied on a permission event we will remember the reason
> +                  and run the rest with a non-permission mask only. This allows other
> +                  listeners to receive non-permission notifications but we do not care
> +                  about further permission checks and want to deny this event. */
> +               if (unlikely((res == -EPERM) && (mask & FS_ALL_PERM_EVENTS))) {

We should probably stop processing here whenever res != 0, for any mask. (The
fanotify and inotify handle_event callbacks can return -ENOMEM right now, but
this doesn't seem very useful and should probably be fixed: fsnotify has no
way of doing anything about -ENOMEM.

> +                       mask &= ~FS_ALL_PERM_EVENTS;
> +                       ret = res;
> +                       /* Stop processing if no interesting events remains. */
> +                       if (!(mask & (ALL_FSNOTIFY_EVENTS & ~FS_EVENT_ON_CHILD)))
> +                               break;
> +               }
> +#else
> +               (void)res;
> +#endif
> +
>                 if (inode_group)
>                         inode_node = srcu_dereference(inode_node->next,
>                                                       &fsnotify_mark_srcu);
> diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
> index e40190d..c8aea03 100644
> --- a/include/linux/fsnotify_backend.h
> +++ b/include/linux/fsnotify_backend.h
> @@ -64,6 +64,10 @@
> 
>  #define FS_MOVE                        (FS_MOVED_FROM | FS_MOVED_TO)
> 
> +/* All events which require a permission response from userspace */
> +#define FS_ALL_PERM_EVENTS (FS_OPEN_PERM |\
> +                           FS_ACCESS_PERM)

When dealing with the result of ->handle_event as I propose, this definition
isn't needed.

Thanks,
Andreas
