Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0KRLDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:03:16 -0500
Received: from smtp-out.google.com ([216.239.44.51]:25776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab0KRLDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RSjjwJpQ2Hb3KxPh2Wh4IVMKur7XeVjk7fcMjsjIO+QEz46moyw8dKw4VuNhrtJfW+
         aQqO71fM//bE3ijhU4Bg==
Date: Thu, 18 Nov 2010 03:03:01 -0800
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering
 writeback
Message-ID: <20101118110301.GA16625@google.com>
References: <1289996638-21439-1-git-send-email-walken@google.com>
 <1289996638-21439-4-git-send-email-walken@google.com>
 <20101117125756.GA5576@amd>
 <1290007734.2109.941.camel@laptop>
 <AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
 <20101117231143.GQ22876@dastard>
 <20101117235230.GL3290@thunk.org>
 <20101117165309.fa859fd3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117165309.fa859fd3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:53:09PM -0800, Andrew Morton wrote:
> On Wed, 17 Nov 2010 18:52:30 -0500
> "Ted Ts'o" <tytso@mit.edu> wrote:
> 
> > On Thu, Nov 18, 2010 at 10:11:43AM +1100, Dave Chinner wrote:
> > > I don't think ->page_mkwrite can be worked around - we need that to
> > > be called on the first write fault of any mmap()d page to ensure it
> > > is set up correctly for writeback.  If we don't get write faults
> > > after the page is mlock()d, then we need the ->page_mkwrite() call
> > > during the mlock() call.
> > 
> > OK, so I'm not an mm hacker, so maybe I'm missing something.  Could
> > part of this be fixed by simply sending the write faults for
> > mlock()'ed pages, so page_mkwrite() gets called when the page is
> > dirtied.  Seems like a real waste to have the file system pre-allocate
> > all of the blocks for a mlock()'ed region.  Why does mlock() have to
> > result in the write faults getting suppressed when the page is
> > actually dirtied?

This is actually what the patch does - by having mlock() use a read fault,
pages are loaded in memory and mlocked, but the ptes are not marked as
writable so that a later write access will be caught as a write fault at
that time (with all the usual dirtying and page_mkwrite() callbacks).

> Yup, I don't think it would be too bad to take a minor fault each time
> an mlocked page transitions from clean->dirty.
> 
> In fact we should already be doing that, after the mlocked page gets
> written back by kupdate?  Hope so!

Yes, handle_mm_fault() is careful to never create writable ptes pointing
to clean file pages, so that a later write fault will correctly dirty
the corresponding page.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
