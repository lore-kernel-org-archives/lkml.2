Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab2JLPtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:49:16 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42275 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab2JLPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:49:15 -0400
Message-ID: <1350056946.2299.82.camel@kjgkr>
Subject: Re: [PATCH 05/16] f2fs: add checkpoint operations
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sat, 13 Oct 2012 00:49:06 +0900
In-Reply-To: <20121011092412.2576f1f0@notabene.brown>
References: <000c01cda2f0$dfb82350$9f2869f0$%kim@samsung.com>
	 <20121011092412.2576f1f0@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-11 (목), 09:24 +1100, NeilBrown:
> On Fri, 05 Oct 2012 20:59:29 +0900 김재극 <jaegeuk.kim@samsung.com> wrote:
> 
> > +static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> > +{
> > +	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
> > +	nid_t last_nid = 0;
> > +	int nat_upd_blkoff[3];
> > +	block_t start_blk;
> > +	struct page *cp_page;
> > +	unsigned int data_sum_blocks, orphan_blocks;
> > +	void *kaddr;
> > +	__u32 crc32 = 0;
> > +	int i;
> > +
> > +	/* Flush all the NAT/SIT pages */
> > +	while (get_pages(sbi, F2FS_DIRTY_META))
> > +		sync_meta_pages(sbi, META, LONG_MAX);
> > +
> > +	next_free_nid(sbi, &last_nid);
> > +
> > +	/*
> > +	 * modify checkpoint
> > +	 * version number is already updated
> > +	 */
> > +	ckpt->elapsed_time = cpu_to_le64(get_mtime(sbi));
> > +	ckpt->valid_block_count = cpu_to_le64(valid_user_blocks(sbi));
> > +	ckpt->free_segment_count = cpu_to_le32(free_segments(sbi));
> > +	for (i = 0; i < 3; i++) {
> > +		ckpt->cur_node_segno[i] =
> > +			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_NODE));
> > +		ckpt->cur_node_blkoff[i] =
> > +			cpu_to_le16(curseg_blkoff(sbi, i + CURSEG_HOT_NODE));
> > +		nat_upd_blkoff[i] = NM_I(sbi)->nat_upd_blkoff[i];
> > +		ckpt->nat_upd_blkoff[i] = cpu_to_le16(nat_upd_blkoff[i]);
> > +		ckpt->alloc_type[i + CURSEG_HOT_NODE] =
> > +				curseg_alloc_type(sbi, i + CURSEG_HOT_NODE);
> > +	}
> > +	for (i = 0; i < 3; i++) {
> > +		ckpt->cur_data_segno[i] =
> > +			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_DATA));
> > +		ckpt->cur_data_blkoff[i] =
> > +			cpu_to_le16(curseg_blkoff(sbi, i + CURSEG_HOT_DATA));
> > +		ckpt->alloc_type[i + CURSEG_HOT_DATA] =
> > +				curseg_alloc_type(sbi, i + CURSEG_HOT_DATA);
> > +	}
> > +
> > +	ckpt->valid_node_count = cpu_to_le32(valid_node_count(sbi));
> > +	ckpt->valid_inode_count = cpu_to_le32(valid_inode_count(sbi));
> > +	ckpt->next_free_nid = cpu_to_le32(last_nid);
> > +
> > +	/* 2 cp  + n data seg summary + orphan inode blocks */
> > +	data_sum_blocks = npages_for_summary_flush(sbi);
> > +	if (data_sum_blocks < 3)
> > +		ckpt->ckpt_flags |= CP_COMPACT_SUM_FLAG;
> > +	else
> > +		ckpt->ckpt_flags &= (~CP_COMPACT_SUM_FLAG);
> > +
> > +	orphan_blocks = (sbi->n_orphans + F2FS_ORPHANS_PER_BLOCK - 1)
> > +					/ F2FS_ORPHANS_PER_BLOCK;
> > +	ckpt->cp_pack_start_sum = 1 + orphan_blocks;
> > +	ckpt->cp_pack_total_block_count = 2 + data_sum_blocks + orphan_blocks;
> 
> This looks a bit weird to me, though I might be misunderstanding something.
> 
> data_sum_blocks is either 1, 2, or 3.
> "3" actually means "at least 3".
> 
> If it is 3, you choose not to set CP_COMPACT_SUM_FLAG.  In that case the NAT
> and SIT journal entries go into SSA blocks, not into the checkpoint at all.
> So in that case, zero blocks of the checkpoint are used for journalling.  Yet
> you still add data_sum_blocks (==3) to the cp_pack_total_block_count (and
> later to the start block).
> Is that really what you want to do?  Leave 3 empty blocks?
> 
> I would suggest changing npages_for_summary_flush to return 0 if the number
> of blocks needed would be more than three, and set CP_COMPACT_SUM_FLAG only
> when data_sum_blocks > 0.
> 
> I don't know if you would need to make a corresponding change to the recovery
> code, I haven't fully examined that yet.

Ok, let me explain about CP_COMPACT_SUM_FLAG.
Let's assume that there are some journal entries and data summaries.
Note that this scenario is not from the umount procedure.

Basically f2fs writes three data summary blocks for current active logs
inside the checkpoint pack.
And NAT and SIT journal entries are stored in hot and cold data summary
blocks.
So, if the CP_COMPACT_SUM_FLAG is not set, f2fs writes the checkpoint
pack like this.

[CP 0]
[Orphan blocks]
[Hot sum block w/ NAT journal]
[Warm sum block]
[Cold sum block w/ SIT journal]
[CP 0']

But, if the CP_COMPACT_SUM_FLAG is set, the checkpoint pack consists of
1 or 2 summary blocks as follows.

[CP 0]
[Orphan blocks]
[summary entries w/ NAT and SIT journal]
[CP 0']

or,

[CP 0]
[Orphan blocks]
[summary entries]
[summary entries w/ NAT and SIT journal]
[CP 0']

So, I think it needs no change.
Any idea?
Thanks,

> 
> Regards,
> NeilBrown

-- 
Jaegeuk Kim
Samsung

