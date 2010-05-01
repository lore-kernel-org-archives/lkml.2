Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0EATrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 15:47:32 -0400
Received: from thunk.org ([69.25.196.29]:60130 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab0EATra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 15:47:30 -0400
Date: Sat, 1 May 2010 15:47:10 -0400
From: tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-ID: <20100501194710.GV14986@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <1271731314-5893-4-git-send-email-david@fromorbit.com>
 <20100429143931.331c2bab.akpm@linux-foundation.org>
 <87sk6dwka6.fsf@linux.vnet.ibm.com>
 <20100430124329.10a4c02b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430124329.10a4c02b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 12:43:29PM -0700, Andrew Morton wrote:
> 
> Maybe that fs shouldn't be calling write_cache_pages() at all.  After
> all, write_cache_pages() is a wrapper which emits a sequence of calls
> to ->writepage(), and ->writepage() writes a page.

On my todo list is to fix ext4 to not call write_cache_pages() at all.
We are seriously abusing that function ATM, since we're not actually
writing the pages when we call write_cache_pages().  I won't go into
what we're doing, because it's too embarassing, but suffice it to say
that we end up calling pagevec_lookup() or pagevec_lookup_tag()
*four*, count them *four* times while trying to do writeback.

I have a simple patch that gives ext4 our own copy of
write_cache_pages(), and then simplifies it a lot, and fixes a bunch
of problems, but then I discarded it in favor of fundamentally redoing
how we do writeback at all, but it's going to take a while to get
things completely right.  But I am working to try to fix this.

If it would help, I can ressurect the "fork write_cache_pages() and
simplify" patch, so ext4 isn't dependent on the mm/page-writeback.c's
write_cache_pages(), if there is an immediate, short-term need to fix
that function.

						- Ted
