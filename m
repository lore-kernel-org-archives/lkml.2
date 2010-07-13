Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0GMSg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:36:59 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:7330 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0GMSg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:36:57 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=WOutPEdcbCgA:10 a=1CvaPgNKC-EA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=w8LdrSwyXEh_Tlm2u5cA:9
 a=-7QN37LdeZ8Z8klIZvQAuNVW9EYA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH] ext2: return -ENODATA for NULL i_file_acl in ext2_xattr_list
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4C3C7E59.8040905@gmail.com>
Date: Tue, 13 Jul 2010 12:36:54 -0600
Cc: kernel-janitors <kernel-janitors@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7D4617C2-565E-4F34-94B4-3F308EB75D18@dilger.ca>
References: <4C3C7E59.8040905@gmail.com>
To: Wang Sheng-Hui <crosslonelyover@gmail.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-13, at 08:55, Wang Sheng-Hui wrote:
> In ext2_xattr_list, if (!EXT2_I(inode)->i_file_acl)
> is true, we should return -ENODATA instead of 0.
> 
> @@ -263,7 +263,7 @@ ext2_xattr_list(struct dentry *dentry, char *buffer,
>          size_t buffer_size)
> 
>          down_read(&EXT2_I(inode)->xattr_sem);
> -        error = 0;
> +        error = -ENODATA;
>          if (!EXT2_I(inode)->i_file_acl)
>                  goto cleanup;
>          ea_idebug(inode, "reading block %d", EXT2_I(inode)->i_file_acl);

The "error" value gets overwritten almost immediately with -EIO, and then at the end of the function if there is an xattr block but it doesn't contain any attributes (I'm not sure if this could happen, but it seems possible) it will return "error = buffer_size - rest;  /* total size */", so 0 if "rest" was not changed from its initial value of buffer_size.

The question is why this return value should be changed to -ENODATA in the first place?  This isn't true for ext3_xattr_list() or ext4_xattr_list().  I tend to think it is not an error to get back an empty list, and applications shouldn't treat it as such.  Most applications will check "if (rc < 0)" and treat it as an error.  This is different than e.g. requesting a specific value by name (which does return -ENODATA) because it would otherwise be ambiguous whether the xattr existed but had zero size or didn't exist at all.

Cheers, Andreas





