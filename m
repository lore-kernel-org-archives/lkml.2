Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2LUFnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:43:12 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:41872 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2LUFnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:43:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121221003401.GB13474@quack.suse.cz>
References: <cover.1356043686.git.luto@amacapital.net> <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
 <20121221003401.GB13474@quack.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Dec 2012 21:42:46 -0800
Message-ID: <CALCETrVCGeL6-Jji05CLrFUSyMOE6b5W2dqGNQoyUqLYXw0LLg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 4:34 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 20-12-12 15:10:10, Andy Lutomirski wrote:
>> The onus is currently on filesystems to call file_update_time
>> somewhere in the page_mkwrite path.  This is unfortunate for three
>> reasons:
>>
>> 1. page_mkwrite on a locked page should be fast.  ext4, for example,
>>    often sleeps while dirtying inodes.
>>
>> 2. The current behavior is surprising -- the timestamp resulting from
>>    an mmaped write will be before the write, not after.  This contradicts
>>    the mmap(2) manpage, which says:
>>
>>      The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
>>      MAP_SHARED  will  be  updated  after  a write to the mapped region, and
>>      before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if  one
>>      occurs.
>   I agree your behavior is more correct wrt to the manpage / spec. OTOH I
> could dig out several emails where users complain time stamps magically
> change some time after the file was written via mmap (because writeback
> happened at that time and it did some allocation to the inode). People hit
> this e.g. when compiling something, ld(1) writes final binary through mmap,
> the package / archive the final binary and later some sanity check finds
> the time stamp on the binary is newer than the package / archive.
>
> Looking more into the patch you end up updating timestamps on munmap(2)
> (thus on file close in particular). That should avoid the most surprising
> cases and users hopefully won't notice the difference. Good. But please
> mention this explicitely in the changelog.

I was careful to get that case right.  I'll update the changelog.

In particular, I've so far tested munmap, msync(MS_SYNC), fsync,
waiting 30 seconds, and dying by fatal signal.  All of those paths
work right.

>> +/**
>> + *   inode_update_time_writable      -       update mtime and ctime time
>> + *   @inode: inode accessed
>> + *
>> + *   This is like file_update_time, but it assumes the mnt is writable
>> + *   and takes an inode parameter instead.
>> + */
>> +
>> +int inode_update_time_writable(struct inode *inode)
>> +{
>> +     struct timespec now;
>> +     int sync_it = 0;
>> +     int ret;
>> +
>> +     /* First try to exhaust all avenues to not sync */
>> +     if (IS_NOCMTIME(inode))
>> +             return 0;
>> +
>> +     now = current_fs_time(inode->i_sb);
>> +     if (!timespec_equal(&inode->i_mtime, &now))
>> +             sync_it = S_MTIME;
>> +
>> +     if (!timespec_equal(&inode->i_ctime, &now))
>> +             sync_it |= S_CTIME;
>> +
>> +     if (IS_I_VERSION(inode))
>> +             sync_it |= S_VERSION;
>> +
>> +     if (!sync_it)
>> +             return 0;
>> +
>> +     ret = update_time(inode, &now, sync_it);
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(inode_update_time_writable);
>> +
>   So this differs from file_update_time() only by not calling
> __mnt_want_write(). Why this special function? It is actually unsafe wrt
> remounts read-only or filesystem freezing... For that you need to call
> sb_start_write() / sb_end_write() around the timestamp update. Umm, or
> better sb_start_pagefault() / sb_end_pagefault() because the call in
> remove_vma() gets called under mmap_sem so we are in a rather similar
> situation to ->page_mkwrite.

The important difference is that it takes an inode* as a parameter
instead of a file*.  I don't think that inodes have a struct vfsmount,
so I can't call __mnt_want_write.  I'll take a look at
sb_start_pagefault.  I'll also refactor this a bit to minimize code
duplication.  The current approach was for the v1 rfc version. :)

>
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index 3913262..60301dc 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -223,6 +223,10 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
>>       struct vm_area_struct *next = vma->vm_next;
>>
>>       might_sleep();
>> +
>> +     if (vma->vm_file)
>> +             mapping_flush_cmtime(vma->vm_file->f_mapping);
>> +
>>       if (vma->vm_ops && vma->vm_ops->close)
>>               vma->vm_ops->close(vma);
>>       if (vma->vm_file)
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index cdea11a..8cbb7fb 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1910,6 +1910,13 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>>               ret = mapping->a_ops->writepages(mapping, wbc);
>>       else
>>               ret = generic_writepages(mapping, wbc);
>> +
>> +     /*
>> +      * This is after writepages because the AS_CMTIME bit won't
>> +      * bet set until writepages is called.
>> +      */
>> +     mapping_flush_cmtime(mapping);
>> +
>>       return ret;
>>  }
>>
>> @@ -2117,8 +2124,17 @@ EXPORT_SYMBOL(set_page_dirty);
>>   */
>>  int set_page_dirty_from_pte(struct page *page)
>>  {
>> -     /* Doesn't do anything interesting yet. */
>> -     return set_page_dirty(page);
>> +     int ret = set_page_dirty(page);
>> +
>> +     /*
>> +      * We may be out of memory and/or have various locks held, so
>> +      * there isn't much we can do in here.
>> +      */
>> +     struct address_space *mapping = page_mapping(page);
>   Declarations should go together please. So something like:
>         int ret = set_page_dirty(page);
>         struct address_space *mapping = page_mapping(page);
>
>         /* comment... */

Will do.  Some day I'll learn how to act less like a C99/C++
programmer when writing kernel code.

Am I correct in interpreting this as "these patches may be
sufficiently non-insane that I should keep working on them"?  I admit
I'm pretty far out of my depth working on vm/vfs stuff.

Thanks,
Andy
