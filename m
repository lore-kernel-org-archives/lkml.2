Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1F3Lm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:42:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50500
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1F3Lmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:42:50 -0400
Date: Thu, 30 Jun 2011 07:42:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christoph Hellwig <hch@tuxera.com>, Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, roman@ardistech.com,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH 1/2] hfsplus: add error checking for hfs_find_init()
Message-ID: <20110630114242.GA9597@infradead.org>
References: <1308863702-30859-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308863702-30859-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 01:15:01AM +0400, Alexey Khoroshilov wrote:
> hfs_find_init() may fail with ENOMEM, but there are places, where
> the returned value is not checked. The consequences can be very
> unpleasant, e.g. kfree uninitialized pointer and
> inappropriate mutex unlocking.
> 
> The patch adds checks for errors in hfs_find_init().
> 
> Found by Linux Driver Verification project (linuxtesting.org).

What kind of testing did you do in detail?

> -	hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
> +	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
> +	if (err)
> +		goto err_init;
>  
>  	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
>  	entry_size = hfsplus_fill_cat_thread(sb, &entry,
> @@ -255,6 +257,7 @@ err1:
>  		hfs_brec_remove(&fd);
>  err2:
>  	hfs_find_exit(&fd);
> +err_init:

Please just return the error directly unless there's something to
unwind, both here and in other places.

> @@ -124,9 +124,10 @@ static void hfsplus_ext_write_extent_locked(struct inode *inode)
>  	if (HFSPLUS_I(inode)->extent_state & HFSPLUS_EXT_DIRTY) {
>  		struct hfs_find_data fd;
>  
> -		hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
> -		__hfsplus_ext_write_extent(inode, &fd);
> -		hfs_find_exit(&fd);
> +		if (!hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd)) {
> +			__hfsplus_ext_write_extent(inode, &fd);
> +			hfs_find_exit(&fd);
> +		}
>  	}
>  }

This one need to be propagated back through the callers.

> @@ -523,7 +528,11 @@ void hfsplus_file_truncate(struct inode *inode)
>  		goto out;
>  
>  	mutex_lock(&hip->extents_lock);
> -	hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
> +	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
> +	if (res) {
> +		mutex_unlock(&hip->extents_lock);
> +		return;
> +	}

At least add an XXX comment about the lack of error handling here.
Once hfsplus gets converted to the new truncate sequence we'll be
able to handle to return it.

