Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1DHJOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:14:08 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:19457 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab1DHJOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:14:05 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=Mj7okGGiyvljez8nourwAOSCyIXzraNcHEi86Qy5a+Y= c=1 sm=1
 a=6SPQ8XvcNloA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VnNF1IyMAAAA:8 a=7ShLblrI4llmLPCrN4oA:9
 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 2/2] e2fsprogs: Add support for toggling, verifying, and	fixing inode checksums
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20110406224733.GU32706@tux1.beaverton.ibm.com>
Date: Fri, 8 Apr 2011 03:14:04 -0600
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A63BE624-6F88-432C-A029-C7A0DF6C2894@dilger.ca>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224733.GU32706@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-06, at 4:47 PM, Darrick J. Wong wrote:
> This patch adds to tune2fs the ability to toggle the inode checksum rocompat
> feature flag, to e2fsck the ability to verify and correct inode checksums, and
> to debugfs the ability to dump inode checksums.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> @@ -729,6 +729,13 @@ void e2fsck_pass1(e2fsck_t ctx)
> +		/* Check for invalid inode checksum */
> +		if (!ext2fs_inode_csum_verify(fs, ino,
> +			(struct ext2_inode_large *)inode) &&
> +		    fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
> +			e2fsck_write_inode_full(ctx, ino, inode,
> +				sizeof(struct ext2_inode_large), "pass1");

If we just correct the checksum when it is found to be incorrect, then there is relatively little benefit in having it at all?  The default action in this case would likely be to declare the inode invalid and clears it, but there also needs to be a fallback option that declares the only checksum invalid and corrects it. 

Do you have an e2fsck testcase for this code, to show that it detects/fixes inodes with data corruption, and to fix the checksums after the ROCOMPAT flag is set the first time?

With the "ibadness" patch in our tree, the bad checksum should be a significant factor in marking the inode as garbage, but possibly not enough to have it thrown out if there are no other errors in the inode.

> @@ -890,6 +890,11 @@ static struct e2fsck_problem problem_table[] = {
> 	     "(size %Is, lblk %r)\n"),
> 	  PROMPT_CLEAR, PR_PREEN_OK },
> 
> +	/* Fast symlink has EXTENTS_FL set */
> +	{ PR_1_INODE_CSUM_INVALID,
> +	  N_("inode %i checksum invalid.  "),

The comment for each problem should exactly mirror the text that is printed.  In this case, you haven't used the abbreviations "@i" and "@n", which would normally make it much harder to search for this error string in the code, but also simplifies the translation of the message.


Cheers, Andreas





