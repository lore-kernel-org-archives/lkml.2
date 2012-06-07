Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278Ab2FGPob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:44:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59765 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761189Ab2FGPo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:44:28 -0400
MIME-Version: 1.0
In-Reply-To: <87fwa7ha5w.fsf@tucsk.pomaz.szeredi.hu>
References: <87fwa7ha5w.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 08:44:06 -0700
X-Google-Sender-Auth: XEkqRYqNl3krujhbxnDS_hY5d30
Message-ID: <CA+55aFzUH5QYbrhccGcV4m7pNzELm9JE+1UJUbx1BB1rC1ct_w@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 12:07 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Yeah, see the comment in below patch for how it's supposed to work.  I
> *think* it's correct.

Ok, yes, that makes me happier.

What would make me happier still is to get rid of the "save_parent"
thing entirely, though.

And I think you should be able to.

Why?

You already have the rule that:
 - save_parent.mnt is always same as "path->mnt" (or NULL, if not saved)
 - save_parent.dentry is the same as "dir" when you use it (you have a
BUG_ON() for it not being the same)
 - you currently use "save_parent.dentry != NULL" as a flag to say "do
we have the valid state"

So as far as I can tell, you should get rid of all the refcount games
and the "struct path save_parent", and just replace the
"save_parent.dentry != NULL" thing with a flag of whether you have a
valid state.

That would get rid of the whole

        if ((nd->flags & LOOKUP_RCU) || nd->path.mnt != path->mnt) {
                path_to_nameidata(path, nd);
        } else {
                save_parent.dentry = nd->path.dentry;
                save_parent.mnt = mntget(path->mnt);
                nd->path.dentry = path->dentry;

        }

thing, and we could just have the old simple unconditional

        path_to_nameidata(path, nd);

back.

And then you'd have

        if (filp == ERR_PTR(-EOPENSTALE) && save_parent_flag && !retried) {
                dput(nd->path.dentry);
                nd->path.dentry = dget(dir);
                nd->inode = dir->d_inode;
                save_parent_flag = false;
                if (want_write) {
                        mnt_drop_write(nd->path.mnt);
                        want_write = 0;
                }
                retried = true;
                goto retry_lookup;

or something for the EOPENSTALE thing. That would get all the
save_parent refcount games out of the normal path.

Am I missing some reason why that wouldn't work?

            Linus
