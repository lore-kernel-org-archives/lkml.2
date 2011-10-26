Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab1JZIhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 04:37:09 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57505 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494Ab1JZIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 04:37:07 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=KBSlDmMtPy+6dcT8s2HSk+nEQXlV1wil9/JK38/4IYQ= c=1 sm=1
 a=OS1EL7NM7eYA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=F6sD_zJXVY99j29s-pcA:9
 a=vIrsmYPnDjjk1Th_fLIA:7 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH V1 02/17] ext4: Add the basic function for inline data support.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1319614468-11227-2-git-send-email-tm@tao.ma>
Date: Wed, 26 Oct 2011 02:36:56 -0600
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <E38E92E9-2937-47BA-A9F4-B1F75C9FDE4A@dilger.ca>
References: <4EA7B788.3040503@tao.ma> <1319614468-11227-1-git-send-email-tm@tao.ma> <1319614468-11227-2-git-send-email-tm@tao.ma>
To: Tao Ma <tm@tao.ma>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-26, at 1:34 AM, Tao Ma wrote:
> Implement inline data with xattr. This idea is inspired by Andreas.
> So now we use "system.data" to store xattr.  For inode_size = 256,
> currently we uses all the space between i_extra_isize and inode_size.
> For inode_size > 256, we use half of that space.
> 
> +#define EXT4_XATTR_SYSTEM_DATA_NAME		"data"

Did you check whether the "data" string takes 4 bytes or 8 in the
xattr header?  I believe it is storing the NUL termination (and
the code is using "sizeof(EXT4_XATTR_SYSTEM_DATA_NAME)" = 5), so
I believe it will round up to the next 4-byte boundary.  Using a
3-byte name will save a bit of space, like "system.dat".

> +void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
> +			    void *buffer, loff_t pos, unsigned len)
> +{
> +	header = IHDR(inode, ext4_raw_inode(iloc));
> +	entry = (struct ext4_xattr_entry *)((void *)ext4_raw_inode(iloc) +
> +					    EXT4_I(inode)->i_inline_off);
> +	memcpy((void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs) + pos,
> +	       buffer + pos, len);
> +}
> +
> +int ext4_init_inline_data(handle_t *handle, struct inode *inode,
> +			  struct ext4_iloc *iloc)
> +{
> +	size = ext4_get_max_inline_size(inode);
> +	value = kzalloc(size, GFP_NOFS);
> +	if (!value)
> +		return -ENOMEM;
> +
> +	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> +}

Since file data is changed very rarely, instead of consuming the full
xattr space that may not be needed, wouldn't it be better to change
ext4_write_inline_data() to just to the ext4_xattr_ibody_set() to save
the exact-sized buffer into the xattr?  That will allow other xattrs
to be stored in this space as well as the inline data.


Cheers, Andreas





