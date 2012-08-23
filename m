Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030210Ab2HWUkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:40:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab2HWUkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:40:22 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace __getblk_slow misfix by grow_dev_page fix
References: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils>
	<20120822115243.GU1448@rhmail.home.annexia.org>
	<alpine.LSU.2.00.1208222143440.1917@eggly.anvils>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 23 Aug 2012 16:40:11 -0400
In-Reply-To: <alpine.LSU.2.00.1208222143440.1917@eggly.anvils> (Hugh Dickins's
	message of "Wed, 22 Aug 2012 21:56:12 -0700 (PDT)")
Message-ID: <x49obm1fil0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hughd@google.com> writes:

> [PATCH] block: replace __getblk_slow misfix by grow_dev_page fix
>
> Commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow")
> is not good: a successful call to grow_buffers() cannot guarantee
> that the page won't be reclaimed before the immediate next call to
> __find_get_block(), which is why there was always a loop there.
[snip]
> Revert 91f68c89d8f3, restoring __getblk_slow() to how it was (plus
> a checkpatch nitfix).  Simplify the interface between grow_buffers()
> and grow_dev_page(), and avoid the infinite loop beyond end of device
> by instead checking init_page_buffers()'s end_block there (I presume
> that's more efficient than a repeated call to blkdev_max_block()),
> returning -ENXIO to __getblk_slow() in that case.
>
> And remove akpm's ten-year-old "__getblk() cannot fail ... weird"
> comment, but that is worrying: are all users of __getblk() really
> now prepared for a NULL bh beyond end of device, or will some oops??

Hi, Hugh,

Thanks for digging into this.  I had wondered whether that loop was
required for other purposes, and you've verified that it was.  I mostly
like your fix.  Returning end_block from init_page_buffers is a little
strange, but I understand not wanting to redo the call to
blkdev_max_block.

I went ahead to re-tested with the reproducer that I had, and your patch
works fine.  Thanks again for tracking this down, and sorry I wasn't
more diligent to begin with.

Reviewed-and-Tested-by: Jeff Moyer <jmoyer@redhat.com>
