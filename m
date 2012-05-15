Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2EOIky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:40:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36423 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab2EOIkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <m1havp62hv.fsf@fess.ebiederm.org>
References: <m1vckcdoey.fsf@fess.ebiederm.org>
	<1336142995.25479.49.camel@marge.simpson.net>
	<m1zk9oc61j.fsf@fess.ebiederm.org>
	<1336150643.7502.4.camel@marge.simpson.net>
	<m1fwbfd71h.fsf@fess.ebiederm.org>
	<1336197362.7346.9.camel@marge.simpson.net>
	<1336198093.7346.11.camel@marge.simpson.net>
	<1336201977.7346.22.camel@marge.simpson.net>
	<87r4uv64oj.fsf_-_@xmission.com>
	<20120507221706.GI22082@ZenIV.linux.org.uk>
	<20120507235647.GH21152@linux.vnet.ibm.com>
	<87zk9jzdi5.fsf@xmission.com>
	<CAPa8GCBE--64++-B3H5K-y-sUtyeVrhKwKG-eazVx8Dc7RH+YQ@mail.gmail.com>
	<m1havp62hv.fsf@fess.ebiederm.org>
Date: Tue, 15 May 2012 18:40:46 +1000
Message-ID: <CAPa8GCDvdoprH3PD5-Rd8G3_ROe9NqerxxKudqUpk+ULVQQnkg@mail.gmail.com>
Subject: Re: [PATCH] vfs: Speed up deactivate_super for non-modular filesystems
From: Nick Piggin <npiggin@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: paulmck@linux.vnet.ibm.com, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2012 21:02, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Nick Piggin <npiggin@gmail.com> writes:
>
>> On 8 May 2012 11:07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>>>
>>>> On Mon, May 07, 2012 at 11:17:06PM +0100, Al Viro wrote:
>>>>> On Mon, May 07, 2012 at 02:51:08PM -0700, Eric W. Biederman wrote:
>>>>>
>>>>> > /proc and similar non-modular filesystems do not need a rcu_barrier
>>>>> > in deactivate_locked_super.  Being non-modular there is no danger
>>>>> > of the rcu callback running after the module is unloaded.
>>>>>
>>>>> There's more than just a module unload there, though - actual freeing
>>>>>  struct super_block also happens past that rcu_barrier()...
>>>
>>> Al.  I have not closely audited the entire code path but at a quick
>>> sample I see no evidence that anything depends on inode->i_sb being
>>> rcu safe.  Do you know of any such location?
>>>
>>> It has only been a year and a half since Nick added this code which
>>> isn't very much time to have grown strange dependencies like that.
>>
>> No, it has always depended on this.
>>
>> Look at ncp_compare_dentry(), for example.
>
> Interesting. ncp_compare_dentry this logic is broken.
>
> Accessing i_sb->s_fs_info for parameters does seem reasonable.
> Unfortunately ncp_put_super frees server directly.
>
> Meaning if we are depending on only rcu protections a badly timed
> ncp_compare_dentry will oops the kernel.
>
> I am going to go out on a limb and guess that every other filesystem
> with a similar dependency follows the same pattern and is likely
> broken as well.

But ncp_put_super should be called after the rcu_barrier(), no?

How is it broken?


>>> We need to drain all of the rcu callbacks before we free the slab
>>> and unload the module.
>>>
>>> This actually makes deactivate_locked_super the totally wrong place
>>> for the rcu_barrier.  We want the rcu_barrier in the module exit
>>> routine where we destroy the inode cache.
>>>
>>> What I see as the real need is the filesystem modules need to do:
>>>        rcu_barrier()
>>>        kmem_cache_destroy(cache);
>>>
>>> Perhaps we can add some helpers to make it easy.  But I think
>>> I would be happy today with simply moving the rcu_barrier into
>>> every filesystems module exit path, just before the file system
>>> module destoryed it's inode cache.
>>
>> No, because that's not the only requirement for the rcu_barrier.
>>
>> Making it asynchronous is not something I wanted to do, because
>> then we potentially have a process exiting from kernel space after
>> releasing last reference on a mount, but the mount does not go
>> away until "some time" later. Which is crazy.
>
> Well we certainly want a deliberate unmount of a filesystem to safely
> and successfully put the filesystem in a sane state before the unmount
> returns.
>
> If we have a few linger data structures waiting for an rcu grace period
> after a process exits I'm not certain that is bad.  Although I would not
> mind it much.
>
>> However. We are holding vfsmount_lock for read at the point
>> where we ever actually do anything with an "rcu-referenced"
>> dentry/inode. I wonder if we could use this to get i_sb pinned.
>
> Interesting observation.
>
> Taking that observation farther we have a mount reference count, that
> pins the super block.  So at first glance the super block looks safe
> without any rcu protections.

Well yes, that's what I'm getting at. But I don't think it's quite complete...

>
> I'm not certain what pins the inodes. Let's see:
>
> mnt->d_mnt_root has the root dentry of the dentry tree, and that
> dentry count is protected by the vfsmount_lock.

If the mount is already detached from the namespace when we start
to do a path walk, AFAIKS it can be freed up from underneath us at
that point.

This would require cycling vfsmount_lock for write in such path. It's
better than rcu_barrier probably, but not terribly nice.

>
> Beyond that we have kill_sb.
>  kill_sb() typically calls generic_shutdown_super()
>  From generic_shutdown_super() we call:
>     shrink_dcache_for_umount() which flushes lingering dentries.
>     evict_inodes() which flushes lingering inodes.
>
> So in some sense the reference counts on mounts and dentries protect
> the cache.
>
> So the only case I can see where rcu appears to matter is when we are
> freeing dentries.
>
> When freeing dentries the idiom is:
> dentry_iput(dentry);
> d_free(dentry);
>
> d_free does if (dentry->d_flags & DCACHE_RCUACCESS) call_rcu(... __d_free);
>
> So while most of the time dentries hold onto inodes reliably with a
> reference count and most of the time dentries are kept alive by the
> dentry->d_count part of the time there is this gray zone where only
> rcu references to dentries are keeping them alive.
>
> Which explains the need for rcu freeing of inodes.
>
> This makes me wonder why we think calling d_release is safe
> before we want the rcu grace period.

Why wouldn't it be? The superblock cannot go away until all dentries
are freed.

>
> Documentation/filesystems/vfs.txt seems to duplicate this reasoning
> of why the superblock is safe.  Because we hold a real reference to it
> from the vfsmount.

rcu walk does not hold a reference to the vfsmount, however. It can
go away. This is why functions which can be called from rcu-walk
must go through synchronize_rcu() before they go away, also before
the superblock goes away.

The other way we could change the rule is to require barrier only for
those filesystems which access superblock or other info from rcu-walk.
I would prefer not to have such a rule, but it could be pragmatic.

>
> The strangest case is calling __lookup_mnt during an "rcu-path-walk".
> But mounts are reference counted from the mount namespace, and
> are protected during an "rcu-path-walk" by vfsmount_lock read locked,
> and are only changed with vfsmount_lock write locked.
>
> Which leads again (with stronger reasons now) to the conclusions that:
> a) We don't depend on rcu_barrier to protect the superblock.
> b) My trivial patch is safe.
> c) We probably should move rcu_barrier to the filesystem module exit
>   routines, just to make things clear and to make everything faster.

Still not convinced.
