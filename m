Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab1D0SdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:33:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46279 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1D0SdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:33:10 -0400
Date: Wed, 27 Apr 2011 12:33:08 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Mike Frysinger <vapier@gentoo.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Message-ID: <20110427183308.GA16716@parisc-linux.org>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 08:13:47PM +0200, Andrea Righi wrote:
> @@ -127,6 +128,12 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>  			invalidate_mapping_pages(mapping, start_index,
>  						end_index);
>  		break;
> +	case POSIX_FADV_DONTNEED_FS:
> +		if (capable(CAP_SYS_ADMIN))
> +			drop_pagecache_sb(file->f_dentry->d_sb, NULL);
> +		else
> +			ret = -EPERM;
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}

Mmm ... what if I open /dev/sdxyz and call fadvise() on it?  I think
you end up flushing /dev's page cache entries, instead of the filesystem
which is on /dev/sdxyz.

If I understand correctly, you want mapping->host->i_sb instead of
file->f_dentry->d_sb.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
