Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0G1SPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:15:02 -0400
Received: from mail.candelatech.com ([208.74.158.172]:39522 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab0G1SPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:15:00 -0400
Message-ID: <4C5073A1.8090006@candelatech.com>
Date: Wed, 28 Jul 2010 11:14:57 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34.1+hacks:  kernel deadlock related to file-IO?
References: <4C4F67B3.50101@candelatech.com>	<20100727165146.71e46170@nehalam>	<4C4F767D.4020002@candelatech.com> <20100727231427.1f3eb97b@nehalam>
In-Reply-To: <20100727231427.1f3eb97b@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 11:14 PM, Stephen Hemminger wrote:
> On Tue, 27 Jul 2010 17:14:53 -0700
> Ben Greear<greearb@candelatech.com>  wrote:
>
>> On 07/27/2010 04:51 PM, Stephen Hemminger wrote:
>>> On Tue, 27 Jul 2010 16:11:47 -0700
>>> Ben Greear<greearb@candelatech.com>   wrote:
>>>
>>>> NOTE:  This is from a hacked 2.6.34.1 kernel, with
>>>> a module of my own devising loaded and in active use.
>>>
>>> Ben please don't ask LKML for help with problems when
>>> you have a binary only module loaded...
>>
>> Yeah, I know..but I spent all day hacking .34 enough to
>> run lockdep and get those backtraces..and they *might* be
>> valid.  There's a small chance someone else has seen similar
>> things but not reported it for whatever reason, so maybe
>> they will chime in.
>>
>> And finally, I will attempt to reproduce with some official
>> kernels, and will report what I find one way or another.
>>
>> The .34 kernel has been a real bitch to get stable  (You
>> know things must be bad when my name's on -stable patches),
>> so I wouldn't be surprised if I'm hitting another real bug.
>
> Understand your pain. The hardest problem is often finding a reproducible case.
> If the problem is not reproducible it is hard to add trace info
> or use bisection.

Well, I'm having no luck reproducing w/out my module, but I've
also seen runs of > 1 hour with my module and no problems, so maybe
just not getting lucky yet.

With it loaded, it's reproducible but not too often, and can run
clean for hours before I can see the hung tasks.  They are always hanging in
the same places.  Also, if I do something like 'sysrq t',
then it seems to pause the system long enough for the blocked
processes to recover, and if I manage to stop my traffic
generator (which takes virtually all load off the system),
then it will also recover.

So, it's not a full deadlock..just a very long blockage.  When
the system is 'locked', some console access works just fine,
including ssh logins.  But, if I rerun one of the exact commands
that is hung (say, ls foo/ > /tmp/foo_listing.txt), then that process
will also hang in D state, with stack-trace showing the hang in
do_get_write_access.

Without my module, the total traffic load is less, and there is
one less process using 100% of a CPU.  And of course it could
be doing any number of buggy things...just that I'm having a real
hard time figuring out what it might possibly be doing to
cause the hangs I see.


Stack traces for 3 of the processes locked > 2 minutes and lockdep lock
printouts below if anyone is interested.


I'm going to keep trying to find a way to reproduce on standard-ish
kernels.


Thanks,
Ben



Jul 28 10:24:45 localhost kernel: SysRq : Show Locks Held
Jul 28 10:24:45 localhost kernel:
Jul 28 10:24:45 localhost kernel: Showing all locks held in the system:
Jul 28 10:24:45 localhost kernel: 2 locks held by flush-253:0/243:
Jul 28 10:24:45 localhost kernel: #0:  (&type->s_umount_key#19){++++..}, at: [<ffffffff810fa51a>] writeback_inodes_wb+0x275/0x553
Jul 28 10:24:45 localhost kernel: #1:  (jbd2_handle){+.+...}, at: [<ffffffff81178a20>] start_this_handle+0x4d7/0x539
Jul 28 10:24:45 localhost kernel: 1 lock held by bash/2723:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by bash/2753:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by mingetty/2990:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by mingetty/2991:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by mingetty/2992:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by mingetty/2994:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by mingetty/2996:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by mingetty/2997:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by bash/3451:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 1 lock held by bash/14171:
Jul 28 10:24:45 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124d968>] n_tty_read+0x27c/0x785
Jul 28 10:24:45 localhost kernel: 3 locks held by ip/21154:
Jul 28 10:24:45 localhost kernel: #0:  (jbd2_handle){+.+...}, at: [<ffffffff81178a20>] start_this_handle+0x4d7/0x539
Jul 28 10:24:45 localhost kernel: #1:  (&ei->i_data_sem){++++..}, at: [<ffffffff81151b3d>] ext4_get_blocks+0xe4/0x1bb
Jul 28 10:24:45 localhost kernel: #2:  (&lg->lg_mutex){+.+...}, at: [<ffffffff81167ab8>] ext4_mb_initialize_context+0x177/0x186
Jul 28 10:24:45 localhost kernel: 4 locks held by sh/21158:
Jul 28 10:24:45 localhost kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810ddd14>] do_truncate+0x5b/0x84
Jul 28 10:24:45 localhost kernel: #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2771>] notify_change+0x16c/0x2a3
Jul 28 10:24:45 localhost kernel: #2:  (jbd2_handle){+.+...}, at: [<ffffffff81178a20>] start_this_handle+0x4d7/0x539
Jul 28 10:24:45 localhost kernel: #3:  (&ei->i_data_sem){++++..}, at: [<ffffffff81164aa8>] ext4_ext_truncate+0x93/0x78f
Jul 28 10:24:45 localhost kernel: 4 locks held by sh/21160:
Jul 28 10:24:45 localhost kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810ddd14>] do_truncate+0x5b/0x84
Jul 28 10:24:45 localhost kernel: #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2771>] notify_change+0x16c/0x2a3
Jul 28 10:24:45 localhost kernel: #2:  (jbd2_handle){+.+...}, at: [<ffffffff81178a20>] start_this_handle+0x4d7/0x539
Jul 28 10:24:45 localhost kernel: #3:  (&ei->i_data_sem){++++..}, at: [<ffffffff81164aa8>] ext4_ext_truncate+0x93/0x78f
Jul 28 10:24:45 localhost kernel:
Jul 28 10:24:45 localhost kernel: =============================================
Jul 28 10:24:45 localhost kernel:


