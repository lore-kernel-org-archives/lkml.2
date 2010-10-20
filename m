Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0JTDx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:53:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56744 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab0JTDx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:53:26 -0400
Date: Wed, 20 Oct 2010 04:53:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 4/6] IMA: only allocate iint when needed
Message-ID: <20101020035324.GX19804@ZenIV.linux.org.uk>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
 <20101019225833.12396.56721.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019225833.12396.56721.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 06:58:33PM -0400, Eric Paris wrote:
> IMA always allocates an integrity structure to hold information about every
> inode, but only needed this structure to tract the number of readers and
> writers currently accessing a given inode.  Since that information was moved
> into struct inode instead of the integrity struct this patch stops allocating
> the integrity stucture until it is needed.  Thurs greatly reducing memory
> usage.

OK, I'm really confused.  Could you explain what's going on with refcounts
now?  AFAICS, you allocate them in process_measurement() now and they live
until the inode is torn down.  Fine by me.  However
	* why bother with bumping refcount in ima_file_free()?  It's not going
to die until we free the inode, for fsck sake...
	* i_mutex is a damn strange choice for protecting your write counter
	* for that matter, why bother with refcount at all?  What could
hold a reference to that sucker without holding a reference to struct inode?
I don't see anything of that sort, other that delayed freeing that'll hold
the only remaining pointer to iint until the callback where it'll promptly
drop it.

And while we are at it, you are forcing a hash lookup on _every_ _damn_
close(2) of a regular file.  How about marking the inode as ima-infested
so that it wouldn't bother?  For that matter, this "final writer" logics
needs explanation as well...
