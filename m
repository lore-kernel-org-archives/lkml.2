Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1LILsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:48:03 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57759
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab1LILsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:48:00 -0500
Date: Fri, 9 Dec 2011 06:47:45 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Kamal Mostafa <kamal@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Matthew Wilcox <matthew@wil.cx>, Randy Dunlap <rdunlap@xenotime.net>,
        Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
        Valerie Aurora <val@vaaconsulting.com>,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 3/5 resend] VFS: Fix s_umount thaw/write deadlock
Message-ID: <20111209114745.GA7543@infradead.org>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>
 <1323118489-16326-4-git-send-email-kamal@canonical.com>
 <20111206113544.GA21589@infradead.org>
 <20111207231658.GQ4622@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207231658.GQ4622@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 12:16:58AM +0100, Jan Kara wrote:
> > We make sure to not dirty any new inodes after the first phase of the
> > freeze, so this should be a BUG_ON/WARN_ON.
>   This is not really true in presence of mmaped writes. To block mmaped
> writes on a frozen filesystem, we need some synchronization between
> page_mkwrite() and freezing code. Currently, to avoid any additional
> locking overhead, we set page dirty and *then* check for filesystem being
> frozen. Only this order can make sure either the page is written (and
> write-protected) or the frozen check triggers and we wait... (see the
> comment in block_page_mkwrite()). The nasty sideeffect of this is that
> there can be dirty pages & inodes on a frozen filesystem. We are blocked in
> the page fault of these pages so user cannot write any data to these pages
> but still they are marked dirty.
> 
> Alternatively we could have a different mechanism (rw semaphore?) to
> synchronize page faults and freezing but I'd hate the overhead for the case
> almost noone cares about...

I think the is the only sensible way to go forward.  Requiring hacks in
lots of random places to work around the fact that a single place that
might actually dirty pages despite supposedly blocking that from happen
simply isn't maintainable over the long run.

> > > +	 */
> > > +	if (vfs_is_frozen(sb)) {
> > > +		ret = -EBUSY;
> > > +		goto out_drop_super;
> > > +	}
> > 
> > How about spending the three minutes to figure it out?
> > Q_GETFMT/Q_GETINFO/Q_XGETQSTAT and Q_GETQUOTA are the obvious read-only
> > candidates.
>   Q_GETQUOTA can actually cause filesystem modification (reservation of
> space in quota file) but the others are read-only. Also after some thought
> I'd prefer that quotactl(8) just blocks to be consistent with how other
> syscalls behave...

How can a simple dqget cause modifications in the VFS quota code?
Dirting anything for a simple read of the quota information is not
only completely non-obvious but also doesn't make much sene.  We don't
dirty metadata on stat() either..

