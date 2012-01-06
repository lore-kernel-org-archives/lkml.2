Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab2AFSoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:44:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40105 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab2AFSo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:44:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120106012120.32c3f370.akpm@linux-foundation.org>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105091704.GB3249@elte.hu>
	<CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
	<20120106073635.GC14188@elte.hu>
	<20120106012120.32c3f370.akpm@linux-foundation.org>
Date: Fri, 6 Jan 2012 10:44:26 -0800
X-Google-Sender-Auth: RhS6uaIM9hAALTgsBXFQ36L6oFE
Message-ID: <CAGXu5j+HX5bO-_uxna4gUZJG2dY-yxJ2dgwAvooGSWUzJr-LHQ@mail.gmail.com>
Subject: Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 1:21 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 6 Jan 2012 08:36:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>> * Kees Cook <keescook@chromium.org> wrote:
>> > On Thu, Jan 5, 2012 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> > > * Kees Cook <keescook@chromium.org> wrote:
>> > >
>> > >> @@ -1495,6 +1496,15 @@ static struct ctl_table fs_table[] = {
>> > >>  #endif
>> > >>  #endif
>> > >>       {
>> > >> +             .procname       = "protected_sticky_symlinks",
>> > >> +             .data           = &protected_sticky_symlinks,
>> > >> +             .maxlen         = sizeof(int),
>> > >> +             .mode           = 0644,
>> > >> +             .proc_handler   = proc_dointvec_minmax,
>> > >> +             .extra1         = &zero,
>> > >> +             .extra2         = &one,
>> > >> +     },
>> > >
>> > > Small detail:
>> > >
>> > > Might make sense to change the .mode to 0600, to make it
>> > > harder for unprivileged attack code to guess whether this
>> > > protection (and the resulting audit warning to the
>> > > administrator) is enabled on a system or not.
>> >
>> > Sure, I have no problem with that. In addition to this change,
>> > what's the best next step for this patch?
>>
>> Al and Linus's call I guess. Maybe ask Andrew whether he'd put
>> it into -mm?
>
> Sure, I can babysit it for Viro and get it a bit of testing meanwhile.

That would be wonderful. :)

> However, you've now made me go and look at it...
>
> On Wed, 4 Jan 2012 12:18:00 -0800 Kees Cook <keescook@chromium.org> wrote:
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 5008f01..b826d2e 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -624,10 +624,80 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
>>       path_put(link);
>>  }
>>
>> +int protected_sticky_symlinks  read_mostly =
>
> A nice convention is to prefix these globals with sysctl_.
>
>        grep ".data.*&sysctl_" kernel/sysctl.c
>
> has examples.

Excellent point, thanks. I will fix this.

>> +/**
>> + * may_follow_link - Check symlink following for unsafe situations
>> + * @dentry: The inode/dentry of the symlink
>> + * @nameidata: The path data of the symlink
>> + *
>> + * In the case of the protected_sticky_symlinks sysctl being enabled,
>> + * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
>> + * in a sticky world-writable directory. This is to protect privileged
>> + * processes from failing races against path names that may change out
>> + * from under them by way of other users creating malicious symlinks.
>> + * It will permit symlinks to be followed only when outside a sticky
>> + * world-writable directory, or when the uid of the symlink and follower
>> + * match, or when the directory owner matches the symlink's owner.
>> + *
>> + * Returns 0 if following the symlink is allowed, -ve on error.
>> + */
>> +static inline int
>> +may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
>
> Setting aside the issue that gcc will cheerily ignore the inline
> directive, is it prudent to inline this?  Doing so will pork up the
> follow_link() cache footprint.  Perhaps it should actually be noinline?

Well, I was trying to balance a few potential issues. One thing to try
to avoid was slowing down symlink resolution. The first step was only
doing this check in the sensitive path, as Al had pointed out to me.
Since the code is relatively small, it seemed reasonable to inline it
where it was needed. If anyone has a strong opinion about this, it's
trivial for it to be changed.

>> +             ab = audit_log_start(current->audit_context,
>> +                                  GFP_KERNEL, AUDIT_AVC);
>> +             audit_log_format(ab, "op=follow_link action=denied");
>> +             audit_log_format(ab, " pid=%d comm=", current->pid);
>
> The same pid can exist in multiple namespaces.  Now whatcha gonna do?

Well, that's a wider problem that just this code. This style of report
is used in several other places. I'm open to suggestions.

>> +             audit_log_untrustedstring(ab, current->comm);
>> +             audit_log_d_path(ab, "path=", &nameidata->path);
>> +             audit_log_format(ab, " name=");
>> +             audit_log_untrustedstring(ab, dentry->d_name.name);
>> +             audit_log_format(ab, " dev=%s ino=%lu",
>> +                              inode->i_sb->s_id,
>
> Can s_id contain characters which audit_log_untrustedstring() would
> have escaped?  I suspect so.

Hunh. Interesting point. I will adjust this here and in the place I
originally saw it.

>> +                              inode->i_ino);
>> +             audit_log_end(ab);
>> +     }
>> +#endif
>> +     return error;
>> +}
>> +
>>  static  always_inline int
>> -follow_link(struct path *link, struct nameidata *nd, void **p)
>> +follow_link(struct path *link, struct nameidata *nd, void **p, bool sensitive)
>>  {
>> -     int error;
>> +     int error = 0;
>>       struct dentry *dentry = link->dentry;
>>
>>       BUG_ON(nd->flags & LOOKUP_RCU);
>> @@ -646,7 +716,10 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
>>       touch_atime(link->mnt, dentry);
>>       nd_set_link(nd, NULL);
>>
>> -     error = security_inode_follow_link(link->dentry, nd);
>> +     if (sensitive)
>> +             error = may_follow_link(link->dentry, nd);
>> +     if (!error)
>> +             error = security_inode_follow_link(link->dentry, nd);
>>       if (error) {
>>               *p = ERR_PTR(error); /* no ->put_link(), please */
>>               path_put(&nd->path);
>> @@ -1339,7 +1412,7 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
>>               struct path link = *path;
>>               void *cookie;
>>
>> -             res = follow_link(&link, nd, &cookie);
>> +             res = follow_link(&link, nd, &cookie, 0);
>
> follow_link() takes a bool, so this 0 should anally be "false".
> Multiple instances of this.

Ah yes, thanks. I will fix this.

Thanks for the review! I will post an update shortly.

-Kees

-- 
Kees Cook
ChromeOS Security
