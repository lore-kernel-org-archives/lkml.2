Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0EGW5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:57:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab0EGW5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:57:33 -0400
Date: Fri, 7 May 2010 15:55:04 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data from compressed
 memory (v2)
Message-Id: <20100507155504.10532b3e.akpm@linux-foundation.org>
In-Reply-To: <1273217107-2023-1-git-send-email-ngupta@vflare.org>
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 May 2010 12:55:04 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> (tested on mainline but should apply to linux-next cleanly)
> 
>  * Changelog: v2 vs initial patches
>    - directly add swap free callback to block_device_operations
>      instead of using 'notifiers' for various swap events.
> 
> ramzswap driver creates RAM based block devices which can be
> used (only) as swap disks. Pages swapped to these disks are
> compressed and stored in memory itself.
> 
> However, these devices do not get any notification when a swap
> slot is freed (swap_map[i] reaches 0). So, we cannot free memory
> allocated corresponding to this swap slot. Such stale data can
> quickly accumulate in (compressed) memory defeating the whole
> purpose of such devices.
> 
> To overcome this problem, we now add a callback in struct
> block_device_operations which is called as soon as a swap
> slot is freed.
> 
> Nitin Gupta (3):
>   Add flag to identify block swap devices
>   Add swap slot free callback to block_device_operations
>   ramzswap: Handler for swap slot free callback
> 
>  drivers/staging/ramzswap/TODO           |    5 -----
>  drivers/staging/ramzswap/ramzswap_drv.c |   22 +++++++++++++---------
>  include/linux/blkdev.h                  |    2 ++
>  include/linux/swap.h                    |    1 +
>  mm/swapfile.c                           |    5 +++++

I didn't even realise that ramzswap had snuck in via the staging
backdoor.


<hasty review>

Looking at the changelogs I'm seeing no information about the
effectiveness of ramzswap - how much memory it saves.  As that's the
entire point of the driver, that would be a rather important thing to
have included in the commit comments.  We cannot make the decision to
merge ramzswap without this info.

The various lengthy pr_info() messages could do with some attention
from a native English speaker (sorry).

setup_swap_header() should use kmap_atomic().


The driver appears to be controlled by some nasty-looking ioctl against
some fd.  None of it is documented anywhere.  It should be.  You're
proposing here a permanent extension to the kernel ABI which we will
need to maintain for ever.  That's a big deal and it is the very first
thing reviewers will look at, before even considering the code.

The compat implications of the ioctl args will need to be examined. 

RZSIO_GET_STATS looks to be hopeless from a long-term maintainability
POV.  It's debug code and it would be better to move it into a debugfs
file, where we can then add and remove things at will.

The code would benefit from a lot more comments.  For example, take
add_backing_swap_extent().  What is its role in the overall operation
of the driver?  What are its locking preconditions?  The meaning of its
return value?  Generally, aim to be telling the reader the things whcih
he needs to know and which aren't obvious from the code itself.

add_backing_swap_extent() does an alloc_page(__GFP_ZERO).  That means
it's GFP_ATOMIC and not __GFP_HIGH.  But afacit it could have used the
much stronger GFP_KERNEL.  Was the lakc of GFP_KERNEL deliberate? 
There's no way for me to tell due to the lack of comments.  If it _was_
deliberate then there should be a comment telling me why.  If it wasn't
deliberate then, well, bug.

ramzswap_drv.h could use the __aligned() macro rather than that
__attribute__(()) mouthful.

The comment says that ramzswap_backing_extent "must fit exactly in a
page", but doesn't tell us why.  It seems an odd requirement.

I wasn't able to determine the locking for
ramzswap.backing_swap_extent_list.  Is there any?  The definition site
would be an appropriate place to document this.

The CONFIG_RAMZSWAP_STATS=n definitions of rzs_stat_inc() and friends
should be inlined C functions, not macros.  This can help to prevent
unused-variable warnings, it looks nicer and provides better
typechecking.


How does this driver actually *work*?  I'm not seeing a description in
the code or the commit logs.  setup_backing_swap_extents() appears to
be setting up some sort of in-memory layout on an existing regular file
in response to an ioctl?  What are the requirements on that file? 
Perahps its size must be greater-than-or-equal-to some argument which
was passed to that ioctl?  Dunno.  Can that file be sparse?  Judging
from the use of bmap() I'd say "no".

The driver appears to create a /dev node called "ramzswap".  If so, I
should be able to run mke2fs on it and cheerily use it as a regular
filesystem, should I not?  If so then the entire driver is not
swap-specific at all and there should be no mention of "swap" anywhere!
ramzblock would be more appropriate.

Whoa.  We appear to pass a filename into the driver via the ioctl and
then the driver does an internal filp_open().  Seems odd - it would be
more idiomatic to have userspace open the file and pass in the fd. 
This sort of fundamental ABI design issue would be much better
discussed within the context of an English-language design description,
rather than by grovelling through undocumented C code.

The driver is overloading page->mapping for its own use.  Beware that
many parts of the VM heavily overload existing page fields in many
weird and wonderful ways, because the pageframe is so space-critical. 
Having a driver also overloading page fields needs to be considered in
the context of core kernel's activities, current and potentially in the
future.

page_address() returns a void*.  Hence it is unnecessary and
undesirable that its return be typecast when assigned to another
pointer.

The driver only supports a single block device, kernel-wide?

ramzswap.table is a vmalloced array of `struct table' objects.  The
code looks up the address on one `struct table' via rzs->table[pagenum]
and then passes the address of that struct into vmalloc_to_page(), thus
extracting a pointer to the pageframe which repsresents the page which
contains the indexed `struct table'.  This is weird.  Why should the
driver care about the outer `struct page' which happens to comtain the
indexed `struct table'?  Oh.  To fiddle with that page's ->mapping. 
Which is presumably shared between all the `struct table's which are
contained within that page.  Really, I shouldn't have to
reverse-engineer all of this to understand it.  And if I don't
understand it, I cannot really review it, nor suggest alternatives.

map_backing_swap_page() contains c99-style local definitions right in
the middle of the code.  That's a thing which we've been avoiding in
the kernel.  The compiler should have warned - perhaps someone broke
the makefiles.

I've completely forgotten why we need this xvmalloc thing and I don't
recall whether we decided it would be a good thing to have as a generic
facility and of course it's all unexplained and undocumented.  I won't
be looking at it today, for this reason.

handle_zero_page() should use clear_page().  Actually zero_user() will fit.

handle_uncompressed_page() can probably use copy_user_highpage().

Local variable `pagenum' in handle_ramzswap_fault() is unused.

Lack of comments over ramzswap_read() is irritating.

ramzswap_read(): if /* should NEVER happen */ _does_ happen then we
should return an error.

Am unable to determine what ramzswap.lock locks.

This decision:

	if (rzs->backing_swap)
		ramzswap_set_memlimit(rzs, totalram_pages << PAGE_SHIFT);
	else
		ramzswap_set_disksize(rzs, totalram_pages << PAGE_SHIFT);

looks pretty important.  But I don't know what it's all doing.

Magic constants go in magic.h.  It is unusual to use a string for a
magic constant.  If it _has_ to be a string then don't put it in magic.h.


I'll give up there.

The overall idea and utility appear to be good and desirable, IMO.  But
the code isn't productively reviewable in this state.