[root@simech2 ~]# cat /proc/21160/stack
[<ffffffff81177dea>] do_get_write_access+0x22d/0x422
[<ffffffff811780de>] jbd2_journal_get_write_access+0x26/0x3c
[<ffffffff811654bd>] __ext4_journal_get_write_access+0x50/0x5a
[<ffffffff81169981>] ext4_free_blocks+0x39c/0x712
[<ffffffff81164d8a>] ext4_ext_truncate+0x375/0x78f
[<ffffffff8115360f>] ext4_truncate+0x95/0x54e
[<ffffffff810a959b>] vmtruncate+0x47/0x52
[<ffffffff810f250b>] inode_setattr+0x2b/0x125
[<ffffffff81153d42>] ext4_setattr+0x27a/0x2fa
[<ffffffff810f278e>] notify_change+0x189/0x2a3
[<ffffffff810ddd20>] do_truncate+0x67/0x84
[<ffffffff810e8e40>] do_last+0x5b4/0x5b9
[<ffffffff810e9282>] do_filp_open+0x1f3/0x601
[<ffffffff810dd091>] do_sys_open+0x5e/0x10a
[<ffffffff810dd166>] sys_open+0x1b/0x1d
[<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff


[root@simech2 ~]# cat /proc/21154/stack
[<ffffffff81177dea>] do_get_write_access+0x22d/0x422
[<ffffffff811780de>] jbd2_journal_get_write_access+0x26/0x3c
[<ffffffff811654bd>] __ext4_journal_get_write_access+0x50/0x5a
[<ffffffff811676f5>] ext4_mb_mark_diskspace_used+0x65/0x2b1
[<ffffffff8116b94a>] ext4_mb_new_blocks+0x19e/0x308
[<ffffffff811646de>] ext4_ext_get_blocks+0x133f/0x1676
[<ffffffff81151b76>] ext4_get_blocks+0x11d/0x1bb
[<ffffffff81152050>] mpage_da_map_blocks+0xc2/0x334
[<ffffffff811525c0>] ext4_da_writepages+0x2fe/0x499
[<ffffffff810a6bed>] do_writepages+0x1f/0x28
[<ffffffff810a08d8>] __filemap_fdatawrite_range+0x4e/0x50
[<ffffffff810a0ddd>] filemap_flush+0x17/0x19
[<ffffffff81150ec5>] ext4_alloc_da_blocks+0x2b/0x2d
[<ffffffff8114b81c>] ext4_release_file+0x28/0xa6
[<ffffffff810dfddf>] __fput+0x120/0x1cd
[<ffffffff810dfea1>] fput+0x15/0x17
[<ffffffff810dcf1f>] filp_close+0x63/0x6d
[<ffffffff81043b1f>] put_files_struct+0xb1/0x15f
[<ffffffff81043c03>] exit_files+0x36/0x3b
[<ffffffff810454e5>] do_exit+0x21c/0x6f4
[<ffffffff81045a30>] do_group_exit+0x73/0x9c
[<ffffffff81045a6b>] sys_exit_group+0x12/0x16
[<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff



[root@simech2 ~]# cat /proc/243/stack
[<ffffffff8109fcfd>] sync_page+0x44/0x48
[<ffffffff8109fc6f>] __lock_page+0x61/0x68
[<ffffffff810a6a17>] write_cache_pages+0x1a9/0x33c
[<ffffffff811525a4>] ext4_da_writepages+0x2e2/0x499
[<ffffffff810a6bed>] do_writepages+0x1f/0x28
[<ffffffff810f9b71>] writeback_single_inode+0xe5/0x2e0
[<ffffffff810fa6c9>] writeback_inodes_wb+0x424/0x553
[<ffffffff810fa92c>] wb_writeback+0x134/0x1bb
[<ffffffff810fabad>] wb_do_writeback+0x14c/0x162
[<ffffffff810fabfd>] bdi_writeback_task+0x3a/0xbb
[<ffffffff810b1dd0>] bdi_start_fn+0x63/0xc7
[<ffffffff81056737>] kthread+0x7a/0x82
[<ffffffff8100a924>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff






-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

