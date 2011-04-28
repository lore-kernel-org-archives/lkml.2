Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab1D1Jft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:35:49 -0400
Received: from 67-20-127-205.bluehost.com ([67.20.127.205]:34233 "EHLO
	mail.betterlinuxtesting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab1D1Jfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:35:46 -0400
Date: Thu, 28 Apr 2011 11:29:01 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Mike Frysinger <vapier@gentoo.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Message-ID: <20110428092901.GA2517@linux.develer.com>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
 <20110427183308.GA16716@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427183308.GA16716@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 12:33:08PM -0600, Matthew Wilcox wrote:
> On Wed, Apr 27, 2011 at 08:13:47PM +0200, Andrea Righi wrote:
> > @@ -127,6 +128,12 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
> >  			invalidate_mapping_pages(mapping, start_index,
> >  						end_index);
> >  		break;
> > +	case POSIX_FADV_DONTNEED_FS:
> > +		if (capable(CAP_SYS_ADMIN))
> > +			drop_pagecache_sb(file->f_dentry->d_sb, NULL);
> > +		else
> > +			ret = -EPERM;
> > +		break;
> >  	default:
> >  		ret = -EINVAL;
> >  	}
> 
> Mmm ... what if I open /dev/sdxyz and call fadvise() on it?  I think
> you end up flushing /dev's page cache entries, instead of the filesystem
> which is on /dev/sdxyz.
> 
> If I understand correctly, you want mapping->host->i_sb instead of
> file->f_dentry->d_sb.

I did some tests, but I don't get the expected behaviour. In all cases
both if I use mapping->host->i_sb or file->f_dentry->d_sb when I call
fadvise() on any block device all the blockdev pages are dropped
("Buffers" from /proc/meminfo), but page cache pages are not touched:

# df -hT /
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda1     ext4     29G   20G  7.4G  73% /
# grep "^Cached\|Buffers" /proc/meminfo
Buffers:           79772 kB
Cached:            32440 kB
# sudo drop-pagecache /dev/sda1
# grep "^Cached\|Buffers" /proc/meminfo
Buffers:             228 kB
Cached:            32440 kB
# sudo drop-pagecache /
# grep "^Cached\|Buffers" /proc/meminfo
Buffers:             228 kB
Cached:             4884 kB

Thanks,
-Andrea
