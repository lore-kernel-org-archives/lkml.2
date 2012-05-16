Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2EPAfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:35:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37229 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2EPAfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:35:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <npiggin@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
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
	<CAPa8GCDvdoprH3PD5-Rd8G3_ROe9NqerxxKudqUpk+ULVQQnkg@mail.gmail.com>
Date: Tue, 15 May 2012 17:34:50 -0700
In-Reply-To: <CAPa8GCDvdoprH3PD5-Rd8G3_ROe9NqerxxKudqUpk+ULVQQnkg@mail.gmail.com>
	(Nick Piggin's message of "Tue, 15 May 2012 18:40:46 +1000")
Message-ID: <87k40d2cb9.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=70.65.242.55;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19oAlhEzlbWz3bMgu2yiOIJQVUlboUZCVA=
X-SA-Exim-Connect-IP: 70.65.242.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0197]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Nick Piggin <npiggin@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] vfs: Speed up deactivate_super for non-modular filesystems
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@gmail.com> writes:

> On 9 May 2012 21:02, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Nick Piggin <npiggin@gmail.com> writes:
>>
>>> On 8 May 2012 11:07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>>>>
>>>>> On Mon, May 07, 2012 at 11:17:06PM +0100, Al Viro wrote:
>>>>>> On Mon, May 07, 2012 at 02:51:08PM -0700, Eric W. Biederman wrote:
>>>>>>
>>>>>> > /proc and similar non-modular filesystems do not need a rcu_barrier
>>>>>> > in deactivate_locked_super.  Being non-modular there is no danger
>>>>>> > of the rcu callback running after the module is unloaded.
>>>>>>
>>>>>> There's more than just a module unload there, though - actual freeing
>>>>>>  struct super_block also happens past that rcu_barrier()...
>>>>
>>>> Al.  I have not closely audited the entire code path but at a quick
>>>> sample I see no evidence that anything depends on inode->i_sb being
>>>> rcu safe.  Do you know of any such location?
>>>>
>>>> It has only been a year and a half since Nick added this code which
>>>> isn't very much time to have grown strange dependencies like that.
>>>
>>> No, it has always depended on this.
>>>
>>> Look at ncp_compare_dentry(), for example.
>>
>> Interesting. ncp_compare_dentry this logic is broken.
>>
>> Accessing i_sb->s_fs_info for parameters does seem reasonable.
>> Unfortunately ncp_put_super frees server directly.
>>
>> Meaning if we are depending on only rcu protections a badly timed
>> ncp_compare_dentry will oops the kernel.
>>
>> I am going to go out on a limb and guess that every other filesystem
>> with a similar dependency follows the same pattern and is likely
>> broken as well.
>
> But ncp_put_super should be called after the rcu_barrier(), no?
>
> How is it broken?

The interesting hunk of code from deactivate_locked_super is:
>	cleancache_invalidate_fs(s);
>	fs->kill_sb(s);
 	^^^^^^^^^^^^^^  This is where ncp_put_super() is called.
>
>	/* caches are now gone, we can safely kill the shrinker now */
>	unregister_shrinker(&s->s_shrink);
>
>	/*
>	 * We need to call rcu_barrier so all the delayed rcu free
>	 * inodes are flushed before we release the fs module.
>	 */
>	rcu_barrier();
>	put_filesystem(fs);
>	put_super(s);

Which guarantees ncp_put_super() happens before the rcu_barrier.

>> Taking that observation farther we have a mount reference count, that
>> pins the super block.  So at first glance the super block looks safe
>> without any rcu protections.
>
> Well yes, that's what I'm getting at. But I don't think it's quite complete...
>
>>
>> I'm not certain what pins the inodes. Let's see:
>>
>> mnt->d_mnt_root has the root dentry of the dentry tree, and that
>> dentry count is protected by the vfsmount_lock.
>
> If the mount is already detached from the namespace when we start
> to do a path walk, AFAIKS it can be freed up from underneath us at
> that point.
>
> This would require cycling vfsmount_lock for write in such path. It's
> better than rcu_barrier probably, but not terribly nice.

Where do you see the possibility of a mount detached from a namespace
causing problems?   Simply having any count on a mount ensures we cycle
the vfsmount in mntput_no_expire.


Or if you want to see what I am seeing:

The rcu_path_walk starts at one of.  "." "/" or file->f_path, all of
which hold a reference on a struct vfsmount.

We perform an rcu_path_walk with the locking.
br_read_lock(vfsmount_lock);
rcu_read_lock();

We can transition to another vfs mount via follow_mount_rcu 
which consults the mount hash table which can only be modified
under the br_write_lock(vfsmount_lock);

We can also transition to another vfs mount via follow_up_rcu
which simply goes to mnt->mnt_parent.  Where our starting vfsmount
holds a reference to the target vfsmount.

When we complete the rcu_path_walk we do:
rcu_read_unlock()
br_write_lock(vfsmount_lock)

mntput_no_expire, which decrements mount counts takes and releases
br_write_lock before we put the final mount reference.  Which means
that it is impossible for the final mntput on a mount to complete
while we are in the middle of an rcu path walk.

Once we have take and released br_write_lock(vfsmount_lock)
in mntput_no_expire we call mntfree.  mntfree calls
deactivate_super.  And deactivate_super calls deactivate_locked_super.

Which is a long winded way of saying we always call
deactivate_locked_super after we put our final mount count.

I don't possibly see how a mount can be freed while we are in
the middle of a rcu path walk.  Not while we hold the
br_read_lock(vfsmount_lock), and the final mntput takes
br_write_lock(vfsmount_lock).


>> Documentation/filesystems/vfs.txt seems to duplicate this reasoning
>> of why the superblock is safe.  Because we hold a real reference to it
>> from the vfsmount.
>
> rcu walk does not hold a reference to the vfsmount, however. It can
> go away. This is why functions which can be called from rcu-walk
> must go through synchronize_rcu() before they go away, also before
> the superblock goes away.

Not at all.

The rcu walk itself does not hold a reference to the vfsmount, but
something holds a reference to the vfsmount and to drop the final
reference on a vfsmount we must hold the vfsmount_lock for write.
The rcu walk holds the vfsmount_lock for read which prevents us from
grabbing the vfsmount_lock for write.

We need to wait an rcu grace period before freeing dentries and inodes
becuase for dentries and inodes we only have rcu protection for them.
For vfsmounts and the superblock we have a lock protected reference
count.

> The other way we could change the rule is to require barrier only for
> those filesystems which access superblock or other info from rcu-walk.
> I would prefer not to have such a rule, but it could be pragmatic.

I don't see that we need to change a rule.

Eric
