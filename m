Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2GaJlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:41:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35528 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2GaJlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:41:24 -0400
Date: Tue, 31 Jul 2012 10:41:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [vfs:for-next] mnt_want_write: possible circular locking
 dependency detected
Message-ID: <20120731094121.GG6481@ZenIV.linux.org.uk>
References: <20120731082943.GB14475@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731082943.GB14475@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 04:29:43PM +0800, Fengguang Wu wrote:
> Hi Jan,
> 
> I caught the following warning at this commit. Note that the head
> commit actually boots OK, so it may either be not 100% reproduciable,
> or get fixed somewhere in your patchset.

In the next commit, actually.  I'm still not sure about that one -
is "just ignore atime updates on frozen fs" the right approach?

AFAICS, the situation looks so:
	* most of the callers can't hold ->i_mutex
	* main exception is vfs_readdir(); it's not hard to pull that
file_accessed() outside of ->i_mutex there.  The same goes for one 
of the similar bits in coda.
	* another sucker in coda (coda_venus_readdir()) is essentially
a false positive - we are holding ->i_mutex on a directory inode
in coda, end up reading from a regular file on normal fs and update
its atime.  Hell knows; looks more like an annotation problem for me,
even though I'm not sure how to deal with it cleanly.
	* hugetlbfs_file_mmap() just needs file_accessed() moved one line
up.
	* xfs_file_splice_read() doesn't hold ->i_mutex, but it does
hold some XFS lock; might or might not be a problem
	* really ugly one - read request on /dev/loop update atime of
underlying file.  They might bloody well happen from pagefault path,
etc., potentially while doing write(2) into the same file and holding
->i_mutex on it.  Hell knows what's the rigth semantics here...

