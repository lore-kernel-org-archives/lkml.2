Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab0GUNb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:31:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50381 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab0GUNbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:31:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Cc: kosaki.motohiro@jp.fujitsu.com, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4C401CE3.7010004@cn.fujitsu.com>
References: <4C401CE3.7010004@cn.fujitsu.com>
Message-Id: <20100721222508.8704.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 21 Jul 2010 22:31:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

> create file: file_108.dat
> # sync
> (panic)
> 
> 
> Seems ac->ac_inode can be NULL:
> 
> DECLARE_EVENT_CLASS(ext4__mballoc,
> 	...
>         TP_fast_assign(
>                 __entry->dev            = ac->ac_inode->i_sb->s_dev;
>                 __entry->ino            = ac->ac_inode->i_ino;
> 		...
>         ),
> 	...
> );

Can you teach us proper tracepint writing way?


ext4_mb_release_group_pa() has a concern when ac is NULL.

============================================================
static noinline_for_stack int
ext4_mb_release_group_pa(struct ext4_buddy *e4b,
                                struct ext4_prealloc_space *pa,
                                struct ext4_allocation_context *ac)
{
        struct super_block *sb = e4b->bd_sb;
        ext4_group_t group;
        ext4_grpblk_t bit;

        trace_ext4_mb_release_group_pa(ac, pa);
        BUG_ON(pa->pa_deleted == 0);
        ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
        BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
        mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
        atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);

        if (ac) {                // here
                ac->ac_sb = sb;
                ac->ac_inode = NULL;
                ac->ac_b_ex.fe_group = group;
                ac->ac_b_ex.fe_start = bit;
                ac->ac_b_ex.fe_len = pa->pa_len;
                ac->ac_b_ex.fe_logical = 0;
                trace_ext4_mballoc_discard(ac);
        }

        return 0;
}
===================================================

but trace_ext4_mb_release_group_pa() doesn't care it.
=====================================================
TRACE_EVENT(ext4_mb_release_group_pa,
        TP_PROTO(struct ext4_allocation_context *ac,
                 struct ext4_prealloc_space *pa),

        TP_ARGS(ac, pa),

        TP_STRUCT__entry(
                __field(        dev_t,  dev                     )
                __field(        ino_t,  ino                     )
                __field(        __u64,  pa_pstart               )
                __field(        __u32,  pa_len                  )

        ),

        TP_fast_assign(
                __entry->dev            = ac->ac_sb->s_dev;
                __entry->ino            = ac->ac_inode->i_ino;
                __entry->pa_pstart      = pa->pa_pstart;
                __entry->pa_len         = pa->pa_len;
        ),

        TP_printk("dev %s pstart %llu len %u",
                  jbd2_dev_to_name(__entry->dev), __entry->pa_pstart, __entry->pa_len)
);
=====================================================

So, adding following branch should fix this issue.

        if (ac)
	        trace_ext4_mb_release_group_pa(ac, pa);

But, I don't think this is proper fix because we don't want any overhead
if the tracepoint is disabled.

So, How do we check NULL in TP_fast_assign()?

Thanks.


