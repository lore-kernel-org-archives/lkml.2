Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024Ab2FFWjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:39:09 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41045 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758916Ab2FFWjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120606194233.GA1537@redhat.com>
References: <20120603223617.GB7707@redhat.com> <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk> <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Jun 2012 15:38:46 -0700
X-Google-Sender-Auth: XiLrJYrLOHBRFaCJQuzc_dPExXk
Message-ID: <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So what filesystem is this?

It really looks like something has left i_mutex locked on a directory,
but I'm for the life of me not seeing it. There are lookup changes
mainly by Miklos, but they don't seem to change the i_mutex locking.

They do change some other things, though. In particular, I mislike the
last patch in that series ("vfs: retry last component if opening stale
dentry"), which does the whole "save_parent" thing. There's a few
things that look odd there, and I don't like this code, for example:

+               save_parent.dentry = nd->path.dentry;
+               save_parent.mnt = mntget(path->mnt);
+               nd->path.dentry = path->dentry;
...
+               path_put(&save_parent);

whete there isn't a dget() on the dentry (but path_put() will do a
dput() on it). I'm guessing it's because we lose a refcount to it when
we overwrite nd->path.dentry, but why isn't there a dget() on *that*
one? The patch just makes me nervous. Miklos, can you explain more?
The interactions with "path_put_conditional()" makes me extra nervous.

I'm also adding Jan, since he changed the i_mutex rules for the quota
files. That should be totally immaterial, but just the fact that it
touches i_mutex makes me want to hear more. Maybe there's some path
that had a lock, the unlock got deleted, and inode information ended
up leaking through the slab caches or something insane like that.

The lock output doesn't tell me anything new, except that yes, once
more people are waiting for a directory mutex, or waiting for the
rename mutex that is held by another process waiting for the directory
mutex.

Anybody see any i_mutex changes I missed?

                Linus

On Wed, Jun 6, 2012 at 12:42 PM, Dave Jones <davej@redhat.com> wrote:
>
> Just hit this again on a different box, though this time the stack traces
> of the stuck processes seems to vary between fchmod/fchown/getdents calls.
>
> partial dmesg at http://fpaste.org/jBVM/
> sysrq-w: http://fpaste.org/uYtj/
> sysrq-d: http://fpaste.org/Xxur/
>
> does this give any new clues that the previous traces didn't ?
>
>        Dave
>
