Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2BUXXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:23:03 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41956 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690Ab2BUXXA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:23:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.182.47.37 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <20120221151057.a36bf2b2.akpm@linux-foundation.org>
References: <20120221215800.GA26721@www.outflux.net>
	<20120221151057.a36bf2b2.akpm@linux-foundation.org>
Date: Tue, 21 Feb 2012 15:22:57 -0800
X-Google-Sender-Auth: RR5xDzRIJ47m2mxd3ClG4KBOy2o
Message-ID: <CAGXu5j+xzLQVHqT4oEXxVi8r2j5OUG3LLZLkMM=JscNzjLmkOQ@mail.gmail.com>
Subject: Re: [PATCH v2] fs: hardlink creation restrictions
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 3:10 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 21 Feb 2012 13:58:00 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> On systems that have user-writable directories on the same partition
>> as system files, a long-standing class of security issues is the
>> hardlink-based time-of-check-time-of-use race, most commonly seen in
>> world-writable directories like /tmp. The common method of exploitation
>> of this flaw is to cross privilege boundaries when following a given
>> hardlink (i.e. a root process follows a hardlink created by another
>> user). Additionally, an issue exists where users can "pin" a potentially
>> vulnerable setuid/setgid file so that an administrator will not actually
>> upgrade a system fully.
>>
>> The solution is to permit hardlinks to only be created when the user is
>> already the existing file's owner, or if they already have read/write
>> access to the existing file.
>>
>> Many Linux users are surprised when they learn they can link to files
>> they have no access to, so this change appears to follow the doctrine
>> of "least surprise". Additionally, this change does not violate POSIX,
>> which states "the implementation may require that the calling process
>> has permission to access the existing file"[1].
>>
>> This change is known to break some implementations of the "at" daemon,
>> though the version used by Fedora and Ubuntu has been fixed[2] for
>> a while. Otherwise, the change has been undisruptive while in use in
>> Ubuntu for the last 1.5 years.
>>
>> This patch is based on the patch in Openwall and grsecurity.  I have
>> added a sysctl to enable the protected behavior, documentation, and an
>> audit notification.
>>
>> [1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/linkat.html
>> [2] http://anonscm.debian.org/gitweb/?p=collab-maint/at.git;a=commitdiff;h=f4114656c3a6c6f6070e315ffdf940a49eda3279
>>
>
> Looks OKish to me.

Thanks!

>> --- a/Documentation/sysctl/fs.txt
>> +++ b/Documentation/sysctl/fs.txt
>> @@ -32,7 +32,8 @@ Currently, these files are in /proc/sys/fs:
>>  - nr_open
>>  - overflowuid
>>  - overflowgid
>> -- protected_sticky_symlinks
>> +- protected_hardlinks
>> +- protected_symlinks
>
> It's silly to add protected_sticky_symlinks and to then rename it in
> the very next patch.  I have reworked my copy of the earlier
> fs-symlink-restrictions-on-sticky-directories.patch so that it adds
> "protected_symlinks".  I then reworked this patch
> (fs-hardlink-creation-restrictions.patch) to add protected_hardlinks.
> Nice and simple.

Okay, sounds good. Thanks for the clean-ups!

>>
>> ...
>>
>> +static inline void
>> +audit_log_link_denied(const char *operation, struct path *link)
>> +{
>> +     struct audit_buffer *ab;
>> +
>> +     ab = audit_log_start(current->audit_context, GFP_KERNEL, AUDIT_AVC);
>> +     audit_log_format(ab, "op=%s action=denied", operation);
>> +     audit_log_format(ab, " pid=%d comm=", current->pid);
>> +     audit_log_untrustedstring(ab, current->comm);
>> +     audit_log_d_path(ab, " path=", link);
>> +     audit_log_format(ab, " dev=");
>> +     audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_id);
>> +     audit_log_format(ab, " ino=%lu", link->dentry->d_inode->i_ino);
>> +     audit_log_end(ab);
>> +}
>
> This is far too large to inline.  It has two callsites and gcc is
> probably smart anough to uninline it for us.  I queued a patch to
> remove the `inline'.

Okay, seems fine to me.

>>  /**
>>   * may_follow_link - Check symlink following for unsafe situations
>> - * @dentry: The inode/dentry of the symlink
>> - * @nameidata: The path data of the symlink
>> + * @link: The path of the symlink
>>   *
>> - * In the case of the protected_sticky_symlinks sysctl being enabled,
>> + * In the case of the sysctl_protected_symlinks sysctl being enabled,
>>   * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
>>   * in a sticky world-writable directory. This is to protect privileged
>>   * processes from failing races against path names that may change out
>> @@ -643,19 +660,20 @@ int sysctl_protected_sticky_symlinks __read_mostly =
>>   *
>>   * Returns 0 if following the symlink is allowed, -ve on error.
>>   */
>> -static inline int
>> -may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
>> +static inline int may_follow_link(struct path *link)
>>  {
>>       int error = 0;
>>       const struct inode *parent;
>>       const struct inode *inode;
>>       const struct cred *cred;
>> +     struct dentry *dentry;
>>
>> -     if (!sysctl_protected_sticky_symlinks)
>> +     if (!sysctl_protected_symlinks)
>>               return 0;
>
> This is also too large to inline.  It doesn't matter a lot - it's not a
> hot path.  I removed this `inline' as well.  gcc will probably inline
> it anyway.
>
> If we were really concerned about speed here, we might decide to inline
> the test of sysctl_protected_symlinks and to uninline the remainder of
> the function.
>
>
>>       /* Allowed if owner and follower match. */
>>       cred = current_cred();
>> +     dentry = link->dentry;
>>       inode = dentry->d_inode;
>>       if (cred->fsuid == inode->i_uid)
>>               return 0;
>>
>> ...
>>
>> +static inline int may_linkat(struct path *link)
>> +{
>> +     int error = 0;
>> +     const struct cred *cred;
>> +     struct inode *inode;
>> +     int mode;
>> +
>> +     if (!sysctl_protected_hardlinks)
>> +             return 0;
>> +
>> +     cred = current_cred();
>> +     inode = link->dentry->d_inode;
>> +     mode = inode->i_mode;
>> +
>> +     if (cred->fsuid != inode->i_uid &&
>> +         (!S_ISREG(mode) || (mode & S_ISUID) ||
>> +          ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) ||
>> +          (inode_permission(inode, MAY_READ | MAY_WRITE))) &&
>> +         !capable(CAP_FOWNER))
>> +             error = -EPERM;
>
> omigod.  Geeze man, whose side are you on?

