Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab1I3VMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:12:06 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:53415 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab1I3VME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:12:04 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=1h8qd3w5pbyJS47frJc7V6h9QwwiBhgsQMy9mbCO+wA= c=1 sm=1
 a=4gQLNW1E5XQA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=F0RxiqfCAF7Mx5kjwKIA:9 a=f5njMB-5SVL2pY0qa6wA:7 a=CjuIK1q_8ugA:10
 a=x8gzFH9gYPwA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH] ext4: Fix comparison endianness problem in MMP initialization
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20110930194900.GY12086@tux1.beaverton.ibm.com>
Date: Fri, 30 Sep 2011 15:12:02 -0600
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <37339E8E-181A-4245-86BD-64EE47A54926@dilger.ca>
References: <20110930194900.GY12086@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-30, at 1:49 PM, Darrick J. Wong wrote:
> As part of startup, the MMP initialization code does this:
> 
> mmp->mmp_seq = seq = cpu_to_le32(mmp_new_seq());
> 
> Next, mmp->mmp_seq is written out to disk, a delay happens, and then
> the MMP block is read back in and the sequence value is tested:
> 
> if (seq != le32_to_cpu(mmp->mmp_seq)) {
> 	/* fail the mount */
> 
> On a LE system such as x86, the *le32* functions do nothing and this
> works.
> Unfortunately, on a BE system such as ppc64, this comparison becomes:
> 
> if (cpu_to_le32(new_seq) != le32_to_cpu(cpu_to_le32(new_seq)) {
> 	/* fail the mount */
> 
> Except for a few palindromic sequence numbers, this test always causes
> the mount to fail, which makes MMP filesystems generally unmountable
> on ppc64.  The attached patch fixes this situation.
> 
> (This fix came up while testing the metadata checksumming patchset)

Thanks also for the catch, you are completely right.  We've never run
this code on a big-endian system in all the years we had it.

> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
> fs/ext4/mmp.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 9bdef3f..a7a4986 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -295,7 +295,8 @@ skip:
> 	/*
> 	 * write a new random sequence number.
> 	 */
> -	mmp->mmp_seq = seq = cpu_to_le32(mmp_new_seq());
> +	seq = mmp_new_seq();
> +	mmp->mmp_seq = cpu_to_le32(seq);
> 
> 	retval = write_mmp_block(bh);
> 	if (retval)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





