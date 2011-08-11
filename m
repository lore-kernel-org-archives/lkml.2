Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1HKVmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:42:01 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50010 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1HKVmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:42:00 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=n2W5COKzyCYKBlY96L0A3my6r0xTlngINTUh0kppeyk= c=1 sm=1
 a=y8pEDVWXUOsA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=oITwzJHm7LvCvV+zlaC6mA==:17 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=sPXDaBvKt7CecgPrsMgA:9 a=Q7txTkVjtaNhJU8iUYEA:7 a=CjuIK1q_8ugA:10
 a=x8gzFH9gYPwA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH] ext4: ext4_dx_add_entry should dirty directory metadata with the directory inode
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20110811211513.GL20655@tux1.beaverton.ibm.com>
Date: Thu, 11 Aug 2011 15:41:59 -0600
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <ED0259FB-A818-4CAA-A72A-9164CE3769D9@dilger.ca>
References: <20110811211513.GL20655@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-11, at 3:15 PM, Darrick J. Wong wrote:
> ext4_dx_add_entry manipulates bh2 and frames[0].bh, which are two buffer_heads
> that point to directory blocks assigned to the directory inode.  However, the
> function calls ext4_handle_dirty_metadata with the inode of the file that's
> being added to the directory, not the directory inode itself.  Therefore,
> correct the code to dirty the directory buffers with the directory inode, not
> the file inode.

Interesting.  For journaled filesystems this is purely cosmetic, since
"handle" is valid and "inode" is unused in that case.  For non-journal
filesystems it actually affects the correctness, since this buffer may
not be sync'd to disk even when the directory is marked "dirsync".

You can add my:
Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
> fs/ext4/namei.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index b754b77..79ddc43 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1589,7 +1589,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> 			dxtrace(dx_show_index("node", frames[1].entries));
> 			dxtrace(dx_show_index("node",
> 			       ((struct dx_node *) bh2->b_data)->entries));
> -			err = ext4_handle_dirty_metadata(handle, inode, bh2);
> +			err = ext4_handle_dirty_metadata(handle, dir, bh2);
> 			if (err)
> 				goto journal_error;
> 			brelse (bh2);
> @@ -1615,7 +1615,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> 			if (err)
> 				goto journal_error;
> 		}
> -		err = ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
> +		err = ext4_handle_dirty_metadata(handle, dir, frames[0].bh);
> 		if (err) {
> 			ext4_std_error(inode->i_sb, err);
> 			goto cleanup;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





