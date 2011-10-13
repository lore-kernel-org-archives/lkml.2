Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1JMN1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:27:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39037 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab1JMN1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:27:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAE8kqZKQrDK4SAKc8vK7Wi46dGQBw6_LX2NFvkr-XZr_KmGhrQ@mail.gmail.com>
References: <CAE8kqZKQrDK4SAKc8vK7Wi46dGQBw6_LX2NFvkr-XZr_KmGhrQ@mail.gmail.com>
Date: Thu, 13 Oct 2011 21:27:51 +0800
Message-ID: <CAE8kqZJkmWzNtvYiqoFH3j9qRo2PTo58MtVON5try9vjLNsQ_Q@mail.gmail.com>
Subject: Re: [PATCH] fanotify: to differ file access event from different threads
From: boyd yang <boyd.yang@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: eparis@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anybody review my patch and integrate into kernel?


On Thu, Oct 13, 2011 at 4:56 PM, boyd yang <boyd.yang@gmail.com> wrote:
> This patch fixes a hang problem of Eric Paris's fs Notification/fanotify.
>
> Fanotify brings a way to intercept file access events.
> When multiple threadsiterate the same direcotry, some thread will hang.
> This patch let fanotify to differ access events from different
> threads, prevent fanotify from merging access events from different
> threads.
>
> =============================================================
>
> diff -r -u linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c
> linux-3.1-rc4/fs/notify/fanotify/fanotify.c
> --- linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c    2011-08-29
> 12:16:01.000000000 +0800
> +++ linux-3.1-rc4/fs/notify/fanotify/fanotify.c 2011-10-10
> 12:28:23.276847000 +0800
> @@ -15,7 +15,8 @@
>
>        if (old->to_tell == new->to_tell &&
>            old->data_type == new->data_type &&
> -           old->tgid == new->tgid) {
> +           old->tgid == new->tgid &&
> +           old->pid == new->pid) {
>                switch (old->data_type) {
>                case (FSNOTIFY_EVENT_PATH):
>                        if ((old->path.mnt == new->path.mnt) &&
> @@ -144,11 +145,19 @@
>                return PTR_ERR(notify_event);
>
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> -       if (event->mask & FAN_ALL_PERM_EVENTS) {
> -               /* if we merged we need to wait on the new event */
> -               if (notify_event)
> -                       event = notify_event;
> -               ret = fanotify_get_response_from_access(group, event);
> +       //if overflow, do not wait for response
> +       if(fsnotify_isoverflow(event))
> +       {
> +               pr_debug("fanotify overflow!\n");
> +       }
> +       else
> +       {
> +               if (event->mask & FAN_ALL_PERM_EVENTS) {
> +                       /* if we merged we need to wait on the new event */
> +                       if (notify_event)
> +                               event = notify_event;
> +                       ret = fanotify_get_response_from_access(group, event);
> +               }
>        }
>  #endif
>
> diff -r -u linux-3.1-rc4_orig/fs/notify/notification.c
> linux-3.1-rc4/fs/notify/notification.c
> --- linux-3.1-rc4_orig/fs/notify/notification.c 2011-08-29
> 12:16:01.000000000 +0800
> +++ linux-3.1-rc4/fs/notify/notification.c      2011-10-10 12:27:09.331787000 +0800
> @@ -95,6 +95,7 @@
>                BUG_ON(!list_empty(&event->private_data_list));
>
>                kfree(event->file_name);
> +               put_pid(event->pid);
>                put_pid(event->tgid);
>                kmem_cache_free(fsnotify_event_cachep, event);
>        }
> @@ -132,6 +133,14 @@
>        return priv;
>  }
>
> +bool fsnotify_isoverflow(struct fsnotify_event *event)
> +{
> +       if(event==q_overflow_event)
> +       {
> +               return true;
> +       }
> +       return false;
> +}
>  /*
>  * Add an event to the group notification queue.  The group can later pull this
>  * event off the queue to deal with.  If the event is successfully added to the
> @@ -374,6 +383,7 @@
>                        return NULL;
>                }
>        }
> +       event->pid = get_pid(old_event->pid);
>        event->tgid = get_pid(old_event->tgid);
>        if (event->data_type == FSNOTIFY_EVENT_PATH)
>                path_get(&event->path);
> @@ -417,6 +427,7 @@
>                event->name_len = strlen(event->file_name);
>        }
>
> +       event->pid = get_pid(task_pid(current));
>        event->tgid = get_pid(task_tgid(current));
>        event->sync_cookie = cookie;
>        event->to_tell = to_tell;
> diff -r -u linux-3.1-rc4_orig/include/linux/fsnotify_backend.h
> linux-3.1-rc4/include/linux/fsnotify_backend.h
> --- linux-3.1-rc4_orig/include/linux/fsnotify_backend.h 2011-08-29
> 12:16:01.000000000 +0800
> +++ linux-3.1-rc4/include/linux/fsnotify_backend.h      2011-10-10
> 12:27:48.587369000 +0800
> @@ -238,6 +238,7 @@
>        u32 sync_cookie;        /* used to corrolate events, namely inotify mv events */
>        const unsigned char *file_name;
>        size_t name_len;
> +       struct pid *pid;
>        struct pid *tgid;
>
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> @@ -378,6 +379,8 @@
>                                                        struct fsnotify_event_private_data *priv,
>                                                        struct fsnotify_event *(*merge)(struct list_head *,
>                                                                                        struct fsnotify_event *));
> +/*true if the event is an overflow event*/
> +extern bool fsnotify_isoverflow(struct fsnotify_event *event);
>  /* true if the group notification queue is empty */
>  extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
>  /* return, but do not dequeue the first event on the notification queue */
>
