Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0FYIFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:05:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab0FYIFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:05:10 -0400
Date: Fri, 25 Jun 2010 18:05:00 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100625080500.GV10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100625071221.GA2397@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625071221.GA2397@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 03:12:21AM -0400, Christoph Hellwig wrote:
> If you actuall want to get this work in reposting huge patchkit again and
> again probably doesn't help.  Start to prioritize areas and work on small
> sets to get them ready.

Sure, I haven't been posting the same thing (haven't posted it for a
long time). This simply had a lot of new stuff and improvements to all
existing patches.

I didn't cc anyone in particular because it's only for interested
people to take a look at. As you saw last time I cc'ed Al I exactly
was just trying to get those easier targets merged.

 
> files_lock and vfsmount_lock seem like rather easy targets to start
> with.  But for files_lock I really want to see something to generalize
> the tty special case.  If you touch that are in detail that wart needs
> to go.  Al didn't seem to like my variant very much, so he might have
> a better idea for it - otherwise it really makes the VFS locking simple
> by removing any tty interaction with the superblock files list.

Actually I didn't like it because the error handling in the tty code
was broken and difficult to fix properly. The concept was OK though.

But the fact is that today already tty "knows" that vfs doesn't need its
files on the superblock list, and so it may take them off and use that
list_head privately. Currently it is also using files lock to protect
that private usage. These are two independent problems. My patch fixes
the second, and anything that fixes the first also needs to fix the
second in exactly the same way.


>  The
> other suggestion would be to only open regular (maybe even just
> writeable) files to the list.  In addition to reducing the number of
> list operations require it will also make the tty code a lot easier.

This was my suggestion, yes. Either way is conceptually the same, this
one just avoids the memory allocation and error handling problems that
yours had.

But again, locking change is still required and it would look exactly
the same as my patch really.

 
> As for the other patches:  I don't think the massive fine-grained
> locking in the hash tables is a good idea.  I would recommend to defer
> them for now, and then look into better data structures for these caches
> instead of working around the inherent problems of global hash tables.

I don't agree actually. I don't think there is any downside to fine
grained locking the hash with bit spinlocks. Until I see one, I will
keep them.

I agree that some other data structure may be better, but it should be
compared with the best possible hash implementation, which is a scalable
hash like this one.

Also, our big impending performance problem is SMP scalability, not hash
lookup, AFAIKS.

