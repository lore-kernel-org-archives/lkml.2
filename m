Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2BMRhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:37:41 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52207 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578Ab2BMRhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:37:38 -0500
X-Sasl-enc: 2s4uNJrq5EwEBabtSD6XdpOWb06Tu1EP/ydPq98lznZy 1329154656
Message-ID: <4F394A5E.4050002@fastmail.fm>
Date: Mon, 13 Feb 2012 17:37:34 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Markus <M4rkusXXL@web.de>
CC: lkml <linux-kernel@vger.kernel.org>, jack@suse.cz,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        gregkh@linuxfoundation.org
Subject: Re: Deadlock?
References: <3125411.WeeEOF8PnR@f209>
In-Reply-To: <3125411.WeeEOF8PnR@f209>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding CCs

On 02/13/2012 11:17 AM, Markus wrote:
> Hi!
> 
> I noted some kind of deadlock, where I was not able to write to the raid6, 
> while writing to each disk would still work.
> This caused many processes to "wait" in d-state, thus making it impossible to 
> unmount, cleanly reboot, sync, ...
> 
> So I enabled the detection of hung tasks and this deplock option.
> After running a 3.2.2 for about 5 days:
> http://pastebin.com/gy1kaYmS
> 
> I dont know if its a bug or nothing. Or if it has anything to do with my 
> problem as there was no hungtask detected and the raid still seems to work.
> 
> Can anybody enlight me?! ;)
> 
> Markus


    [493061.240015] [ INFO: RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected ]
    [493061.240015] 3.2.2 #1
    [493061.240015] ------------------------------------------------------
    [493061.240015] linuxdcpp/11649 [HC0[0]:SC0[0]:HE1:SE1] is trying to acquire:
    [493061.240015]  (&tty->atomic_write_lock){+.+.+.}, at: [<ffffffff811bf40a>] tty_write_message+0x2a/0x80
    [493061.240015]
    [493061.240015] and this task is already holding:
    [493061.240015]  (&s->s_dquot.dqptr_sem){++++-.}, at: [<ffffffff8111888d>] __dquot_alloc_space+0x9d/0x230
    [493061.240015] which would create a new lock dependency:
    [493061.240015]  (&s->s_dquot.dqptr_sem){++++-.} -> (&tty->atomic_write_lock){+.+.+.}
    [493061.240015]
    [493061.240015] but this new dependency connects a RECLAIM_FS-irq-safe lock:
    [493061.240015]  (&s->s_dquot.dqptr_sem){++++-.}
    [493061.240015] ... which became RECLAIM_FS-irq-safe at:
    [493061.240015]   [<ffffffff81069914>] __lock_acquire+0x6e4/0x1eb0
    [493061.240015]   [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493061.240015]   [<ffffffff81375e4c>] down_write+0x2c/0x50
    [493061.240015]   [<ffffffff81119c97>] __dquot_drop+0x27/0x80
    [493061.240015]   [<ffffffff81119d15>] dquot_drop+0x25/0x30
    [493061.240015]   [<ffffffff81138278>] ext3_evict_inode+0x158/0x260
    [493061.240015]   [<ffffffff810e0167>] evict+0xa7/0x1b0
    [493061.240015]   [<ffffffff810e0807>] dispose_list+0x47/0x60
    [493061.240015]   [<ffffffff810e1222>] prune_icache_sb+0x192/0x370
    [493061.240015]   [<ffffffff810c9e03>] prune_super+0x153/0x1b0
    [493061.240015]   [<ffffffff8109c355>] shrink_slab+0x135/0x1f0
    [493061.240015]   [<ffffffff8109e932>] kswapd+0x632/0x8e0
    [493061.240015]   [<ffffffff81055ce6>] kthread+0x96/0xa0
    [493061.240015]   [<ffffffff81378eb4>] kernel_thread_helper+0x4/0x10
    [493061.240015]
    [493061.240015] to a RECLAIM_FS-irq-unsafe lock:
    [493061.240015]  (&tty->atomic_write_lock){+.+.+.}
    [493061.240015] ... which became RECLAIM_FS-irq-unsafe at:
    [493061.240015] ...  [<ffffffff810681f6>] mark_held_locks+0x76/0x150
    [493061.240015]   [<ffffffff81068ab0>] lockdep_trace_alloc+0xb0/0xe0
    [493061.240015]   [<ffffffff810c2a78>] __kmalloc+0x78/0x160
    [493061.240015]   [<ffffffff811bf126>] tty_write+0x136/0x270
    [493061.240015]   [<ffffffff811bf30d>] redirected_tty_write+0xad/0xb0
    [493061.240015]   [<ffffffff810c6b76>] vfs_write+0xc6/0x180
    [493061.240015]   [<ffffffff810c6e8c>] sys_write+0x4c/0x90
    [493061.240015]   [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493061.240015]
    [493061.240015] other info that might help us debug this:
    [493061.240015]
    [493061.240015]  Possible interrupt unsafe locking scenario:
    [493061.240015]
    [493061.240015]        CPU0                    CPU1
    [493061.240015]        ----                    ----
    [493061.240015]   lock(&tty->atomic_write_lock);
    [493061.240015]                                local_irq_disable();
    [493061.240015]                                lock(&s->s_dquot.dqptr_sem);
    [493061.240015]                                lock(&tty->atomic_write_lock);
    [493061.240015]   <Interrupt>
    [493061.240015]     lock(&s->s_dquot.dqptr_sem);
    [493061.240015]
    [493061.240015]  *** DEADLOCK ***
    [493061.240015]
    [493061.240015] 4 locks held by linuxdcpp/11649:
    [493063.862237]  #0:  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<ffffffff81090947>] generic_file_aio_write+0x57/0xe0
    [493063.862237]  #1:  (jbd_handle){+.+.-.}, at: [<ffffffff81152098>] start_this_handle+0x358/0x450
    [493063.862237]  #2:  (&ei->truncate_mutex){+.+...}, at: [<ffffffff811367c5>] ext3_get_blocks_handle+0xe5/0xbf0
    [493063.862237]  #3:  (&s->s_dquot.dqptr_sem){++++-.}, at: [<ffffffff8111888d>] __dquot_alloc_space+0x9d/0x230
    [493063.862237]
    [493063.862237] the dependencies between RECLAIM_FS-irq-safe lock and the holding lock:
    [493063.862237] -> (&s->s_dquot.dqptr_sem){++++-.} ops: 187112656 {
    [493063.862237]    HARDIRQ-ON-W at:
    [493063.862237]                                         [<ffffffff810699c5>] __lock_acquire+0x795/0x1eb0
    [493063.862237]                                         [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]                                         [<ffffffff81375e4c>] down_write+0x2c/0x50
    [493063.862237]                                         [<ffffffff81119c97>] __dquot_drop+0x27/0x80
    [493063.862237]                                         [<ffffffff8111ac23>] vfs_load_quota_inode+0x4c3/0x510
    [493063.862237]                                         [<ffffffff8111aed0>] dquot_quota_on+0x70/0x80
    [493063.862237]                                         [<ffffffff8113dadb>] ext3_quota_on+0xfb/0x130
    [493063.862237]                                         [<ffffffff8111c726>] do_quotactl+0x536/0x560
    [493063.862237]                                         [<ffffffff8111c81e>] sys_quotactl+0xce/0x1a0
    [493063.862237]                                         [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]    HARDIRQ-ON-R at:
    [493063.862237]                                         [<ffffffff8106988d>] __lock_acquire+0x65d/0x1eb0
    [493063.862237]                                         [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]                                         [<ffffffff81375e9f>] down_read+0x2f/0x50
    [493063.862237]                                         [<ffffffff8111bac3>] dquot_alloc_inode+0x43/0x140
    [493063.862237]                                         [<ffffffff8113354b>] ext3_new_inode+0x89b/0x980
    [493063.862237]                                         [<ffffffff8113b3fd>] ext3_create+0x8d/0x110
    [493063.862237]                                         [<ffffffff810d26fc>] vfs_create+0xac/0xe0
    [493063.862237]                                         [<ffffffff810d4149>] do_last.clone.30+0x469/0x7d0
    [493063.862237]                                         [<ffffffff810d5b50>] path_openat+0xd0/0x410
    [493063.862237]                                         [<ffffffff810d5fa4>] do_filp_open+0x44/0xa0
    [493063.862237]                                         [<ffffffff810c5f9c>] do_sys_open+0xfc/0x1e0
    [493063.862237]                                         [<ffffffff810c609b>] sys_open+0x1b/0x20
    [493063.862237]                                         [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]    SOFTIRQ-ON-W at:
    [493063.862237]                                         [<ffffffff810699ff>] __lock_acquire+0x7cf/0x1eb0
    [493063.862237]                                         [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]                                         [<ffffffff81375e4c>] down_write+0x2c/0x50
    [493063.862237]                                         [<ffffffff81119c97>] __dquot_drop+0x27/0x80
    [493063.862237]                                         [<ffffffff8111ac23>] vfs_load_quota_inode+0x4c3/0x510
    [493063.862237]                                         [<ffffffff8111aed0>] dquot_quota_on+0x70/0x80
    [493063.862237]                                         [<ffffffff8113dadb>] ext3_quota_on+0xfb/0x130
    [493063.862237]                                         [<ffffffff8111c726>] do_quotactl+0x536/0x560
    [493063.862237]                                         [<ffffffff8111c81e>] sys_quotactl+0xce/0x1a0
    [493063.862237]                                         [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]    SOFTIRQ-ON-R at:
    [493063.862237]                                         [<ffffffff810699ff>] __lock_acquire+0x7cf/0x1eb0
    [493063.862237]                                         [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]                                         [<ffffffff81375e9f>] down_read+0x2f/0x50
    [493063.862237]                                         [<ffffffff8111bac3>] dquot_alloc_inode+0x43/0x140
    [493063.862237]                                         [<ffffffff8113354b>] ext3_new_inode+0x89b/0x980
    [493063.862237]                                         [<ffffffff8113b3fd>] ext3_create+0x8d/0x110
    [493063.862237]                                         [<ffffffff810d26fc>] vfs_create+0xac/0xe0
    [493063.862237]                                         [<ffffffff810d4149>] do_last.clone.30+0x469/0x7d0
    [493063.862237]                                         [<ffffffff810d5b50>] path_openat+0xd0/0x410
    [493063.862237]                                         [<ffffffff810d5fa4>] do_filp_open+0x44/0xa0
    [493063.862237]                                         [<ffffffff810c5f9c>] do_sys_open+0xfc/0x1e0
    [493063.862237]                                         [<ffffffff810c609b>] sys_open+0x1b/0x20
    [493063.862237]                                         [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]    IN-RECLAIM_FS-W at:
    [493063.862237]                                            [<ffffffff81069914>] __lock_acquire+0x6e4/0x1eb0
    [493063.862237]                                            [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]                                            [<ffffffff81375e4c>] down_write+0x2c/0x50
    [493063.862237]                                            [<ffffffff81119c97>] __dquot_drop+0x27/0x80
    [493063.862237]                                            [<ffffffff81119d15>] dquot_drop+0x25/0x30
    [493063.862237]                                            [<ffffffff81138278>] ext3_evict_inode+0x158/0x260
    [493063.862237]                                            [<ffffffff810e0167>] evict+0xa7/0x1b0
    [493063.862237]                                            [<ffffffff810e0807>] dispose_list+0x47/0x60
    [493063.862237]                                            [<ffffffff810e1222>] prune_icache_sb+0x192/0x370
    [493063.862237]                                            [<ffffffff810c9e03>] prune_super+0x153/0x1b0
    [493063.862237]                                            [<ffffffff8109c355>] shrink_slab+0x135/0x1f0
    [493063.862237]                                            [<ffffffff8109e932>] kswapd+0x632/0x8e0
    [493063.862237]                                            [<ffffffff81055ce6>] kthread+0x96/0xa0
    [493063.862237]                                            [<ffffffff81378eb4>] kernel_thread_helper+0x4/0x10
    [493063.862237]    INITIAL USE at:
    [493063.862237]                                        [<ffffffff81069619>] __lock_acquire+0x3e9/0x1eb0
    [493063.862237]                                        [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]                                        [<ffffffff81375e4c>] down_write+0x2c/0x50
    [493063.862237]                                        [<ffffffff81119c97>] __dquot_drop+0x27/0x80
    [493063.862237]                                        [<ffffffff8111ac23>] vfs_load_quota_inode+0x4c3/0x510
    [493063.862237]                                        [<ffffffff8111aed0>] dquot_quota_on+0x70/0x80
    [493063.862237]                                        [<ffffffff8113dadb>] ext3_quota_on+0xfb/0x130
    [493063.862237]                                        [<ffffffff8111c726>] do_quotactl+0x536/0x560
    [493063.862237]                                        [<ffffffff8111c81e>] sys_quotactl+0xce/0x1a0
    [493063.862237]                                        [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]  }
    [493063.862237]  ... key      at: [<ffffffff81f48938>] __key.28495+0x0/0x8
    [493063.862237]  ... acquired at:
    [493063.862237]    [<ffffffff810677b0>] check_irq_usage+0x60/0xf0
    [493063.862237]    [<ffffffff8106a244>] __lock_acquire+0x1014/0x1eb0
    [493063.862237]    [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]    [<ffffffff81374d6b>] mutex_lock_nested+0x3b/0x300
    [493063.862237]    [<ffffffff811bf40a>] tty_write_message+0x2a/0x80
    [493063.862237]    [<ffffffff81118377>] flush_warnings+0xe7/0x200
    [493063.862237]    [<ffffffff8111898a>] __dquot_alloc_space+0x19a/0x230
    [493063.862237]    [<ffffffff81130f4c>] ext3_new_blocks+0x6c/0x680
    [493063.862237]    [<ffffffff811369d5>] ext3_get_blocks_handle+0x2f5/0xbf0
    [493063.862237]    [<ffffffff8113738f>] ext3_get_block+0xbf/0x120
    [493063.862237]    [<ffffffff810f44bb>] __block_write_begin+0x1db/0x540
    [493063.862237]    [<ffffffff8113637f>] ext3_write_begin+0xaf/0x200
    [493063.862237]    [<ffffffff8108ea40>] generic_file_buffered_write+0x110/0x280
    [493063.862237]    [<ffffffff810906e1>] __generic_file_aio_write+0x221/0x430
    [493063.862237]    [<ffffffff81090963>] generic_file_aio_write+0x73/0xe0
    [493063.862237]    [<ffffffff810c62ca>] do_sync_write+0xda/0x120
    [493063.862237]    [<ffffffff810c6b76>] vfs_write+0xc6/0x180
    [493063.862237]    [<ffffffff810c6e8c>] sys_write+0x4c/0x90
    [493063.862237]    [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]
    [493063.862237]
    [493063.862237] the dependencies between the lock to be acquired and RECLAIM_FS-irq-unsafe lock:
    [493063.862237] -> (&tty->atomic_write_lock){+.+.+.} ops: 270462830 {
    [493063.862237]    HARDIRQ-ON-W at:
    [493063.862237]                                         [<ffffffff810681f6>] mark_held_locks+0x76/0x150
    [493063.862237]                                         [<ffffffff8106837d>] trace_hardirqs_on_caller+0xad/0x1e0
    [493063.862237]                                         [<ffffffff810684bd>] trace_hardirqs_on+0xd/0x10
    [493063.862237]                                         [<ffffffff81374cbd>] mutex_trylock+0xfd/0x170
    [493063.862237]                                         [<ffffffff811befb3>] tty_write_lock+0x23/0x60
    [493063.862237]                                         [<ffffffff811bf0c3>] tty_write+0xd3/0x270
    [493063.862237]                                         [<ffffffff811bf30d>] redirected_tty_write+0xad/0xb0
    [493063.862237]                                         [<ffffffff810c6b76>] vfs_write+0xc6/0x180
    [493063.862237]                                         [<ffffffff810c6e8c>] sys_write+0x4c/0x90
    [493063.862237]                                         [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]    SOFTIRQ-ON-W at:
    [493063.862237]                                         [<ffffffff810681f6>] mark_held_locks+0x76/0x150
    [493063.862237]                                         [<ffffffff810683ed>] trace_hardirqs_on_caller+0x11d/0x1e0
    [493063.862237]                                         [<ffffffff810684bd>] trace_hardirqs_on+0xd/0x10
    [493063.862237]                                         [<ffffffff81374cbd>] mutex_trylock+0xfd/0x170
    [493063.862237]                                         [<ffffffff811befb3>] tty_write_lock+0x23/0x60
    [493063.862237]                                         [<ffffffff811bf0c3>] tty_write+0xd3/0x270
    [493063.862237]                                         [<ffffffff811bf30d>] redirected_tty_write+0xad/0xb0
    [493063.862237]                                         [<ffffffff810c6b76>] vfs_write+0xc6/0x180
    [493063.862237]                                         [<ffffffff810c6e8c>] sys_write+0x4c/0x90
    [493063.862237]                                         [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]    RECLAIM_FS-ON-W at:
    [493063.862237]                                            [<ffffffff810681f6>] mark_held_locks+0x76/0x150
    [493063.862237]                                            [<ffffffff81068ab0>] lockdep_trace_alloc+0xb0/0xe0
    [493063.862237]                                            [<ffffffff810c2a78>] __kmalloc+0x78/0x160
    [493063.862237]                                            [<ffffffff811bf126>] tty_write+0x136/0x270
    [493063.862237]                                            [<ffffffff811bf30d>] redirected_tty_write+0xad/0xb0
    [493063.862237]                                            [<ffffffff810c6b76>] vfs_write+0xc6/0x180
    [493063.862237]                                            [<ffffffff810c6e8c>] sys_write+0x4c/0x90
    [493063.862237]                                            [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]    INITIAL USE at:
    [493063.862237]                                        [<ffffffff81069619>] __lock_acquire+0x3e9/0x1eb0
    [493063.862237]                                        [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]                                        [<ffffffff81374c6d>] mutex_trylock+0xad/0x170
    [493063.862237]                                        [<ffffffff811befb3>] tty_write_lock+0x23/0x60
    [493063.862237]                                        [<ffffffff811bf0c3>] tty_write+0xd3/0x270
    [493063.862237]                                        [<ffffffff811bf30d>] redirected_tty_write+0xad/0xb0
    [493063.862237]                                        [<ffffffff810c6b76>] vfs_write+0xc6/0x180
    [493063.862237]                                        [<ffffffff810c6e8c>] sys_write+0x4c/0x90
    [493063.862237]                                        [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]  }
    [493063.862237]  ... key      at: [<ffffffff81f549b8>] __key.27415+0x0/0x8
    [493063.862237]  ... acquired at:
    [493063.862237]    [<ffffffff810677b0>] check_irq_usage+0x60/0xf0
    [493063.862237]    [<ffffffff8106a244>] __lock_acquire+0x1014/0x1eb0
    [493063.862237]    [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]    [<ffffffff81374d6b>] mutex_lock_nested+0x3b/0x300
    [493063.862237]    [<ffffffff811bf40a>] tty_write_message+0x2a/0x80
    [493063.862237]    [<ffffffff81118377>] flush_warnings+0xe7/0x200
    [493063.862237]    [<ffffffff8111898a>] __dquot_alloc_space+0x19a/0x230
    [493063.862237]    [<ffffffff81130f4c>] ext3_new_blocks+0x6c/0x680
    [493063.862237]    [<ffffffff811369d5>] ext3_get_blocks_handle+0x2f5/0xbf0
    [493063.862237]    [<ffffffff8113738f>] ext3_get_block+0xbf/0x120
    [493063.862237]    [<ffffffff810f44bb>] __block_write_begin+0x1db/0x540
    [493063.862237]    [<ffffffff8113637f>] ext3_write_begin+0xaf/0x200
    [493063.862237]    [<ffffffff8108ea40>] generic_file_buffered_write+0x110/0x280
    [493063.862237]    [<ffffffff810906e1>] __generic_file_aio_write+0x221/0x430
    [493063.862237]    [<ffffffff81090963>] generic_file_aio_write+0x73/0xe0
    [493063.862237]    [<ffffffff810c62ca>] do_sync_write+0xda/0x120
    [493063.862237]    [<ffffffff810c6b76>] vfs_write+0xc6/0x180
    [493063.862237]    [<ffffffff810c6e8c>] sys_write+0x4c/0x90
    [493063.862237]    [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b
    [493063.862237]
    [493063.862237]
    [493063.862237] stack backtrace:
    [493063.862237] Pid: 11649, comm: linuxdcpp Not tainted 3.2.2 #1
    [493063.862237] Call Trace:
    [493063.862237]  [<ffffffff8106774a>] check_usage+0x4aa/0x4b0
    [493063.862237]  [<ffffffff810050f4>] ? print_context_stack+0x74/0xd0
    [493063.862237]  [<ffffffff810677b0>] check_irq_usage+0x60/0xf0
    [493063.862237]  [<ffffffff8106a244>] __lock_acquire+0x1014/0x1eb0
    [493063.862237]  [<ffffffff8100e6fa>] ? save_stack_trace+0x2a/0x50
    [493063.862237]  [<ffffffff8106b6ad>] lock_acquire+0x8d/0xb0
    [493063.862237]  [<ffffffff811bf40a>] ? tty_write_message+0x2a/0x80
    [493063.862237]  [<ffffffff81374d6b>] mutex_lock_nested+0x3b/0x300
    [493063.862237]  [<ffffffff811bf40a>] ? tty_write_message+0x2a/0x80
    [493063.862237]  [<ffffffff811bf40a>] tty_write_message+0x2a/0x80
    [493063.862237]  [<ffffffff81118377>] flush_warnings+0xe7/0x200
    [493063.862237]  [<ffffffff8111898a>] __dquot_alloc_space+0x19a/0x230
    [493063.862237]  [<ffffffff81130f4c>] ext3_new_blocks+0x6c/0x680
    [493063.862237]  [<ffffffff81374f8f>] ? mutex_lock_nested+0x25f/0x300
    [493063.862237]  [<ffffffff81374f7b>] ? mutex_lock_nested+0x24b/0x300
    [493063.862237]  [<ffffffff811369d5>] ext3_get_blocks_handle+0x2f5/0xbf0
    [493063.862237]  [<ffffffff8106973a>] ? __lock_acquire+0x50a/0x1eb0
    [493063.862237]  [<ffffffff8106973a>] ? __lock_acquire+0x50a/0x1eb0
    [493063.862237]  [<ffffffff810f2c2b>] ? create_empty_buffers+0x4b/0xd0
    [493063.862237]  [<ffffffff8113738f>] ext3_get_block+0xbf/0x120
    [493063.862237]  [<ffffffff810f44bb>] __block_write_begin+0x1db/0x540
    [493063.862237]  [<ffffffff811372d0>] ? ext3_get_blocks_handle+0xbf0/0xbf0
    [493063.862237]  [<ffffffff8113637f>] ext3_write_begin+0xaf/0x200
    [493063.862237]  [<ffffffff8108ea40>] generic_file_buffered_write+0x110/0x280
    [493063.862237]  [<ffffffff8103f221>] ? current_fs_time+0x11/0x50
    [493063.862237]  [<ffffffff810906e1>] __generic_file_aio_write+0x221/0x430
    [493063.862237]  [<ffffffff81090963>] generic_file_aio_write+0x73/0xe0
    [493063.862237]  [<ffffffff810c62ca>] do_sync_write+0xda/0x120
    [493063.862237]  [<ffffffff810a850b>] ? might_fault+0x3b/0x90
    [493063.862237]  [<ffffffff81167287>] ? security_file_permission+0x27/0xb0
    [493063.862237]  [<ffffffff810c6b76>] vfs_write+0xc6/0x180
    [493063.862237]  [<ffffffff810c6e8c>] sys_write+0x4c/0x90
    [493063.862237]  [<ffffffff81377b7b>] system_call_fastpath+0x16/0x1b


