Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0KSBrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:47:12 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:42839 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754730Ab0KSBrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:47:10 -0500
Date: Fri, 19 Nov 2010 12:46:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering
 writeback
Message-ID: <20101119014605.GA13830@dastard>
References: <1289996638-21439-1-git-send-email-walken@google.com>
 <1289996638-21439-4-git-send-email-walken@google.com>
 <20101117125756.GA5576@amd>
 <1290007734.2109.941.camel@laptop>
 <AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
 <20101117231143.GQ22876@dastard>
 <AANLkTimE1KecXQhcxsKLSLug-7XpmGbmvsfSmG7kWDNn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimE1KecXQhcxsKLSLug-7XpmGbmvsfSmG7kWDNn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:31:37PM -0800, Michel Lespinasse wrote:
> On Wed, Nov 17, 2010 at 3:11 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> Really, my understanding is that not pre-allocating filesystem blocks
> >> is just fine. This is, after all, what happens with ext3 and it's
> >> never been reported as a bug (that I know of).
> >
> > It's not ext3 you have to worry about - it's the filesystems that
> > need special state set up on their pages/buffers for ->writepage to
> > work correctly that are the problem. You need to call
> > ->write_begin/->write_end to get the state set up properly.
> >
> > If this state is not set up properly, silent data loss will occur
> > during mmap writes either by ENOSPC or failing to set up writes into
> > unwritten extents correctly (i.e. we'll be back to where we were in
> > 2.6.15).
> >
> > I don't think ->page_mkwrite can be worked around - we need that to
> > be called on the first write fault of any mmap()d page to ensure it
> > is set up correctly for writeback.  If we don't get write faults
> > after the page is mlock()d, then we need the ->page_mkwrite() call
> > during the mlock() call.
> 
> Just to be clear - I'm proposing to skip the entire do_wp_page() call
> by doing a read fault rather than a write fault. If the page wasn't
> dirty already, it will stay clean and with a non-writable PTE until it
> gets actually written to, at which point we'll get a write fault and
> do_wp_page will be invoked as usual.

I have no problem with that - I'm surprised that mlock didn't work
that way in the first place.

> I am not proposing to skip the page_mkwrite() while upgrading the PTE
> permissions, which I think is what you were arguing against ?

I wasn't arguing against anything, merely pointing out that the
->page_mkwrite call is aboslutely necessary. You've made clarified
that it still occurs, so I'm happy...

FWIW, what I was responding to was the assumption that "this is
alright for ext3, so it must be OK" extrapolation about
->page_mkwrite behaviour. Especially as ext3 does not even implement
the ->page_mkwrite operation (which means mmap writes into holes
can't detect ENOSPC correctly)...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
