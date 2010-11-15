Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab0KOK5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:57:42 -0500
Received: from mx5.sophos.com ([213.31.172.35]:55706 "EHLO mx5.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab0KOK5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:57:40 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Subject: Re: [PATCH] [RFC] fsnotify: Tell the user what part of the file might have changed
Date: Mon, 15 Nov 2010 10:57:38 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.3; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20101115004134.9618.6393.stgit@zaytsev.su>
In-Reply-To: <20101115004134.9618.6393.stgit@zaytsev.su>
MIME-Version: 1.0
Message-ID: <201011151057.38704.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 15/11/2010 10:57:39,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 15/11/2010 10:57:39,
	Serialize complete at 15/11/2010 10:57:39
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Pete,

On Monday 15 Nov 2010 00:44:08 Alexey Zaytsev wrote:
> The patch adds fschange-like [1] modification ranges to
> fsnotify events. Fanotify is made to pass the range
> to the users.
>
> This is useful for backup programs that work on huge files,
> so that only a part of a modified file needs to be scanned
> for changes.
>
> Looking forwar for your coments on the approach.

Looks like a potentially useful feature. For now just some implementation
comments below.

>  /*
>   * Get an fsnotify notification event if one exists and is small
>   * enough to fit in "count". Return an error pointer if the count
> @@ -113,12 +133,20 @@ static ssize_t fill_event_metadata(struct
> fsnotify_group *group, pr_debug("%s: group=%p metadata=%p event=%p\n",
> __func__,
>                  group, metadata, event);
>
> -       metadata->event_len = FAN_EVENT_METADATA_LEN;
> +       if (event->mask & (FS_MODIFY | FS_CLOSE_WRITE)) {
> +               metadata->event_len = FAN_RANGE_EVENT_METADATA_LEN;
> +               metadata->range.start = event->range.start;
> +               metadata->range.end = event->range.end;
> +       } else {
> +               metadata->event_len = FAN_EVENT_METADATA_LEN;
> +       }
> +
>         metadata->vers = FANOTIFY_METADATA_VERSION;
>         metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
>         metadata->pid = pid_vnr(event->tgid);
>         metadata->fd = create_fd(group, event);
>
> +
>         return metadata->fd;
>  }

Since existence of range metadata is determined by fsnotify it would be nice
if fanotify had no knowledge of when it will be present but could just check
for its presence. But I do not feel that strongly about this. Especially since
more important issue is the packet protocol. More on that later.

> diff --git a/fs/open.c b/fs/open.c
> index 4197b9e..b3c5b0a 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -675,6 +675,8 @@ static struct file *__dentry_open(struct dentry
> *dentry, struct vfsmount *mnt, f->f_path.mnt = mnt;
>         f->f_pos = 0;
>         f->f_op = fops_get(inode->i_fop);
> +       f->f_whatchanged.start = -1;
> +       f->f_whatchanged.end = 0;
>         file_sb_list_add(f, inode->i_sb);

#ifdef CONFIG_FSNOTIFY?

> diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
> index 0f01214..a599517 100644
> --- a/include/linux/fanotify.h
> +++ b/include/linux/fanotify.h
> @@ -91,6 +91,14 @@ struct fanotify_event_metadata {
>         __aligned_u64 mask;
>         __s32 fd;
>         __s32 pid;
> +
> +       /* Optional. Check event_len.*/
> +       union {
> +               struct {
> +                       __aligned_u64 start;
> +                       __aligned_u64 end;
> +               } range;
> +       };
>  };

This does not look extensible. Imagine you add another optional data to the
union which has the same size - how would one distinguish between the two?

I think the original idea for protocol extensibility was to use the version
field. Optional sub-packets were not considered, but if we now want to add
them we should do it right. For example more than one optional data packet
could also be something which appears in the future.

But for this particular feature, maybe you could get away with bumping the
protocol version and always carrying the range fields? Just as long they are
sanely initialized if not applicable it could be fine.

Also you would need to document what is end. Is it the last modified offset or
one after? Looks to be the latter in the current implementation.

> +/* fsnotify wants to know, what has been changed during the file's
> lifetime. */ +struct fsnotify_range {
> +       loff_t start;
> +       loff_t end;
> +};

Again end needs to be documented.

> +static inline void fsnotify_update_range(struct file *f, loff_t orig_fpos,
> size_t len) +{
> +       /* -1 => first modification. */
> +       if (f->f_whatchanged.start == -1)

Could you somehow get rid of this conditional?

On close you can pass -1 as u64 to userspace anyway so maybe min with unsigned
values would work?

> +               f->f_whatchanged.start = orig_fpos;
> +       else
> +               f->f_whatchanged.start = min(orig_fpos,
> f->f_whatchanged.start); +
> +       f->f_whatchanged.end = max(orig_fpos + len,
> f->f_whatchanged.start); +}
> +

Max with start or end here?

Tvrtko

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
