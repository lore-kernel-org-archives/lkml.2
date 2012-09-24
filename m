Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2IXRWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:22:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34799 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2IXRWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:22:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120924112300.GE20655@MAIL.13thfloor.at>
References: <5092540.GORQ1kUuNX@localhost> <CA+55aFymD=QGptAxjSEWffDSA94dtAjPjy-ox76fYWgHn9m+kA@mail.gmail.com>
 <2819949.zde5vZ04eb@localhost> <20120924112300.GE20655@MAIL.13thfloor.at>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Sep 2012 10:22:11 -0700
X-Google-Sender-Auth: OnXQAVlaGTgorgELurtkHjk4VMo
Message-ID: <CA+55aFztBvfGc+AWvTXhaxj54Ow6O-wHJnjr3T-2_BU5cd2EDw@mail.gmail.com>
Subject: Re: [2.6.38-3.x] [BUG] soft lockup - CPU#X stuck for 23s! (vfs,
 autofs, vserver)
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@pld-linux.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        arekm@pld-linux.org, baggins@pld-linux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 4:23 AM, Herbert Poetzl <herbert@13thfloor.at> wrote:
>
> currently we do:
>
>         br_read_lock(&vfsmount_lock);
>         root = current->fs->root;
>         root_mnt = real_mount(root.mnt);
>         point = root.dentry;
>
>         while ((mnt != mnt->mnt_parent) && (mnt != root_mnt)) {
>                 point = mnt->mnt_mountpoint;
>                 mnt = mnt->mnt_parent;
>         }
>
>         ret = (mnt == root_mnt) && is_subdir(point, root.dentry);
>         br_read_unlock(&vfsmount_lock);
>
> and we have been considering to move the br_read_unlock()
> right before the is_subdir() call

So the read lock itself should not cause problems. We have tons of
high-frequency read-lockers, over quite big areas.

But exactly because the readlockers are so high-frequency, I'd expect
any problems to be *found* by read-lockers.

But the *cause* would likely be
 - missing unlocks
 - write-locks
 - recursion on the locks (including read-locks: they are actually
per-cpu spinlocks)

but I'd have expected lockdep to find anything obvious like that.

If the locking itself is fine, maybe the loop above (or the
is_subdir()) is infinite due to mnt->mnt_parent somehow becoming a
circular loop. Maybe due to corrupt data structures traversed inside
the lock, causing infinite loops..

I really don't know the vserver patches, it would be much more
interesting if you can recreate the problems using a standard kernel.

                          Linus
