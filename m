Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab2KBJBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:01:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59208 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2KBJBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <20121101161038.GK2616@ZenIV.linux.org.uk>
References: <1351785096-32473-1-git-send-email-linkinjeon@gmail.com>
	<20121101161038.GK2616@ZenIV.linux.org.uk>
Date: Fri, 2 Nov 2012 18:01:37 +0900
Message-ID: <CAKYAXd9w++MTHc9q+fYfFP-L1pwz45oXsTgp91SNXvaToc-Y+w@mail.gmail.com>
Subject: Re: [PATCH] fs: notify: Fix race condition between umount and inotify_rm_watch
From: Namjae Jeon <linkinjeon@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: eparis@parisplace.org, hirofumi@mail.parknet.co.jp, sgruszka@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Pankaj Kumar <jangra.pankaj9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/2, Al Viro <viro@zeniv.linux.org.uk>:
> On Fri, Nov 02, 2012 at 12:51:36AM +0900, Namjae Jeon wrote:
>> When a user is monitoring an FS_UMOUNT watch using the inotify framework,
>> there can be a potential race condition between the umount path &
>> inotify_rm_watch. This scenario can be like-
>> =================================================================
>> user does the following calls-
>> fd = inotify_init();
>> inotify_add_watch(path, IN_UNMOUNT); /* added a watch to path*/
>> read(fd); /* wait for the event */
>> inotify_rm_watch(); /* as soon as event came, remove the
>> watch tag from the selected path */
>>
>> Now as we trigger the umount command on the above mentioned path,
>> it will trigger a fsnotification for all the waiting inotify watches,
>> and then userspace will find that event came, it does the required
>> action and remove the watch.
>> Now while watch is being removed, there is possibility that umount
>> process is still under execution & in not complete and on the other
>> path inotify_rm_watch() will call an iput() on the watched inode,
>> then there can be a race whether the inode's superblock is valid
>> at that moment or its gone.
>> So some time we end up in this race very badly and we try to access
>> the super_block which now not in a valid memory and kernel dies. Trace
>> is like shown below
>>
>>   138.892000] [<c02f1050>] (do_raw_spin_trylock+0x0/0x54) from
>>   [<c043e590>] (__raw_spin_lock+0x34/0x90)
>>   [  138.900000] [<c043e55c>] (__raw_spin_lock+0x0/0x90) from
>>   [<c043e604>] (_raw_spin_lock+0x18/0x1c)
>>   [  138.908000]  r5:000000bc r4:e3db94f0
>>   [  138.912000] [<c043e5ec>] (_raw_spin_lock+0x0/0x1c) from
>>   [<c01e3c94>] (fat_detach+0x3c/0x80)
>>   [  138.920000] [<c01e3c58>] (fat_detach+0x0/0x80) from [<c01e3d40>]
>>   (fat_evict_inode+0x68/0x6c)
>>   [  138.932000]  r5:c0459cc0 r4:e3db94f0
>>   [  138.932000] [<c01e3cd8>] (fat_evict_inode+0x0/0x6c) from
>>   [<c0154f00>] (evict+0x94/0x154)
>>   [  138.940000]  r4:e3db94f0 r3:c01e3cd8
>>   [  138.944000] [<c0154e6c>] (evict+0x0/0x154) from [<c0155184>]
>>   (iput+0x17c/0x18c)
>>   [  138.952000]  r5:e3db9504 r4:e3db94f0
>>   [  138.956000] [<c0155008>] (iput+0x0/0x18c) from [<c0173ae4>]
>>   (fsnotify_destroy_mark+0x15c/0x19c)
>>   [  138.964000]  r6:e3db94f0 r5:e3017540 r4:e41882a0 r3:271aed08
>>   [  138.972000] [<c0173988>] (fsnotify_destroy_mark+0x0/0x19c) from
>>   [<c0175890>] (sys_inotify_rm_watch+0x88/0xc0)
>>   [  138.980000]  r8:c004aba8 r7:e3017540 r6:e41882a0 r5:00000000
>>   r4:e3017300
>>   [  138.988000] r3:00000000
>>   [  138.988000] [<c0175808>] (sys_inotify_rm_watch+0x0/0xc0) from
>>   [<c004a920>] (ret_fast_syscall+0x0/0x30
>>
>> So we can see inside the fat_detach function we are accessing illegal
>> inode->i_sb->s_fs_info and we end up in above crash.
>> ====================================================================
>> To solve this race, we must have some sort of serialized access to
>> superblock structure in umount path and fsnotification path. Now since
>> the umount path takes an exclusive lock on s_umount of superblock.
>> So if umount is in progress, this lock will not be free.
>>
>> Hence we may try to take a shared access to super block's s_umount lock
>> inside the inotify_rm_watch() & if lock is free, means no one is doing
>> write operation on this superblock. So we can then just go ahead and
>> then before calling iput on the concerned inode, first we should check
>> whether this inode's superblock is still valid( e.g s_count is >= 1) or
>> not.
>> So based on this condition we can choose our action and prevent the race.
>
Hi. Al.
> NAK.  The bug is real, but proposed fix is broken.  AFAICS, your variant
> is going to deadlock if watch removal request comes in the middle of
> umount,
> when ->s_umount has already been taken.
I did not understand, how there would be dead lock between umount and
inotify_rm_watch().
lets us suppose umount is inside the generic_shutdown_super() with
holding s_count, and if in between inotify_rm_watch() comes, it will
try to do a down_read(s_umount) and will be blocked until
generic_shutdown_super exists and  while exiting it will do up_write()
and inotify_rm_watch() will get the lock. Please let me know if i am
missing
some thing here.
>
> Moreover, ->s_count doesn't do what you seem to think it does.  If you ever
> see a superblock with ->s_count being 0, you've already lost.  It might've
> been dereferencing already kfree()'d memory, for all you know.
And yes, there might be a situation,that we might end up in
dereferencing the kfree()'s memory, which is not good. Let me think
more..

Thanks for review!.
>
