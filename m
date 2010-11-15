Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab0KOTIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:08:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53489 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab0KOTI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:08:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oM/xb6Tf6SumTN1oK65e7u9FdWYLm21c+PcfdIaiTZl0j4JUEQScXMTmSxNv0cNkpv
         8D87QmJLrSRHrDXU/Vi0fXO7125cKf38DaVuBzZq+U/VKXCGCBvhwrYkvIAoAVwN4qVc
         SNajA/yTn1DNxlU1ztGeDiKPZ2zGP7OG49DeM=
MIME-Version: 1.0
In-Reply-To: <201011151057.38704.tvrtko.ursulin@sophos.com>
References: <20101115004134.9618.6393.stgit@zaytsev.su>
	<201011151057.38704.tvrtko.ursulin@sophos.com>
Date: Mon, 15 Nov 2010 22:08:25 +0300
Message-ID: <AANLkTinOL_cqex1WUkMYDYAKirs7Ps2oS_nsKnkePysM@mail.gmail.com>
Subject: Re: [PATCH] [RFC] fsnotify: Tell the user what part of the file might
 have changed
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Eric Paris <eparis@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 13:57, Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
>
> Hi Pete,

Hi, Vladislav. ;)

>
> On Monday 15 Nov 2010 00:44:08 Alexey Zaytsev wrote:
>> The patch adds fschange-like [1] modification ranges to
>> fsnotify events. Fanotify is made to pass the range
>> to the users.
>>
>> This is useful for backup programs that work on huge files,
>> so that only a part of a modified file needs to be scanned
>> for changes.
>>
>> Looking forwar for your coments on the approach.
>
> Looks like a potentially useful feature. For now just some implementation
> comments below.
>
>>  /*
>>   * Get an fsnotify notification event if one exists and is small
>>   * enough to fit in "count". Return an error pointer if the count
>> @@ -113,12 +133,20 @@ static ssize_t fill_event_metadata(struct
>> fsnotify_group *group, pr_debug("%s: group=%p metadata=%p event=%p\n",
>> __func__,
>>                  group, metadata, event);
>>
>> -       metadata->event_len = FAN_EVENT_METADATA_LEN;
>> +       if (event->mask & (FS_MODIFY | FS_CLOSE_WRITE)) {
>> +               metadata->event_len = FAN_RANGE_EVENT_METADATA_LEN;
>> +               metadata->range.start = event->range.start;
>> +               metadata->range.end = event->range.end;
>> +       } else {
>> +               metadata->event_len = FAN_EVENT_METADATA_LEN;
>> +       }
>> +
>>         metadata->vers = FANOTIFY_METADATA_VERSION;
>>         metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
>>         metadata->pid = pid_vnr(event->tgid);
>>         metadata->fd = create_fd(group, event);
>>
>> +
>>         return metadata->fd;
>>  }
>
> Since existence of range metadata is determined by fsnotify it would be nice
> if fanotify had no knowledge of when it will be present but could just check
> for its presence. But I do not feel that strongly about this. Especially since
> more important issue is the packet protocol. More on that later.

Not sure I get what you mean here. The range is used with two events.
For mofidy, it's the range of the last write, and for close_write it
accumulates the changes. Does not work well if you only modify the
beginning and the end of the file, but if should work well enough for
the majority of writes, which I assume are contiguous, and you can
still get the exact changes by listening to the modify events.

>> diff --git a/fs/open.c b/fs/open.c
>> index 4197b9e..b3c5b0a 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -675,6 +675,8 @@ static struct file *__dentry_open(struct dentry
>> *dentry, struct vfsmount *mnt, f->f_path.mnt = mnt;
>>         f->f_pos = 0;
>>         f->f_op = fops_get(inode->i_fop);
>> +       f->f_whatchanged.start = -1;
>> +       f->f_whatchanged.end = 0;
>>         file_sb_list_add(f, inode->i_sb);
>
> #ifdef CONFIG_FSNOTIFY?

Yep.

>
>> diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
>> index 0f01214..a599517 100644
>> --- a/include/linux/fanotify.h
>> +++ b/include/linux/fanotify.h
>> @@ -91,6 +91,14 @@ struct fanotify_event_metadata {
>>         __aligned_u64 mask;
>>         __s32 fd;
>>         __s32 pid;
>> +
>> +       /* Optional. Check event_len.*/
>> +       union {
>> +               struct {
>> +                       __aligned_u64 start;
>> +                       __aligned_u64 end;
>> +               } range;
>> +       };
>>  };
>
> This does not look extensible. Imagine you add another optional data to the
> union which has the same size - how would one distinguish between the two?
>
> I think the original idea for protocol extensibility was to use the version
> field. Optional sub-packets were not considered, but if we now want to add
> them we should do it right. For example more than one optional data packet
> could also be something which appears in the future.
>
> But for this particular feature, maybe you could get away with bumping the
> protocol version and always carrying the range fields? Just as long they are
> sanely initialized if not applicable it could be fine.

Not sure here. The range takes up 128 bytes, which almost doubles the
event size. And it's only applicable to the modify and close_write
events. Optional may be not the right term, but the point is, the
fields are present for the two events, and not for the others.

Maybe, the union should contain per-events structures, like

union {
        struct modity {
                __u64 start;
                __u64 end;
        };
        struct close_write {
                __u64 start;
                __u64 end;
               something else here in the future;
       };
       struct some_other_event {
                other event's stuff;
       }
};

so we could extend it further, maintaining the compatibility?

> Also you would need to document what is end. Is it the last modified offset or
> one after? Looks to be the latter in the current implementation.

Yep. If you write 100 bytes at 0, the end is going to be 100. Not sure
which is better.

>> +/* fsnotify wants to know, what has been changed during the file's
>> lifetime. */ +struct fsnotify_range {
>> +       loff_t start;
>> +       loff_t end;
>> +};
>
> Again end needs to be documented.
>
>> +static inline void fsnotify_update_range(struct file *f, loff_t orig_fpos,
>> size_t len) +{
>> +       /* -1 => first modification. */
>> +       if (f->f_whatchanged.start == -1)
>
> Could you somehow get rid of this conditional?
>
> On close you can pass -1 as u64 to userspace anyway so maybe min with unsigned
> values would work?

That's not the point. If start would be initialized with 0,
min(orig_fpos, f->f_whatchanged.start) would always yield 0. Currently
the user gets -1 if write_close happened without any actual
modifications.

>> +               f->f_whatchanged.start = orig_fpos;
>> +       else
>> +               f->f_whatchanged.start = min(orig_fpos,
>> f->f_whatchanged.start); +
>> +       f->f_whatchanged.end = max(orig_fpos + len,
>> f->f_whatchanged.start); +}
>> +
>
> Max with start or end here?
Thanks, end of course.
