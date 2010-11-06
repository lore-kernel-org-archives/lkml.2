Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0KFSQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:16:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0KFSQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:16:21 -0400
Date: Sat, 6 Nov 2010 14:16:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] udf: Replace bkl with a mutex for protect
 udf_sb_info struct
Message-ID: <20101106181617.GE13315@infradead.org>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
 <1289065631-2256-4-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289065631-2256-4-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		mutex_lock(&sbi->lock);
>  		result = udf_relocate_blocks(inode->i_sb,
>  						old_block, &new_block);
> +		mutex_unlock(&sbi->lock);

Moving the locking inside udf_relocate_blocks would be cleaner.

> @@ -570,7 +569,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
>  	if (!udf_parse_options(options, &uopt, true))
>  		return -EINVAL;
>  
> -	lock_kernel();
> +	mutex_lock(&sbi->lock);

What are you protecting against here?  Concurrent remount calls are
protects against by the VFS.  Is there any reader that takes sbi->lock
to get a consistent view of the various options?  It doesn't seem you
introduce one in this series, so it seems we could do fine without any
locking.

> -		unlock_kernel();
>  		return -ENOMEM;
>  	}
>  
> +	mutex_init(&sbi->lock);
> +	mutex_lock(&sbi->lock);

What are you locking against here?  I can't fine anything that puts the
superblock on a global list in fill_super, and I can't find any code
that would look a superblock up that's not fully set up.  I don't think
synchronization here in fill_super is needed at all.

> +	/* Serialize writer access, replace the old bkl */
> +	struct mutex lock;

Same comment as for the per-inode mutex applies here, too.

