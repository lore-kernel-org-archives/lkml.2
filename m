Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab1LEQdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:33:45 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:38829 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499Ab1LEQdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:33:43 -0500
Date: Mon, 5 Dec 2011 11:33:29 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 07/22] ext4: Create bitmap checksum helper functions
Message-ID: <20111205163329.GC32031@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
 <20111128232703.19194.55084.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128232703.19194.55084.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:27:03PM -0800, Darrick J. Wong wrote:
> +static __u32 ext4_bitmap_csum(struct super_block *sb, ext4_group_t group,
> +			      struct buffer_head *bh, int sz)
> +{
> +	__u32 csum;
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +
> +	group = cpu_to_le32(group);
> +	csum = ext4_chksum(sbi, sbi->s_uuid_csum, (__u8 *)&group,
> +			   sizeof(group));
> +	csum = ext4_chksum(sbi, csum, (__u8 *)bh->b_data, sz);
> +
> +	return csum;
> +}

Note: it's strictly speaking not necessary to mix in the group and
s_csum_seed here.  It's useful for the inode table blocks (ITB's)
because the checksum for a particular ITB is located *in* the ITB
itself.  So if an ITB gets written to the wrong place, and in
particular, on top of another ITB, we want to be able to know which
cloned copy was written to the wrong place on disk.

But in the case of the inode and block allocation bitmaps, the
checksums are stored in the block group descriptors; so if the bitmap
is written to the wrong place (and on top of another bitmap), the
checksum will fail to verify, independent of whether we've mixed in
the fs-specific csum seed and the group number.

So I'd suggest dropping this, which will shave a few cycles off of the
checksum calculation, and it will also simplify the code since we
won't need this particular function.

						- Ted
