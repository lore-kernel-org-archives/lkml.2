Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1J1IE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:04:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54377
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932085Ab1J1IEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:04:54 -0400
Date: Fri, 28 Oct 2011 04:04:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>,
        viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com
Subject: Re: [PATCH 12/13] vfs: count unlinked inodes
Message-ID: <20111028080445.GA10318@infradead.org>
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
 <1318430946-7091-13-git-send-email-miklos@szeredi.hu>
 <20111028060801.GA15345@infradead.org>
 <1319788433.13842.8.camel@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319788433.13842.8.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 09:53:53AM +0200, Miklos Szeredi wrote:
> On Fri, 2011-10-28 at 02:08 -0400, Christoph Hellwig wrote:
> > This one gets me a repeated spew of WARN_ONs during XFS log recover,
> > repeating the following pattern:
> 
> The assumption here is that set_nlink() is called with a non-zero count.
> The point of introducing set_nlink() was to verify this assumption,
> otherwise pending delete accounting will be screwed up.
> 
> If setting i_nlink to zero is not a bug in xfs we can do two things:
> 
>  1) do a conditional clear_nlink() in xfs_setup_inode() to document that
> nlink can indeed be zero
> 
>  2) remove the warning from set_nlink().  That may hide some cases where
> i_nlink was cleared without the intention of the filesystem but it will
> work just fine wrt. the pending delete accounting. 

I suspect 2 might be the better option.  The pattern we see here in
XFS is pretty typical for transactional filesytems - when we mount a
filesystem after an unclean shutdown we need to drop all inodes that
were open but unlinked when the system crashed, and that typically
means reading inodes from disk that have a zero i_nlink.  Maybe some
filesystems never instanciate a VFS inode for it, but I suspect many
do.

For XFS we will actually see it during regularly testing as we have
an ioctl that simulates a shutdown and can thus trigger log recovery
easily, while for others like ext4 you'd actually have to do a real
reset of your (physical or virtual) machine.

