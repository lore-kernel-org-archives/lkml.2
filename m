Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2FJDtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 23:49:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48827 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2FJDtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 23:49:24 -0400
Date: Sun, 10 Jun 2012 04:49:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120610034921.GB30000@ZenIV.linux.org.uk>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 03:10:11PM +0200, Miklos Szeredi wrote:
> This is part 2 of the atomic open series.  It introduces i_op->atomic_open() and
> converts filesystems that abuse ->lookup() and ->create() to use this new
> interface instead.
> 
> This version has one bugfix and several cleanups, reported by David Howells.
> Also updated documentation in Documentation/filesytems/{vfs.txt,Locking}.
> 
> Al, please apply.
> 
> git tree is here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git atomic-open.v6

I'm more or less OK with that; one major exception is your struct opendata.
I think it needs to go.  Really.  You are using it to store three references -
file, vfsmount and dentry.  You allocate struct file at the very beginning
and store it there; no arguments with that, if you are opening a file, by
damn you do need one.  But that's where it starts to get really, really
odd.  At some point you find vfsmount to be used.  Again, you'd better -
we will need it.  It ends up in file->f_path.mnt.  And that's struct file
opendata ->filp points to.  So why the hell do you not store it right there?
The same goes for dentry.  You will need something to put into
file->f_path.dentry; that field is not going away, no matter what - we do
need to know which filesystem object read() and write() should deal with,
after all.  So why bother with storing it in opendata ->dentry in the
meanwhile, when you have the instance of struct file whose ->f_path.dentry
is to be determined by all that activity?

And if you do that, your struct opendata suddenly shrinks to single struct
file *.  Which you assign in the very beginning, pass by reference to all
that code and do not reassign.  OK, you do reassign it.  In one place:
        res = do_dentry_open(dentry, od->mnt, od->filp, open, current_cred());
        if (!IS_ERR(res))
                od->filp = NULL;
        return res;
Here do_dentry_open() returns one of two things - the value of its third
argument (i.e. od->filp) or ERR_PTR(-E...).  In the latter case struct
file refered to by the third argument has been freed.

So the only remaining reason for having that thing is this: what if we
call ->atomic_open(), but it doesn't call finish_open()?  Then we need
to free that unused struct file.  If finish_open() failed, we wouldn't.
Same if it succeeded and something *after* it in ->atomic_open() failed
(then we need to fput() that file - your code in ceph leaks it, BTW).
Fair enough.  So we need to add one more helper that would discard that
half-set-up struct file as we want it to be discarded.  That's all.

IOW, you get three helpers:
finish_open()
finish_no_open() (really confusing name, BTW)
fail_open()

All of them taking struct file *.  Any call of ->atomic_open() must
call one of those.  Rules:
	* if we called finish_no_open(), we need to return NULL.
That's the "won't open, here's your dentry, open it yourself".
BTW, I would've made it return void * - always NULL.  So that
callers would be of form return finish_no_open(file, dentry);
	* if we called finish_open() and it returned us an error,
we need to return that to our caller.  End of story, we'd failed.
	* if we called finish_open() and it succeeded, the file
has been opened.  Either return it, or fput() it and return ERR_PTR()
if you have something fail past that point.
	* otherwise we need to call failed_open(file).  And return
appropriate ERR_PTR().  Might make sense to turn that into
return failed_open(file, ERR_PTR(-E...)); to make dumb errors easy
to spot.

And this is it - no more struct opendata, considerably simpler cleanup
in fs/namei.c and much more natural prototypes.  Either ->atomic_open()
returns an opened struct file, or it gives us ERR_PTR(...) (in which case
struct file has been freed/vfsmount dropped/etc.) or it gives us NULL.
In the last case struct file is still there and file->f_path contains
the vfsmount/dentry pair we are supposed to deal with (e.g. on hitting
a symlink).

I can massage it to that form, or I can leave conversion at the end;
up to you - it's going to be a single pull request anyway, so prototype
changes midway through the series are not something tragic.  OTOH, folding
said changes back into the original patches might make for less confusing
reading later.  Credit for dealing with that really, really scary pile
of shit is clearly yours anyway.  And I'm absolutely serious - that has
been a work that needed doing and nobody had stomach for it.  You have
my sincere gratitude.
