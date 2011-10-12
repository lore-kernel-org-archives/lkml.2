Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1JLToF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:44:05 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:16462 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1JLToD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:44:03 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=1h8qd3w5pbyJS47frJc7V6h9QwwiBhgsQMy9mbCO+wA= c=1 sm=1
 a=qsvkKbLjTbcA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=ph9WmAjRBiTLtD7_lecA:9
 a=09wAv2yCzIBcrIkn0ckA:7 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 11/28] ext4: Calculate and verify inode checksums
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20111008075456.20506.47319.stgit@elm3c44.beaverton.ibm.com>
Date: Wed, 12 Oct 2011 12:45:01 -0700
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
Message-Id: <1CCC75F1-41BE-49E9-8A03-372FC76E0202@dilger.ca>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075456.20506.47319.stgit@elm3c44.beaverton.ibm.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-08, at 12:54 AM, Darrick J. Wong wrote:
> This patch introduces to ext4 the ability to calculate and verify inode
> checksums.  This requires the use of a new ro compatibility flag and some
> accompanying e2fsprogs patches to provide the relevant features in tune2fs and
> e2fsck.
> 
> +static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
> +			      struct ext4_inode_info *ei)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +	__u16 crc_lo;
> +	__u16 crc_hi = 0;
> +	__u32 crc;
> +
> +	crc_lo = raw->i_checksum_lo;
> +	raw->i_checksum_lo = 0;
> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
> +		crc_hi = raw->i_checksum_hi;
> +		raw->i_checksum_hi = 0;
> +	}
> +
> +	crc = ext4_chksum(sbi, ei->i_uuid_inum_crc, (__u8 *)raw,
> +			  EXT4_INODE_SIZE(inode->i_sb));
> +
> +	raw->i_checksum_lo = crc_lo;
> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
> +		raw->i_checksum_hi = crc_hi;
> +
> +	return crc;
> +}

This computes both the _lo and _hi parts of the checksum and overwrites what is in the inode...

> +static int ext4_inode_csum_verify(struct inode *inode, struct ext4_inode *raw,
> +				  struct ext4_inode_info *ei)
> +{
> +	__u32 provided, calculated;
> +
> +	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> +	    cpu_to_le32(EXT4_OS_LINUX) ||
> +	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +		return 1;
> +
> +	provided = le16_to_cpu(raw->i_checksum_lo);
> +	calculated = ext4_inode_csum(inode, raw, ei);

This only saves the _lo part of the checksum before computing the new
checksum (which overwrites both _lo and _hi fields), so the _hi part
of the checksum is never properly validated below.

> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
> +		provided |= ((__u32)le16_to_cpu(raw->i_checksum_hi)) << 16;

This should be moved up to save _hi before calling ext4_inode_csum().

> +	else
> +		calculated &= 0xFFFF;
> +
> +	return provided == calculated;
> +}

> +static void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw,
> +				struct ext4_inode_info *ei)
> +{
> +	__u32 crc;
> +
> +	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> +	    cpu_to_le32(EXT4_OS_LINUX) ||
> +	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +		return;
> +
> +	crc = ext4_inode_csum(inode, raw, ei);
> +	raw->i_checksum_lo = cpu_to_le16(crc & 0xFFFF);
> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
> +		raw->i_checksum_hi = cpu_to_le16(crc >> 16);

What is the point of storing the returned crc into raw->i_checksum_lo
and raw->i_checksum_hi, if this is done internal to ext4_inode_csum()
already?

Also, would it be better to call the temporary variable "csum" instead
of "crc", since we may use something other than crc32c as the hash
function in the future.

Cheers, Andreas





