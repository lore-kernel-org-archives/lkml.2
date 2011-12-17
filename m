Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1LQWKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:10:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42348 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1LQWKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:10:38 -0500
Date: Sat, 17 Dec 2011 22:10:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] mm: add missing mutex lock arround notify_change
Message-ID: <20111217221028.GZ2203@ZenIV.linux.org.uk>
References: <20111216112534.GA13147@dztty>
 <20111216125556.db2bf308.akpm@linux-foundation.org>
 <20111217214137.GY2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111217214137.GY2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 09:41:37PM +0000, Al Viro wrote:

> xfs and ext4_ioctl() need to be fixed; XFS fix follows, ext4 I'd rather left
> to ext4 folks - I don't know how wide an area needs i_mutex there

Oh, for fsck sake...  People, this is *obviously* broken - if nothing else,
removing suid after modifying the file contents is too late.  Moreover,
this mext_inode_double_lock() thing is asking for trouble; it's deadlock-free
only because nothing else takes i_mutex on more than one non-directory inode
and does that as the innermost lock.  Start calling it for directories
(or have somebody cut'n'paste it and use it for directories) and you've got
a nice, shiny deadlock...  BTW, is ordering really needed in
double_down_write_data_sem()?  IOW, can we get contention between several
callers of that thing?

>From my reading of that code, all call chains leading to this sucker
are guaranteed to already hold i_mutex on both inodes.  If that is true,
we don't need any ordering in double_down_write_data_sem() at all...

AFAICS, the minimal fix is to move file_remove_suid() call into
ext4_move_extents(), just after we have acquired i_mutex in there.
Moreover, I think it should be done to *both* files, since both have
contents modified.  And I see no point in making that conditional...