Heh. Yeah, this was not my favorite if statement.

> I suggest something like this:
>
> --- a/fs/namei.c~fs-hardlink-creation-restrictions-fix-fix
> +++ a/fs/namei.c
> @@ -692,6 +692,23 @@ static inline int may_follow_link(struct
>        return error;
>  }
>
> +static bool foobar(struct inode *inode, umode_t mode)
> +{
> +       /* nice comment */
> +       if (!S_ISREG(mode))
> +               return true;
> +       /* nice comment */
> +       if (mode & S_ISUID)
> +               return true;
> +       /* nice comment */
> +       if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
> +               return true;
> +       /* nice comment */
> +       if (inode_permission(inode, MAY_READ | MAY_WRITE))
> +               return true;
> +       return false;
> +}
> +
>  /**
>  * may_linkat - Check permissions for creating a hardlink
>  * @link: the source to hardlink from
> @@ -722,11 +739,8 @@ static int may_linkat(struct path *link)
>        inode = link->dentry->d_inode;
>        mode = inode->i_mode;
>
> -       if (cred->fsuid != inode->i_uid &&
> -           (!S_ISREG(mode) || (mode & S_ISUID) ||
> -            ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) ||
> -            (inode_permission(inode, MAY_READ | MAY_WRITE))) &&
> -           !capable(CAP_FOWNER))
> +       if (cred->fsuid != inode->i_uid && foobar(inode, mode) &&
> +                       !capable(CAP_FOWNER))
>                error = -EPERM;
>
>        if (error)
>
> Please take a look at that, pick a replacement for foobar, fill in the
> nice comments which explain our reasoning, retest it and send it back
> at me?

Sounds good -- I'll get it written and tested shortly.

> Also please take a look at local variable "mode" and decide if there
> was a good reason for it being `int' instead of mode_t?

Ah, sorry. That was an oversight on my part -- I'd ported these before
mode_t existed. I'll fix that too.

Thanks!

-Kees

-- 
Kees Cook
ChromeOS Security
