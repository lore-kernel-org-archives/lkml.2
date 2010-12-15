Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0LOMxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 07:53:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34183 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab0LOMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 07:53:20 -0500
Date: Wed, 15 Dec 2010 12:53:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 1/2] fs: fix d_validate (again)
Message-ID: <20101215125315.GA4419@ZenIV.linux.org.uk>
References: <20101123102241.GA4317@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123102241.GA4317@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 09:22:41PM +1100, Nick Piggin wrote:
> Again, I'd like to please fix d_validate. It can be trivally fixed
> without delving into filesystem code, and it does not prevent the proper
> careful removal of d_validate and untrusted dentry caches from
> filesystems.
> 
> The right way to merge is fix the bugs in core code now, and remove it
> completely if and when filesystems stop using it. But it's no longer a
> liability or problem to maintain, so it can stay as long as it likes.

TBH, I would prefer to kill the damn thing completely.  Never liked it,
and I think I see how to get rid of it.

Look: what happens is that ncpfs reads the entire directory from server
and since it gets all metadata for free anyway, it creates all dentries
as it goes (assiging i_ino, etc.) and sticks references to them into
page cache for that directory.  readdir() goes through those pages and
as long as all dentries it sees are still alive (and pages still present),
it uses them.  If something's gone or the cache is old enough, we just
evict all those pages and reread.  If some dentries are around during
reread (or initial read, for that matter), we stick references to those
back into the repopulated page cache.

The order of entries matches that in the metadata we'd got from server.

OK.  So let's do that:
	* stick reference back into the page in dentry->d_fsdata (the current
uses are becoming obsolete with new scheme)
	* have d_iput() remove the reference to dentry from page under
spinlock
	* have page eviction remove the references from corresponding dentries
under the same spinlock
	* instead of d_validate() crap, grab the spinlock, lock dentry,
check if it's still alive and do dget_locked() on it if it is (and unlock,
of course).

Voila - d_validate() is no more.  IIRC, smbfs was essentially the same
as ncpfs in that respect.  Comments?
