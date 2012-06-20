Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2FTCj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:39:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43231 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2FTCj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120618200131.GA12351@fieldses.org>
References: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
	<1339815965-1171-2-git-send-email-filbranden@gmail.com>
	<20120618200131.GA12351@fieldses.org>
Date: Tue, 19 Jun 2012 22:39:55 -0400
Message-ID: <CABe66sW0k4N_7vMduOZMRak-U4A+6E7i+fiGwKEVBazJ1npBeg@mail.gmail.com>
Subject: Re: [PATCH 1/1] locks: prevent side-effects of locks_release_private
 before file_lock is initialized
From: Filipe Brandenburger <filbranden@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 18, 2012 at 4:01 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> But clearest might be to separate allocation and initialization and
> delay the latter till we know we're going to need it?

I started playing with this second idea of yours... Unfortunately
having fl_lmops unset before it's fully initialized doesn't really
work because its methods are needed by vfs_setlease()... also, that
would change the API for other users of that function...

But I thought of a way of setting a flag to mark the struct as
uninitialized and then have vfs_setlease() clear that flag once it
decides to use that struct. If it doesn't and changes the flp pointer
to the one that was in use before, then it doesn't clear that flag
which means the locks_free_lock() function will not do any calls into
fl_lmops which might have side effects on the process...

Here's the patch:


diff --git a/include/linux/fs.h b/include/linux/fs.h
index 17fd887..8da1217 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1129,6 +1129,7 @@ static inline int file_check_writeable(struct file *filp)
 #define FL_SLEEP       128     /* A blocking lock */
 #define FL_DOWNGRADE_PENDING   256 /* Lease is being downgraded */
 #define FL_UNLOCK_PENDING      512 /* Lease is being broken */
+#define FL_LEASE_UNINITIALIZED 1024 /* Lease was not fully initialized yet */

 /*
  * Special return value from posix_lock_file() and vfs_lock_file() for
diff --git a/fs/locks.c b/fs/locks.c
index 814c51d..a995cc9 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -195,6 +195,8 @@ EXPORT_SYMBOL_GPL(locks_alloc_lock);

 void locks_release_private(struct file_lock *fl)
 {
+       if (fl->fl_flags & FL_LEASE_UNINITIALIZED)
+               return;
        if (fl->fl_ops) {
                if (fl->fl_ops->fl_release_private)
                        fl->fl_ops->fl_release_private(fl);
@@ -454,7 +456,7 @@ static int lease_init(struct file *filp, int type,
struct file_lock *fl)
        fl->fl_pid = current->tgid;

        fl->fl_file = filp;
-       fl->fl_flags = FL_LEASE;
+       fl->fl_flags = FL_LEASE | FL_LEASE_UNINITIALIZED;
        fl->fl_start = 0;
        fl->fl_end = OFFSET_MAX;
        fl->fl_ops = NULL;
@@ -1406,6 +1408,7 @@ int generic_add_lease(struct file *filp, long
arg, struct file_lock **flp)
        if (!leases_enable)
                goto out;

+       lease->fl_flags &= ~FL_LEASE_UNINITIALIZED;
        locks_insert_lock(before, lease);
        return 0;



Unfortunately, at this point I have more questions than answers...
* Is this a good idea?
* Is it good to store this as an extra flag? Or would it be
preferrable to add an extra boolean field to the file_lock struct
instead?
* Is FL_LEASE_UNINITIALIZED a good name for this flag?
* Should this flag be set only in lease_init()? Or also functions such
as flock_make_lock()? Potentially everything that is freed with
locks_free_lock() might need it...
* Should the flag be cleared in generic_add_lease() only? Or should
__vfs_setlease() compare the original value of the lease pointer with
the one returned by generic_setlease() (or filp->f_op->setlease() if
it's set) and then clear the flag itself?

Also, looking at lease_alloc(), I noticed that it calls
locks_free_lock() if lease_init() fails, but lease_init() can only
fail right at the beginning if assign_type() fails, but at that point
can it be guaranteed that fl_lmops (and fl_ops for that matter) are
properly populated or are at least NULL? Maybe locks_alloc_lock()
should initialize the file_lock struct with a flag indicating that
it's not fully initialized at that point yet...

Another thing I noticed (after Bruce pointed me to that code) is that
fs/nfsd/nfs4state.c:nfs4_setlease() seems to suffer from the leak bug
that was fixed by the commits which introduced this issue, it's not
checking whether vfs_setlease() is returning a different file_lock
struct than the one it allocated and in that case it's not freeing the
one it passed. But I'd say it's probably best to figure out a fix for
that one only after this one is fixed to avoid introducing the
regression there as well.

Cheers,
Filipe
