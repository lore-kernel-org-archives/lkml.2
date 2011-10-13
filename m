Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab1JMAB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:01:59 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:58453 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1JMAB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:01:58 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=c/XFevczzUoebyvqT+jDkQbuJdAAxuTGoZVbuGUMSf4= c=1 sm=1
 a=qsvkKbLjTbcA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=7t10-nLfGsLTCGAjBi8A:9 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 11/28] ext4: Calculate and verify inode checksums
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20111012210342.GO12447@tux1.beaverton.ibm.com>
Date: Wed, 12 Oct 2011 18:02:21 -0600
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
Message-Id: <ADB8AAAD-4422-4FD1-99BF-3E2A15C80BBB@dilger.ca>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075456.20506.47319.stgit@elm3c44.beaverton.ibm.com> <1CCC75F1-41BE-49E9-8A03-372FC76E0202@dilger.ca> <20111012210342.GO12447@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-12, at 3:03 PM, Darrick J. Wong wrote:
> On Wed, Oct 12, 2011 at 12:45:01PM -0700, Andreas Dilger wrote:
>>> +static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
>>> +			      struct ext4_inode_info *ei)
>>> +{
>>> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>>> +	__u16 crc_lo;
>>> +	__u16 crc_hi = 0;
>>> +	__u32 crc;
>>> +
>>> +	crc_lo = raw->i_checksum_lo;
>>> +	raw->i_checksum_lo = 0;
>>> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
>>> +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
>>> +		crc_hi = raw->i_checksum_hi;
>>> +		raw->i_checksum_hi = 0;
>>> +	}
>>> +
>>> +	crc = ext4_chksum(sbi, ei->i_uuid_inum_crc, (__u8 *)raw,
>>> +			  EXT4_INODE_SIZE(inode->i_sb));
>>> +
>>> +	raw->i_checksum_lo = crc_lo;
>>> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
>>> +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
>>> +		raw->i_checksum_hi = crc_hi;
>>> +
>>> +	return crc;
>>> +}
>> 
>> This computes both the _lo and _hi parts of the checksum and overwrites
>> what is in the inode...
> 
> I don't follow your logic ... for the _lo component, first I save the old
> i_checksum_lo contents in crc_lo.  Then I stuff zero into i_checksum_lo.
> Next I perform the checksum computation (with the checksum field
> effectively "zero") and put the results into crc.  Then I copy whatever
> I saved in crc_lo back into i_checksum_lo.
> 
> crc_lo, crc_hi, and crc are three separate variables, and neither crc_lo
> nor crc_hi are ever assigned any part of crc.  Therefore crc_lo and
> crc_hi should always contain the old checksum contents.
> 
> Did I miss something?  Afaict the contents of raw should be the same
> before and after the call to ext4_inode_csum(), but maybe I've been
> looking at this too long. :)

No, you are right.  I misread the code and thought that crc_lo and crc_hi
were derived from the computed value.

Cheers, Andreas





