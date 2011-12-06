Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab1LFBYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:24:48 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40363 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab1LFBYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:24:47 -0500
MIME-Version: 1.0
In-Reply-To: <20111124145822.GC22640@quack.suse.cz>
References: <CAE8kqZKQrDK4SAKc8vK7Wi46dGQBw6_LX2NFvkr-XZr_KmGhrQ@mail.gmail.com>
	<20111013133815.GC2310@localhost.localdomain>
	<CAE8kqZJGxra_tX=x-BQhnwKBDAhHLYq04Xon47coQ5JR5+0YmQ@mail.gmail.com>
	<CAE8kqZ+GV3CoxWMV=4GXgc6YYCcnAk_jnBxzwRubgccZL8VstA@mail.gmail.com>
	<20111124145822.GC22640@quack.suse.cz>
Date: Tue, 6 Dec 2011 09:24:45 +0800
Message-ID: <CAE8kqZJYQoffVPgWCXLxcWY9a4ruz-n8vVBnrqryPKY+wcH29Q@mail.gmail.com>
Subject: Re: [PATCH] fanotify: to differ file access event from different threads
From: boyd yang <boyd.yang@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, eparis@redhat.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jan Karan!
I once thought it was buried.
Now I have resent the patch.

On Thu, Nov 24, 2011 at 10:58 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 17-11-11 18:21:26, boyd yang wrote:
>> How can this patch get merged?
>> Who is responsible for this?
>  Eric Paris is responsible for merging this patch. I see you have CCed him
> so that should be OK. Can you maybe resend the patch in a separate email
> again? I see your last submission was included in a reply to email together
> with other text etc. which makes merging it using our standard tools
> harder...
>
>                                                                Honza
>
>> We are developing some real-time antivirus software, the fanotify can make
>> it work without dirver/kenel-modues( like RedirFS).
>> But the bug costs a lot trouble.
>> If we used the patch, our software works great!
>>
>> I think other antivirus or file-motoring softwares are influnced by the bug
>> too.
>>
>>
>> On Fri, Oct 14, 2011 at 2:56 PM, boyd yang <boyd.yang@gmail.com> wrote:
>> >
>> > Thanks, I updated the patch.
>> > Now it passed checkpatch.pl.
>> >
>> > I used the flag you mentioned.
>> >
>> > fanotify: to differ file access event from different threads
>> > When fanotify is monitoring the whole mount point "/", and multiple
>> > threads iterate the same direcotry, some thread will hang.
>> > This patch let fanotify to differ access events from different
>> > threads, prevent fanotify from merging access events from different
>> > threads.
>> > It also hide overflow events to reach user space.
>> > Signed-off-by: Boyd Yang <boyd.yang@gmail.com>
>> >
>> > diff -r -u linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c
>> > linux-3.1-rc4/fs/notify/fanotify/fanotify.c
>> > --- linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c    2011-08-29
>> > 12:16:01.000000000 +0800
>> > +++ linux-3.1-rc4/fs/notify/fanotify/fanotify.c 2011-10-14
>> > 14:17:53.055958000 +0800
>> > @@ -15,7 +15,8 @@
>> >
>> >        if (old->to_tell == new->to_tell &&
>> >            old->data_type == new->data_type &&
>> > -           old->tgid == new->tgid) {
>> > +           old->tgid == new->tgid &&
>> > +           old->pid == new->pid) {
>> >                switch (old->data_type) {
>> >                case (FSNOTIFY_EVENT_PATH):
>> >                        if ((old->path.mnt == new->path.mnt) &&
>> > @@ -144,11 +145,16 @@
>> >                return PTR_ERR(notify_event);
>> >
>> >  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
>> > -       if (event->mask & FAN_ALL_PERM_EVENTS) {
>> > -               /* if we merged we need to wait on the new event */
>> > -               if (notify_event)
>> > -                       event = notify_event;
>> > -               ret = fanotify_get_response_from_access(group, event);
>> > +       /*if overflow, do not wait for response*/
>> > +       if (event->mask&FS_Q_OVERFLOW) {
>> > +               pr_debug("fanotify overflow!\n");
>> > +       }       else {
>> > +               if (event->mask & FAN_ALL_PERM_EVENTS) {
>> > +                       /* if we merged we need to wait on the new event */
>> > +                       if (notify_event)
>> > +                               event = notify_event;
>> > +                       ret = fanotify_get_response_from_access(group, event);
>> > +               }
>> >        }
>> >  #endif
>> >
>> > diff -r -u linux-3.1-rc4_orig/fs/notify/notification.c
>> > linux-3.1-rc4/fs/notify/notification.c
>> > --- linux-3.1-rc4_orig/fs/notify/notification.c 2011-08-29
>> > 12:16:01.000000000 +0800
>> > +++ linux-3.1-rc4/fs/notify/notification.c      2011-10-14 13:52:36.946608000 +0800
>> > @@ -95,6 +95,7 @@
>> >                BUG_ON(!list_empty(&event->private_data_list));
>> >
>> >                kfree(event->file_name);
>> > +               put_pid(event->pid);
>> >                put_pid(event->tgid);
>> >                kmem_cache_free(fsnotify_event_cachep, event);
>> >        }
>> > @@ -374,6 +375,7 @@
>> >                        return NULL;
>> >                }
>> >        }
>> > +       event->pid = get_pid(old_event->pid);
>> >        event->tgid = get_pid(old_event->tgid);
>> >        if (event->data_type == FSNOTIFY_EVENT_PATH)
>> >                path_get(&event->path);
>> > @@ -417,6 +419,7 @@
>> >                event->name_len = strlen(event->file_name);
>> >        }
>> >
>> > +       event->pid = get_pid(task_pid(current));
>> >        event->tgid = get_pid(task_tgid(current));
>> >        event->sync_cookie = cookie;
>> >        event->to_tell = to_tell;
>> > diff -r -u linux-3.1-rc4_orig/include/linux/fsnotify_backend.h
>> > linux-3.1-rc4/include/linux/fsnotify_backend.h
>> > --- linux-3.1-rc4_orig/include/linux/fsnotify_backend.h 2011-08-29
>> > 12:16:01.000000000 +0800
>> > +++ linux-3.1-rc4/include/linux/fsnotify_backend.h      2011-10-14
>> > 13:51:50.380168000 +0800
>> > @@ -238,6 +238,7 @@
>> >        u32 sync_cookie;        /* used to corrolate events, namely inotify mv events */
>> >        const unsigned char *file_name;
>> >        size_t name_len;
>> > +       struct pid *pid;
>> >        struct pid *tgid;
>> >
>> >  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
>> >
>> >
>> >
>> >
>> >
>> > On Thu, Oct 13, 2011 at 9:38 PM, Josef Bacik <josef@redhat.com> wrote:
>> > > On Thu, Oct 13, 2011 at 04:56:43PM +0800, boyd yang wrote:
>> > >> This patch fixes a hang problem of Eric Paris's fs Notification/fanotify.
>> > >>
>> > >> Fanotify brings a way to intercept file access events.
>> > >> When multiple threadsiterate the same direcotry, some thread will hang.
>> > >> This patch let fanotify to differ access events from different
>> > >> threads, prevent fanotify from merging access events from different
>> > >> threads.
>> > >>
>> > >
>> > > You need to run this through checkpatch.pl, you have a ton of formatting
>> > > problems.  Also your email client seems to have word-wrapped parts of this, so
>> > > use a email client that doesn't word wrap.
>> > >
>> > >> =============================================================
>> > >>
>> > >> diff -r -u linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c
>> > >> linux-3.1-rc4/fs/notify/fanotify/fanotify.c
>> > >> --- linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c  2011-08-29
>> > >> 12:16:01.000000000 +0800
>> > >> +++ linux-3.1-rc4/fs/notify/fanotify/fanotify.c       2011-10-10
>> > >> 12:28:23.276847000 +0800
>> > >> @@ -15,7 +15,8 @@
>> > >>
>> > >>       if (old->to_tell == new->to_tell &&
>> > >>           old->data_type == new->data_type &&
>> > >> -         old->tgid == new->tgid) {
>> > >> +         old->tgid == new->tgid &&
>> > >> +         old->pid == new->pid) {
>> > >>               switch (old->data_type) {
>> > >>               case (FSNOTIFY_EVENT_PATH):
>> > >>                       if ((old->path.mnt == new->path.mnt) &&
>> > >> @@ -144,11 +145,19 @@
>> > >>               return PTR_ERR(notify_event);
>> > >>
>> > >>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
>> > >> -     if (event->mask & FAN_ALL_PERM_EVENTS) {
>> > >> -             /* if we merged we need to wait on the new event */
>> > >> -             if (notify_event)
>> > >> -                     event = notify_event;
>> > >> -             ret = fanotify_get_response_from_access(group, event);
>> > >> +     //if overflow, do not wait for response
>> > >> +     if(fsnotify_isoverflow(event))
>> > >> +     {
>> > >> +             pr_debug("fanotify overflow!\n");
>> > >> +     }
>> > >> +     else
>> > >> +     {
>> > >> +             if (event->mask & FAN_ALL_PERM_EVENTS) {
>> > >> +                     /* if we merged we need to wait on the new event */
>> > >> +                     if (notify_event)
>> > >> +                             event = notify_event;
>> > >> +                     ret = fanotify_get_response_from_access(group, event);
>> > >> +             }
>> > >>       }
>> > >
>> > > The overflow event should only have FS_Q_OVERFLOW set in it's mask right?  So
>> > > why is this test needed at all?  Thanks,
>> > >
>> > > Josef
>> > >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
