Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2EIH4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:56:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41738 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2EIHz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:55:58 -0400
MIME-Version: 1.0
In-Reply-To: <87zk9jzdi5.fsf@xmission.com>
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
Date: Wed, 9 May 2012 17:55:57 +1000
Message-ID: <CAPa8GCBE--64++-B3H5K-y-sUtyeVrhKwKG-eazVx8Dc7RH+YQ@mail.gmail.com>
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

On 8 May 2012 11:07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>
>> On Mon, May 07, 2012 at 11:17:06PM +0100, Al Viro wrote:
>>> On Mon, May 07, 2012 at 02:51:08PM -0700, Eric W. Biederman wrote:
>>>
>>> > /proc and similar non-modular filesystems do not need a rcu_barrier
>>> > in deactivate_locked_super.  Being non-modular there is no danger
>>> > of the rcu callback running after the module is unloaded.
>>>
>>> There's more than just a module unload there, though - actual freeing
>>>  struct super_block also happens past that rcu_barrier()...
>
> Al.  I have not closely audited the entire code path but at a quick
> sample I see no evidence that anything depends on inode->i_sb being
> rcu safe.  Do you know of any such location?
>
> It has only been a year and a half since Nick added this code which
> isn't very much time to have grown strange dependencies like that.

No, it has always depended on this.

Look at ncp_compare_dentry(), for example.


>> Is there anything in there for which synchronous operation is required?
>> If not, one approach would be to drop the rcu_barrier() calls to a
>> workqueue or something similar.
>
> We need to drain all of the rcu callbacks before we free the slab
> and unload the module.
>
> This actually makes deactivate_locked_super the totally wrong place
> for the rcu_barrier.  We want the rcu_barrier in the module exit
> routine where we destroy the inode cache.
>
> What I see as the real need is the filesystem modules need to do:
>        rcu_barrier()
>        kmem_cache_destroy(cache);
>
> Perhaps we can add some helpers to make it easy.  But I think
> I would be happy today with simply moving the rcu_barrier into
> every filesystems module exit path, just before the file system
> module destoryed it's inode cache.

No, because that's not the only requirement for the rcu_barrier.

Making it asynchronous is not something I wanted to do, because
then we potentially have a process exiting from kernel space after
releasing last reference on a mount, but the mount does not go
away until "some time" later. Which is crazy.

However. We are holding vfsmount_lock for read at the point
where we ever actually do anything with an "rcu-referenced"
dentry/inode. I wonder if we could use this to get i_sb pinned.
