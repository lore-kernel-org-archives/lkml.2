Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0JMJtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:49:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44505 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0JMJtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cVAVgghjUjJsOES5rPH+9WwIuSBnDcd1KhFIZs5XahIbC2i2/6irTykk3f0wKqgPj0
         vJhcF5+TWyhn/yFaqTMfARe5EbbS60imBUF9mOh0mRtjuNbn8r/aiM+DwUrxeaMwrszP
         f3CAQeSwMcxmd3sY4SA8yTPlZxP+HpIlNjNSw=
MIME-Version: 1.0
Date: Wed, 13 Oct 2010 15:19:01 +0530
Message-ID: <AANLkTinvsMxTxEbDEFmb5M-6fYjdRvErU==Zs7+qANkV@mail.gmail.com>
Subject: [LogFS] [2.6.36-rc7] Deadlock in logfs_get_wblocks, hold and wait on
 same lock super->s_write_mutex
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: linux-fsdevel@vger.kernel.org, Joern <joern@logfs.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 11 05:03:54 localhost kernel: INFO: task kswapd0:26 blocked for
more than 120 seconds.
Oct 11 05:03:54 localhost kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 11 05:03:54 localhost kernel: kswapd0       D 0000000000000000
0    26      2 0x00000000
Oct 11 05:03:54 localhost kernel: ffff88006c785950 0000000000000046
ffff880000000000 ffff88006c784010
Oct 11 05:03:54 localhost kernel: ffff88006c785fd8 0000000000014780
ffff88007c94c590 ffff88007c94c948
Oct 11 05:03:54 localhost kernel: ffff88007c94c940 0000000000014780
0000000000014780 ffff88006c785fd8
Oct 11 05:03:54 localhost kernel: Call Trace:
Oct 11 05:03:54 localhost kernel: [<ffffffff8142c26d>]
__mutex_lock_common+0x12c/0x193
Oct 11 05:03:54 localhost kernel: [<ffffffff8142c2ed>]
__mutex_lock_slowpath+0x19/0x1b
Oct 11 05:03:54 localhost kernel: [<ffffffff8142c40d>] mutex_lock+0x36/0x50
Oct 11 05:03:54 localhost kernel: [<ffffffff81205cc1>] ?
radix_tree_delete+0xb4/0x1ba
Oct 11 05:03:54 localhost kernel: [<ffffffffa01682ee>]
logfs_get_wblocks+0x66/0x72 [logfs]
Oct 11 05:03:54 localhost kernel: [<ffffffffa01694dc>]
logfs_write_buf+0x38/0x69 [logfs]
Oct 11 05:03:54 localhost kernel: [<ffffffffa0164806>]
__logfs_writepage+0x23/0x67 [logfs]
Oct 11 05:03:54 localhost kernel: [<ffffffffa01648c5>]
logfs_writepage+0x7b/0x82 [logfs]
Oct 11 05:03:54 localhost kernel: [<ffffffff810d218e>] pageout+0x13a/0x26d
Oct 11 05:03:54 localhost kernel: [<ffffffff810d26d2>]
shrink_page_list+0x25d/0x443
Oct 11 05:03:54 localhost kernel: [<ffffffff810d2b08>]
shrink_inactive_list+0x250/0x355
Oct 11 05:03:54 localhost kernel: [<ffffffff81049049>] ? load_balance+0xd9/0x6c0
Oct 11 05:03:54 localhost kernel: [<ffffffff810ccd1b>] ?
determine_dirtyable_memory+0x1a/0x2d
Oct 11 05:03:54 localhost kernel: [<ffffffff810d2f7d>] shrink_zone+0x370/0x42c
Oct 11 05:03:54 localhost kernel: [<ffffffff810d37ab>] balance_pgdat+0x2c0/0x4ea
Oct 11 05:03:54 localhost kernel: [<ffffffff810Oct 11 13:37:16
localhost kernel: imklog 4.4.1, log source = /proc/kmsg started.

Unfortunately I could not get the rest of the stack dump, but by
seeing the process that causes the OOPs and available call stack, it
very easy to guess what might have happened.

static void logfs_get_wblocks(struct super_block *sb, struct page
*page, int lock)
{
    struct logfs_super *super = logfs_super(sb);

    if (page)
        prelock_page(sb, page, lock);

    if (lock) {
        mutex_lock(&super->s_write_mutex);
        logfs_gc_pass(sb);
        /* FIXME: We also have to check for shadowed space
         * and mempool fill grade */
    }
}

The logfs_get_wblocks() function takes a mutex_lock and calls for GC.

GC code does a memory allocations using GFP flag GFP_KERNEL

kswap is wokenup to free the pages

logfs_writepage() address_space_operations is called.

Which again tries to take the same lock and hence the deadlock.

Following small patch would fix the problem.

Signed-off-by: Prasad Joshi <prasadjshi124@gmail.com>
---
diff --git a/fs/logfs/journal.c b/fs/logfs/journal.c
index f46ee8b..9da2970 100644
--- a/fs/logfs/journal.c
+++ b/fs/logfs/journal.c
@@ -828,7 +828,7 @@ void do_logfs_journal_wl_pass(struct super_block *sb)
                super->s_journal_seg[i] = segno;
                super->s_journal_ec[i] = ec;
                logfs_set_segment_reserved(sb, segno);
-               err = btree_insert32(head, segno, (void *)1, GFP_KERNEL);
+               err = btree_insert32(head, segno, (void *)1, GFP_NOFS);
                BUG_ON(err); /* mempool should prevent this */
                err = logfs_erase_segment(sb, segno, 1);
                BUG_ON(err); /* FIXME: remount-ro would be nicer */

Thanks and Regards,
Prasad
