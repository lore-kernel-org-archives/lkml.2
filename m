Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1GZTAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:00:03 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55691
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042Ab1GZS7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:59:55 -0400
Date: Tue, 26 Jul 2011 14:59:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Josef Bacik <josef@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PULL REQUEST] ext3, jbd, ext2, and quota fixes for 3.1-rc1
Message-ID: <20110726185920.GA2970@infradead.org>
References: <20110726181418.GA27993@quack.suse.cz>
 <CA+55aFwYsdyE4KxFW70c_FfTb41m+EwchYvNJU-eUEw4usRkUw@mail.gmail.com>
 <20110726185220.GJ22133@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726185220.GJ22133@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 07:52:20PM +0100, Al Viro wrote:
> Note that dentry obviously can't be NULL there.  dentry->d_parent is never
> NULL.  And dentry->d_parent would better not be negative, for crying out
> loud!  What's worse, there's no guarantees that dentry->d_parent will
> remain our parent over that sync_mapping_buffers() *and* that inode won't
> just be freed under us (after rename() and memory pressure leading to
> eviction of what used to be our dentry->d_parent).  Moreover, even if
> inode survives in icache, there is no promise that it will have an alias
> in dcache by the time we get to the next iteration of the loop, so this
> list_entry() next time around can bloody well happen to &inode->i_dentry,
> dentry being a garbage address somewhere inside that struct inode (or a
> bit above it - I hadn't compared offsets).

In addition to beeing bogus the code also is useless.  fsync on a file
explicitly does not guarantee anything at all about the parent, and
never really has on Linux either.

