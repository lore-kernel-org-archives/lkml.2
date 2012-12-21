Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2LULDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:03:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2LULDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:03:38 -0500
Date: Fri, 21 Dec 2012 12:03:33 +0100
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
Message-ID: <20121221110333.GE17357@quack.suse.cz>
References: <cover.1356043686.git.luto@amacapital.net>
 <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
 <20121221003401.GB13474@quack.suse.cz>
 <CALCETrVCGeL6-Jji05CLrFUSyMOE6b5W2dqGNQoyUqLYXw0LLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVCGeL6-Jji05CLrFUSyMOE6b5W2dqGNQoyUqLYXw0LLg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-12-12 21:42:46, Andy Lutomirski wrote:
> On Thu, Dec 20, 2012 at 4:34 PM, Jan Kara <jack@suse.cz> wrote:
> >> +/**
> >> + *   inode_update_time_writable      -       update mtime and ctime time
> >> + *   @inode: inode accessed
> >> + *
> >> + *   This is like file_update_time, but it assumes the mnt is writable
> >> + *   and takes an inode parameter instead.
> >> + */
> >> +
> >> +int inode_update_time_writable(struct inode *inode)
> >> +{
> >> +     struct timespec now;
> >> +     int sync_it = 0;
> >> +     int ret;
> >> +
> >> +     /* First try to exhaust all avenues to not sync */
> >> +     if (IS_NOCMTIME(inode))
> >> +             return 0;
> >> +
> >> +     now = current_fs_time(inode->i_sb);
> >> +     if (!timespec_equal(&inode->i_mtime, &now))
> >> +             sync_it = S_MTIME;
> >> +
> >> +     if (!timespec_equal(&inode->i_ctime, &now))
> >> +             sync_it |= S_CTIME;
> >> +
> >> +     if (IS_I_VERSION(inode))
> >> +             sync_it |= S_VERSION;
> >> +
> >> +     if (!sync_it)
> >> +             return 0;
> >> +
> >> +     ret = update_time(inode, &now, sync_it);
> >> +
> >> +     return ret;
> >> +}
> >> +EXPORT_SYMBOL(inode_update_time_writable);
> >> +
> >   So this differs from file_update_time() only by not calling
> > __mnt_want_write(). Why this special function? It is actually unsafe wrt
> > remounts read-only or filesystem freezing... For that you need to call
> > sb_start_write() / sb_end_write() around the timestamp update. Umm, or
> > better sb_start_pagefault() / sb_end_pagefault() because the call in
> > remove_vma() gets called under mmap_sem so we are in a rather similar
> > situation to ->page_mkwrite.
> 
> The important difference is that it takes an inode* as a parameter
> instead of a file*.  I don't think that inodes have a struct vfsmount,
> so I can't call __mnt_want_write.  I'll take a look at
> sb_start_pagefault.  I'll also refactor this a bit to minimize code
> duplication.  The current approach was for the v1 rfc version. :)
  I see. OK. __mnt_want_write() is the less important part and I guess we
can just skip that for timestamp updates (we are sure update was generated
because of some writeable mount so it's not really important via which
mount writing of them to disk was triggered). But freeze protection is a
must (otherwise e.g. dm snapshot could create corrupted filesystems). Also
reducing code duplication would be nice as you say.

> >> diff --git a/mm/mmap.c b/mm/mmap.c
> >> index 3913262..60301dc 100644
> >> --- a/mm/mmap.c
> >> +++ b/mm/mmap.c
> >> @@ -223,6 +223,10 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
> >>       struct vm_area_struct *next = vma->vm_next;
> >>
> >>       might_sleep();
> >> +
> >> +     if (vma->vm_file)
> >> +             mapping_flush_cmtime(vma->vm_file->f_mapping);
> >> +
> >>       if (vma->vm_ops && vma->vm_ops->close)
> >>               vma->vm_ops->close(vma);
> >>       if (vma->vm_file)
> >> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> >> index cdea11a..8cbb7fb 100644
> >> --- a/mm/page-writeback.c
> >> +++ b/mm/page-writeback.c
> >> @@ -1910,6 +1910,13 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
> >>               ret = mapping->a_ops->writepages(mapping, wbc);
> >>       else
> >>               ret = generic_writepages(mapping, wbc);
> >> +
> >> +     /*
> >> +      * This is after writepages because the AS_CMTIME bit won't
> >> +      * bet set until writepages is called.
> >> +      */
> >> +     mapping_flush_cmtime(mapping);
> >> +
> >>       return ret;
> >>  }
> >>
> >> @@ -2117,8 +2124,17 @@ EXPORT_SYMBOL(set_page_dirty);
> >>   */
> >>  int set_page_dirty_from_pte(struct page *page)
> >>  {
> >> -     /* Doesn't do anything interesting yet. */
> >> -     return set_page_dirty(page);
> >> +     int ret = set_page_dirty(page);
> >> +
> >> +     /*
> >> +      * We may be out of memory and/or have various locks held, so
> >> +      * there isn't much we can do in here.
> >> +      */
> >> +     struct address_space *mapping = page_mapping(page);
> >   Declarations should go together please. So something like:
> >         int ret = set_page_dirty(page);
> >         struct address_space *mapping = page_mapping(page);
> >
> >         /* comment... */
> 
> Will do.  Some day I'll learn how to act less like a C99/C++
> programmer when writing kernel code.
  We are conservative sometimes ;)

> Am I correct in interpreting this as "these patches may be
> sufficiently non-insane that I should keep working on them"?  I admit
> I'm pretty far out of my depth working on vm/vfs stuff.
  Well, they look sane to me. The 'ext4 sometime hangs' part isn't that
compelling in general (although I understand it's your main motivation) but
'we should follow POSIX' part is. I suggest you CC linux-mm@kvack.org on
your next iteration as some changes involve more MM than anything else.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
