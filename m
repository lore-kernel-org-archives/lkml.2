Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1KULeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:34:22 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39679
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab1KULeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:34:20 -0500
Date: Mon, 21 Nov 2011 06:34:16 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: Re: [PATCH 3/4] vfs: count unlinked inodes
Message-ID: <20111121113416.GA18087@infradead.org>
References: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
 <1321873893-4544-4-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321873893-4544-4-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 12:11:32PM +0100, Miklos Szeredi wrote:
> Do not WARN_ON if set_nlink is called with zero count, just do a
> ratelimited printk.  This happens on xfs and probably other
> filesystems after an unclean shutdown when the filesystem reads inodes
> which already have zero i_nlink.  Reported by Christoph Hellwig.

Given that this is part of the normal recovery process printing anything
seems like a bad idea.  I also don't think the code for this actually
is correct.

Remember when a filesystem recovery from unlinked but open inodes the
following happens:

 - we walk the list of unlinked but open inodes, and read them into
   memory, remove the linkage and then iput it.

With the current code that won't ever increment s_remove_count, but
decrement it from __destroy_inode.  I suspect the right fix is to
simply not warn for a set_nlink to zero, but rather simply increment
s_remove_count for that case.

