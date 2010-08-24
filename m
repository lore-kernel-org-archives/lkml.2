Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0HXAFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:05:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0HXAFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:05:34 -0400
Date: Mon, 23 Aug 2010 20:05:05 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
Message-ID: <20100824000505.GA20909@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell> <6820.1282094632@jrobl> <20100818185542.GA10850@shell> <16318.1282181699@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16318.1282181699@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:34:59AM +0900, J. R. Okajima wrote:
> 
> Valerie Aurora:
> > According Al Viro, unionfs has some fundamental architectural problems
> > that prevents it from being correct and leads to crashes:
> >
> > http://lkml.indiana.edu/hypermail/linux/kernel/0802.0/0839.html
> >
> > The main question for me is whether aufs has fixed these problems.  If
> > it hasn't, then it can't be bug-free.
> 
> Although I don't understand fully your question, aufs actually verifies
> the parent-child relationship after lock_rename() on the writable layer.
> Such verification is done in other operations too.
> And aufs provides three options to specify the level of
> verification. When the highest (most strict) level is given, aufs_rename
> lookup again after lock_rename() and compares the got parent and the
> given (cached) parent.
> Does this answer your question correctly?

First, my theory when writing any file system code is that whenever Al
Viro says, "You can deadlock easily" or "It violates the locking
rules" that I have to understand the problem and fix it.  I understand
why union mounts doesn't have the problems unionfs had when Al wrote
this email (because lower layers are not writable).  But since aufs
allows directories on lower layers to be renamed in the way that
creates the problems Al describes, I assume it has this same problem
until the author understands the unionfs problem and can describe why
aufs didn't inherit it (or fixed it, or whatever).

Second, why isn't the most strict level of lookup the only option?  It
seems like anything else is a bug.

Third, you have this odd circular inheritance problem that comes from
moving a child directory on the lower layer to the path of its parent,
and vice versa.  From Al's email:

> If you allow a mix of old and new mappings, you can easily run into the
> situations when at some moment X1 covers Y1, X2 covers Y2, X2 is a descendent
> of X1 and Y1 is a descendent of Y2. You *really* don't want to go there -
> if nothing else, defining behaviour of copyup in face of that insanity
> will be very painful.

I understand the circular inheritance problem but find this hard to
explain better than Al does above.  But here's an example of how you
get there:

Start with parent_dir1/child_dir1 covering parent_dir2/child_dir2
 thread 1 does a union lookup and gets:
  parent_dir1 covering parent_dir2
  child_dir1 covering child_dir2
  parent_dir1 parent of child_dir1
  parent_dir2 parent of child_dir2
 thread 2 swaps parent_dir2 with child_dir2 (using rename and a tmp dir)
  now lower fs looks like: child_dir2/parent_dir2

Who inherits what?  Does thread 1 see parent_dir2 as a descendant of
child_dir2 which is a descendant of parent_dir2 through the union with
parent_dir1?  Can you sanely define the behavior here?

Fourth, you have a potential deadlock now.  Say thread 1 is operating
with the belief that parent_dir1/child_dir1 covers
parent_dir2/child_dir2.  parent_dir2/child_dir2 gets renamed such that
the two switch places, as described above.  And thread 2 is directly
accessing the lower file system, now with child_dir2/parent_dir2.  The
locking order for thread 1 is:

parent_dir2 -> parent_dir1 -> child_dir1 -> child_dir2

For thread 2, it is:

child_dir2 -> parent_dir2

So if thread 1 gets a lock on parent_dir2, and then thread 2 gets a
lock on child_dir2, they will deadlock.  In general, this situation
violates the fundamental assumptions of correct directory locking,
described in Documentation/filesystems/directory-locking.

That's my attempt to explain Al's email, anyway. :) All errors are my
own.

> > Think about the case of two different RPM package database files.  One
> > contains the info from newly installed packages on the top layer file
> > system.  The lower layer contains info from packages newly installed
> > on the lower file system.  You don't want either file; you want the
> > merged packaged database showing the info for all packages installed
> > on both layers.  Any practical file system based system is only going
> > to be able to pick one file or the other, and it's going to be wrong
> > in some cases.
> 
> Let me make sure.
> Do you mean something like this?
> - a user makes a union
> - fileA exists on the lower layer but upper
> - modify fileA in the union
>   --> the file is copied-up and updated on the upper layer.
> - modify fileA on the lower layer directly (by-passing union)
>   --> the file on the lower is updated.
> - and the user will not see the uptodate fileA in the union, lack of the
>   modification made on the lower directly.
> 
> Then I'd say it is an expected behaviour. Simply the upper file hides
> the lower.

I am not arguing with you and I agree that this is the expected
behavior.  I wrote about this case just to show that there is a case
in which what the user "wants" in an upgrade situation is impossible
to do automatically in the file system.  So you need to have a smart
tool to do an upgrade of the lower layer file system.  And I argue
that smart tool should deal with all cases of a file copied up to the
topmost file system that covers an updated file on the lower file
system, instead of putting this policy decision into the VFS.

-VAL
