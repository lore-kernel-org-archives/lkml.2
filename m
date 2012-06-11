Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2FKQC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:02:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35480 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2FKQCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:02:10 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
References: <87fwa7ha5w.fsf@tucsk.pomaz.szeredi.hu>
	<CA+55aFzUH5QYbrhccGcV4m7pNzELm9JE+1UJUbx1BB1rC1ct_w@mail.gmail.com>
Date: Mon, 11 Jun 2012 18:02:53 +0200
In-Reply-To: <CA+55aFzUH5QYbrhccGcV4m7pNzELm9JE+1UJUbx1BB1rC1ct_w@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 7 Jun 2012 08:44:06 -0700")
Message-ID: <873961hm4y.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Jun 7, 2012 at 12:07 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> Yeah, see the comment in below patch for how it's supposed to work.  I
>> *think* it's correct.
>
> Ok, yes, that makes me happier.
>
> What would make me happier still is to get rid of the "save_parent"
> thing entirely, though.
>
> And I think you should be able to.
>
> Why?
>
> You already have the rule that:
>  - save_parent.mnt is always same as "path->mnt" (or NULL, if not saved)
>  - save_parent.dentry is the same as "dir" when you use it (you have a
> BUG_ON() for it not being the same)
>  - you currently use "save_parent.dentry != NULL" as a flag to say "do
> we have the valid state"
>
> So as far as I can tell, you should get rid of all the refcount games
> and the "struct path save_parent", and just replace the
> "save_parent.dentry != NULL" thing with a flag of whether you have a
> valid state.
>
> That would get rid of the whole
>
>         if ((nd->flags & LOOKUP_RCU) || nd->path.mnt != path->mnt) {
>                 path_to_nameidata(path, nd);
>         } else {
>                 save_parent.dentry = nd->path.dentry;
>                 save_parent.mnt = mntget(path->mnt);
>                 nd->path.dentry = path->dentry;
>
>         }
>
> thing, and we could just have the old simple unconditional
>
>         path_to_nameidata(path, nd);
>
> back.
>
> And then you'd have
>
>         if (filp == ERR_PTR(-EOPENSTALE) && save_parent_flag && !retried) {
>                 dput(nd->path.dentry);
>                 nd->path.dentry = dget(dir);

But 'dir' may no longer be valid here since we dput it in
path_to_nameidata() earlier.

So, unfortunately, we do need to play those refcounting games.

The mntget() could be optimized away in theory, but it's tricky because
complete_walk() might do a path_put(nd->path) on failure and then we'd
be left with a dentry ref without a matching vfsmount ref.

Thanks,
Miklos
