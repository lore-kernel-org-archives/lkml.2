Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1JLTvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:51:32 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:58485 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1JLTvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:51:31 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=pLwgVNw+rP0xDC1aTytTpk3qcVwaN6U+yFunLg8qx5U= c=1 sm=1
 a=hjn-XhmR8WgA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=ER5QqjZEPBzZUJsz4XgA:9
 a=ZHthwnYiLfOK6OglnmEA:7 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 12/28] ext4: Use i_generation in inode-related metadata checksums
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20111008075502.20506.15728.stgit@elm3c44.beaverton.ibm.com>
Date: Wed, 12 Oct 2011 12:52:30 -0700
Cc: Theodore Tso <tytso@mit.edu>, Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <BFA9D351-575B-4B48-B5D8-D01DF5317A7C@dilger.ca>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075502.20506.15728.stgit@elm3c44.beaverton.ibm.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-08, at 12:55 AM, Darrick J. Wong wrote:
> Whenever we are calculating a checksum for a piece of metadata that is
> associated with an inode, incorporate i_generation into that calculation
> so that old metadata blocks cannot be re-associated after a delete/create cycle.

It would be better to fold this into the previous patch, since it will
otherwise cause the inode checksum algorithm to change in the middle of the patch series.

On a related note, in ext4_new_inode() it would be useful to change the
setting of i_generation so that it skips i_generation == 0, which doesn't
contribute to the checksum:

        spin_lock(&sbi->s_next_gen_lock);
        inode->i_generation = sbi->s_next_generation++;
+	if (unlikely(inode->i_generation == 0))
+	        inode->i_generation = sbi->s_next_generation++;
        spin_unlock(&sbi->s_next_gen_lock);

> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 6e5876a..d4b59e9 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1031,11 +1031,14 @@ got:
> 	/* Precompute second piece of crc */
> 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> +		__u32 crc;
> 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> 		__le32 inum = cpu_to_le32(inode->i_ino);
> -		ei->i_uuid_inum_crc = ext4_chksum(sbi, sbi->s_uuid_crc,
> -						  (__u8 *)&inum,
> -						  sizeof(inum));
> +		__le32 gen = cpu_to_le32(inode->i_generation);
> +		crc = ext4_chksum(sbi, sbi->s_uuid_crc, (__u8 *)&inum,
> +				  sizeof(inum));
> +		ei->i_uuid_inum_crc = ext4_chksum(sbi, crc, (__u8 *)&gen,
> +						  sizeof(gen));
> 	}
> 
> 	ext4_clear_state_flags(ei); /* Only relevant on 32-bit archs */
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index f18bfe3..fdf0b1e 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -149,6 +149,10 @@ flags_out:
> 		if (!inode_owner_or_capable(inode))
> 			return -EPERM;
> 
> +		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +			return -ENOTTY;

This should get an ext4_warning() in the non-checksum case to warn
users that this ioctl is deprecated and will be removed in the
future unless there is a good reason to keep it.

Cheers, Andreas





