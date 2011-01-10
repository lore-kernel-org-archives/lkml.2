Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1AJVtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:49:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39728 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1AJVtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PlzdtEQDa72XQAlTb7XW0z2WfO26GCiAsiVIegHMgu1YnNMRO2zJosJC5lYl7yWh71
         VF5u4/uBKgp+xAw3rQBsVG+XZOX/Ww5L0R0I7zaMFdd/h7PM6CKAIwQ36Upwgo9QVV6W
         Fl2C083R1dIHSWLfJ8cJi3njwVtzphCLSBmxw=
MIME-Version: 1.0
In-Reply-To: <4D24F934.7010803@linux.vnet.ibm.com>
References: <20110104124054.c767a4ee.sfr@canb.auug.org.au>
	<4D2363E7.30101@linux.vnet.ibm.com>
	<20110105064425.GA3161@amd>
	<4D24F934.7010803@linux.vnet.ibm.com>
Date: Mon, 10 Jan 2011 15:49:37 -0600
Message-ID: <AANLkTikGhYYJCUGjPDEbCDamDnmwh5O4_ZWmHDY7=BNK@mail.gmail.com>
Subject: Re: linux-next: manual merge of the vfs-scale tree with the v9fs tree
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: jvrao@linux.vnet.ibm.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm...

I've merged up our for-next patch series with Linus' tree which now
has the vfs-scalability patches in it.
Unfortunately, it seems something has been introduced which changes
underlying assumptions in the v9fs code causing certain operations to
fail with a segfault in the dentry code.  We are digging into now and
will keep folks apprised of the situation.  Some quick checks have
shown that the problem wasn't there in 2.6.37 but are in linus' tree
as of today.  I'm in the process of bisecting further -- it may not be
the fault of the concerns below, but I figured I should post and let
folks know about the problem.

For what its worth, here's the failure we see:
sh-2.05b# mount -t 9p 10.0.2.2 /mnt -o port=5670
[   49.044605] mount used greatest stack depth: 4664 bytes left
sh-2.05b# ls /mnt
bin    dev         initrd.img.old  lost+found  n1   opt   selinux  usr
boot   etc         lib             media       n2   proc  srv      var
cdrom  home        lib32           mnt         nas  root  sys      vmlinuz
csrv   initrd.img  lib64           n0          net  sbin  tmp      vmlinuz.old
sh-2.05b# ls /mnt/tmp
cscope.9130  error.txt  ns.ericvh.:1  orbit-gdm  pulse-PKdhtXMmr18n
sh-2.05b# cd /mnt/tmp
sh-2.05b# ls -l
total 1
drwx------    1 501      266594          0 Jan  7 14:54 cscope.9130
-rw-r--r--    1 501      266594        806 Jan  7 15:03 error.txt
drwx------    1 501      266594          0 Jan  6 21:19 ns.ericvh.:1
drwx------    1 114      124             0 Jan  6 21:24 orbit-gdm
drwx------    1 114      124             0 Jan  6 21:09 pulse-PKdhtXMmr18n
sh-2.05b# mkdir test
[   61.764123] ------------[ cut here ]------------
[   61.765045] kernel BUG at /home/ericvh/src/linux/v9fs-devel/fs/dcache.c:1358!
[   61.765045] invalid opcode: 0000 [#1] SMP
[   61.765045] last sysfs file:
[   61.765045] CPU 0
[   61.765045] Pid: 853, comm: mkdir Not tainted 2.6.37+ #124 /Bochs
[   61.765045] RIP: 0010:[<ffffffff8111dda8>]  [<ffffffff8111dda8>]
d_set_d_op+0xb/0x58
[   61.765045] RSP: 0000:ffff880016a0bdb8  EFLAGS: 00010282
[   61.765045] RAX: ffff880016d43440 RBX: ffff880016d4a9c0 RCX: ffff880017b23880
[   61.765045] RDX: 0000000000000000 RSI: ffffffff81636d40 RDI: ffff880016d4a9c0
[   61.765045] RBP: ffff880016a0bdb8 R08: 0000000000004000 R09: ffff880016a0bcf8
[   61.765045] R10: 0000000000000004 R11: ffff880017925d30 R12: ffff880016946d80
[   61.765045] R13: ffff880016946de0 R14: 0000000000000000 R15: ffff880016a0c400
[   61.765045] FS:  0000000000000000(0000) GS:ffff880017c00000(0000)
knlGS:0000000000000000
[   61.765045] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[   61.765045] CR2: 00000000f76f23c0 CR3: 0000000016814000 CR4: 00000000000006f0
[   61.765045] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   61.765045] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   61.765045] Process mkdir (pid: 853, threadinfo ffff880016a0a000,
task ffff88001695a490)
[   61.765045] Stack:
[   61.765045]  ffff880016a0be28 ffffffff812071bc ffff880016d43440
800001ed00000000
[   61.765045]  0000000000000000 ffff880016d42fc0 0000000000000000
ffff880016d4a9f8
[   61.765045]  0000000000000000 ffff880016d42fc0 ffff880016d4a9c0
ffff880016a0c400
[   61.765045] Call Trace:
[   61.765045]  [<ffffffff812071bc>] v9fs_create+0x21e/0x273
[   61.765045]  [<ffffffff812075a5>] v9fs_vfs_mkdir+0x77/0x9a
[   61.765045]  [<ffffffff81117b68>] vfs_mkdir+0x5a/0x96
[   61.765045]  [<ffffffff81119c7c>] sys_mkdirat+0x91/0xe2
[   61.765045]  [<ffffffff81119ce0>] sys_mkdir+0x13/0x15
[   61.765045]  [<ffffffff810599b3>] ia32_sysret+0x0/0x5
[   61.765045] Code: cc 39 53 20 0f 84 4a ff ff ff eb e5 31 db 48 83
c4 48 48 89 d8 5b 41 5c 41 5d 41 5e 41 5f c9 c3 48 83 7f 60 00 55 48
89 e5 74 04 <0f> 0b eb fe 66 f7 07 00 f0 74 04 0f 0b eb fe 48 85 f6 48
89 77
[   61.765045] RIP  [<ffffffff8111dda8>] d_set_d_op+0xb/0x58
[   61.765045]  RSP <ffff880016a0bdb8>
[   61.802265] ---[ end trace af62980550ad7d9c ]---
Segmentation fault


