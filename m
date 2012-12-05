Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2LEMq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:46:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab2LEMqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:46:49 -0500
Date: Wed, 5 Dec 2012 13:46:44 +0100
From: chrubis@suse.cz
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Partialy mapped page stays in page cache after unmap
Message-ID: <20121205124644.GA8938@rei.nue.novell.com>
References: <20121030182420.GA17171@rei.Home>
 <50BC462E.1080200@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BC462E.1080200@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> I've seen the LTP open posix mmap/{11-4,11-5} issues in the past myself
> and was something I wanted to discuss on the lists myself. Thanks for
> bringing this up.
> 
> Jut to reiterate: the expectations are
> 
> 1. zero filling of unmapped (trailing) partial page
> 2. NO Writeout (to disk) of trailing partial page.
> 
> #1 is broken as your latter test case proves. We can have an alternate
> test case which starts with non empty file (preloaded with all 'a's),
> mmap partial page and then read out the trailing partial page, it will
> not be zeroes (it's probably ftruncate which does the trick in first place).
> 
> Regarding #2 - I did verify that msync indeed makes it pass - but I'm
> confused why. After all it is going to commit the buffer  with 'b' to
> on-disk - so a subsequent mmap is bound to see the update to file and
> hence would make the test fail. What am  I missing here ?

I've been researching that issue for quite some time and found this:

Once the partial page gets loaded into the page cache it stays there
till it's flushed back to the disk. There is no information about the
length of the data in that page in the page cache. The page is zeroed at
the time it's loaded into the cache but once you dirty the the content
it's not zeroed until it's flushed back to the disk it just stays in the
cache as it is and any subsequent mappings will just pick this page. The
page is not written back untill it's forced to leave the cache (which is
not after the the mapping has been destroyed or the process has exited)
which is the reason why msync() makes the test succeed.

In my opinion this behavior is not 100% POSIXly correct, on the other
hand I find it quite reasonable, making the mmap() see zeroed page at
any mapping would only waste memory (I can't see any other solution than
duplicating the last page for any new mmap).

Also note that the msync() doesn't work for shm as the shm filesystem
msycn is no-operation one (as the data doesn't have to be synced
anywhere).


I've send a patch to the linux man pages with similar description:

http://marc.info/?l=linux-man&m=135271969606543&w=2


Hope this clarifies the issue.

-- 
Cyril Hrubis
chrubis@suse.cz
