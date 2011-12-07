Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1LGSXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:23:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53425 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab1LGSXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:23:30 -0500
MIME-Version: 1.0
In-Reply-To: <20111207073051.GB16942@elte.hu>
References: <20111206235815.GA21764@www.outflux.net>
	<20111207073051.GB16942@elte.hu>
Date: Wed, 7 Dec 2011 10:23:28 -0800
X-Google-Sender-Auth: boRMEaupu6sQIb57HH_3CYszQF8
Message-ID: <CAGXu5j+Es+12b=0j28a149nVahJUFktMbft3Bx0CBLJ7J2ZJUA@mail.gmail.com>
Subject: Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        kernel-hardening@lists.openwall.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 11:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> * Kees Cook <keescook@chromium.org> wrote:
>
>> Past objections and rebuttals could be summarized as:
>> ...
>>  - Might break unknown applications that use this feature.
>>    - Applications that break because of the change are easy to spot and
>>      fix. Applications that are vulnerable to symlink ToCToU by not having
>>      the change aren't. Additionally, no applications have yet been found
>>      that rely on this behavior.
>
> Are there *known* applications that break?

Not that I've seen and none have been mentioned in any of the previous
discussions I've been able to find. (From above: "Additionally, no
applications have yet been found that rely on this behavior.")

>>  - This should live in the core VFS.
>>    - This should live in an LSM. (https://lkml.org/lkml/2010/5/31/135)
>>  - This should live in an LSM.
>>    - This should live in the core VFS. (https://lkml.org/lkml/2010/8/2/188)
>
> Ugh - and people continue to get exploited from a preventable,
> fixable and already fixed VFS design flaw.

Right.

>> +config PROTECTED_STICKY_SYMLINKS
>> +     bool "Protect symlink following in sticky world-writable directories"
>> +     help
>> +       A long-standing class of security issues is the symlink-based
>> +       time-of-check-time-of-use race, most commonly seen in
>> +       world-writable directories like /tmp. The common method of
>> +       exploitation of this flaw is to cross privilege boundaries
>> +       when following a given symlink (i.e. a root process follows
>> +       a malicious symlink belonging to another user).
>> +
>> +       Enabling this solves the problem by permitting symlinks to only
>> +       be followed when outside a sticky world-writable directory,
>> +       or when the uid of the symlink and follower match, or when
>> +       the directory and symlink owners match.
>
> Unless there are known apps that regress, shouldnt this be
> default y? Even if we were forced to not actually release such a
> final kernel, doing it in -rc1 would flush weird apps out of the
> woodwork.

I would totally agree. I was trying to be conservative here, but would
much rather this default to "y".

>> +int protected_sticky_symlinks =
>
> __read_mostly, most emphatically.

Ah yes. I will fix this.

>> +static inline int
>> +may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
>> +{
>> +     int error = 0;
>> +     const struct inode *parent;
>> +     const struct inode *inode;
>> +     const struct cred *cred;
>> +
>> +     if (!protected_sticky_symlinks)
>> +             return 0;
>> +
>> +     /* Allowed if owner and follower match. */
>> +     cred = current_cred();
>> +     inode = dentry->d_inode;
>> +     if (cred->fsuid == inode->i_uid)
>> +             return 0;
>> +
>> +     /* Check parent directory mode and owner. */
>> +     spin_lock(&dentry->d_lock);
>> +     parent = dentry->d_parent->d_inode;
>> +     if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
>> +         parent->i_uid != inode->i_uid) {
>> +             error = -EACCES;
>> +     }
>> +     spin_unlock(&dentry->d_lock);
>
> Taking the global /tmp and /lib, /usr/lib dentry spinlocks here
> every time we follow a symlink is a bit sad: there are a lot of
> high-profile symlinks in a Linux installation in those places,
> followed by non-owners.
>
> Nor is it really a realistic race that happens often: neither
> /tmp nor the library directories are being renamed or their
> permissions changed all that often for this parent lock taking
> to matter in practice.
>
> Couldnt we somehow export this information outside the dentry
> lock, allowing safe lockless access to it?

I'm open to whatever is needed, though I think this change would be
outside the scope of this patch's intent.

>> +     if (error) {
>> +             char name[sizeof(current->comm)];
>> +             printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
>> +                     "following attempted in sticky world-writable "
>> +                     "directory by %s (fsuid %d)\n",
>> +                     get_task_comm(name, current), cred->fsuid);
>
> I don't think the get_task_comm() extra layer is really
> necessary here - this is called in the *current* task's context
> - and it's not like that tasks are changing their own names all
> that often while they are busy executing VFS code, right? The
> race with some other task writing to /proc/PID/comm is
> uninteresting.

I would rather not have any kind of race here. It's only during the
failure condition, so we don't need speed.

> The more important piece of forensic information to log would be
> the file name that got attempted and perhaps the directory name
> as well. If there's an unknown hole in an unknown privileged app
> then this warning alone does not give the admin any clues where
> to look - the name of the expoiting task is probably obfuscated
> anyway, it's the identity of the attack vector that matters -
> and that name can generally not be controlled and obfuscated by
> the attacker.

Agreed. I will work on extracting this information and presenting it sanely.

> If those issues are resolved:
>
>  Reviewed-by: Ingo Molnar <mingo@elte.hu>

Thanks for looking it over!

-Kees

-- 
Kees Cook
ChromeOS Security