On Wed, Jan 5, 2011 at 5:05 PM, Venkateswararao Jujjuri (JV)
<jvrao@linux.vnet.ibm.com> wrote:
> On 1/4/2011 10:44 PM, Nick Piggin wrote:
>> On Tue, Jan 04, 2011 at 10:16:07AM -0800, Venkateswararao Jujjuri (JV) wrote:
>>> On 1/3/2011 5:40 PM, Stephen Rothwell wrote:
>>>> Hi Nick,
>>>>
>>>> Today's linux-next merge of the vfs-scale tree got a conflict in
>>>> fs/9p/vfs_inode.c between commit 3d21652a1d23591e7f0bbbbedae29ce78c2c1113
>>>> ("fs/9p: Move dotl inode operations into a seperate file") from the v9fs
>>>> tree and various commits from the vfs-scale tree.
>>>>
>>>> I fixed it up by using the v9fs changes to that file and then applying
>>>> the following merge fixup patch (which I can carry as necessary).
>>>>
>>>> Someone will need to fix this up before one of these trees is merged by
>>>> Linus, or to send this merge fix to Linus.
>>>>
>>>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>>>> Date: Tue, 4 Jan 2011 12:33:54 +1100
>>>> Subject: [PATCH] v9fs: merge fix for changes in the vfs-scale tree
>>>>
>>>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>>> ---
>>>>  fs/9p/vfs_inode_dotl.c |   22 +++++++++++-----------
>>>>  1 files changed, 11 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
>>>> index 38d5880..9dd534b 100644
>>>> --- a/fs/9p/vfs_inode_dotl.c
>>>> +++ b/fs/9p/vfs_inode_dotl.c
>>>> @@ -78,11 +78,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct inode *inode)
>>>>  {
>>>>     struct dentry *dentry;
>>>>
>>>> -   spin_lock(&dcache_lock);
>>>> +   spin_lock(&inode->i_lock);
>>>>     /* Directory should have only one entry. */
>>>>     BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
>>>>     dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
>>>> -   spin_unlock(&dcache_lock);
>>>> +   spin_unlock(&inode->i_lock);
>>>
>>> Are we doing away with dcache_lock?
>>
>> It's on its last legs...
>>
>>
>>> I am not sure if the i_lock can serve the same purpose..but looks like with the
>>> current code
>>> there may not need any lock around this code. Aneesh/Eric do you guys have any
>>> comments?
>>
>> Well first of all, why do you say i_lock can't serve the same purpose?
>
> What I mean is i_lock is not equivalent to dcache_lock in generic sense.
>
>> Removing locks is well and good, but if i_lock doesn't work here, then
>> I've made a mistake either fudnamentally in the dcache, or with a
>> particular pattern that v9fs uses -- either way it has to be understood.
>>
>
> Initially we had a version where we walk up the d_parent to construct
> the complete path and corresponding fids for the entire path for 9P purpose.
> As we are walking we thought of using big hammer to lock the entire dcache.
> Later we used read/write locks to protect race between v9fs_fid_lookup and
> rename operations.
> Hence I don't think we need to protect this with  dcache_lock.
> But having i_lock around this code looks good to me.
>
>> dcache lock removal of course isn't done ad-hoc. These two patches
>> specifically are the ones which aim to replace this particular instance
>> of locking:
>
> While reading patches below...
>>
>> http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=commit;h=5d30c20d47023b95b2a0d4820917dba8ba218d1a
>
> @@ -271,9 +271,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct
> inode *inode)
>        struct dentry *dentry;
>
>        spin_lock(&dcache_lock);
> +       spin_lock(&dcache_inode_lock);
>        /* Directory should have only one entry. */
>        BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
>        dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
> +       spin_unlock(&dcache_inode_lock);
>        spin_unlock(&dcache_lock);
>        return dentry;
>> http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=commit;h=ef4953a772e04aef8cf5b94a9b70ffbb12b576e2
>>
> @@ -277,11 +277,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct
> inode *inode)
>  {
>        struct dentry *dentry;
>
> -       spin_lock(&dcache_inode_lock);
> +       spin_lock(&inode->i_lock);
>        /* Directory should have only one entry. */
>        BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
>        dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
> -       spin_unlock(&dcache_inode_lock);
> +       spin_unlock(&inode->i_lock);
>        return dentry;
>  }
>
> Wondering if there is another patch in between to take out the dcache_lock.
>
> Anyway, Changes in this patch look good to me and sorry for the confusion.
>
> Thanks,
> JV
>>
>>>>     return dentry;
>>>>  }
>>>>
>>>> @@ -215,7 +215,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>>>>                             err);
>>>>                     goto error;
>>>>             }
>>>> -           dentry->d_op = &v9fs_cached_dentry_operations;
>>>> +           d_set_d_op(dentry, &v9fs_cached_dentry_operations);
>>>
>>> Assuming that this is a macro to the same operation.. rest of the changes look
>>> fine to me.
>>
>> Yes it's equivalent.
>>
>> Thanks,
>> Nick
>>
>
>
>
