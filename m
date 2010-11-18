Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0KRAxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:53:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab0KRAxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:53:43 -0500
Date: Wed, 17 Nov 2010 16:53:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering
 writeback
Message-Id: <20101117165309.fa859fd3.akpm@linux-foundation.org>
In-Reply-To: <20101117235230.GL3290@thunk.org>
References: <1289996638-21439-1-git-send-email-walken@google.com>
	<1289996638-21439-4-git-send-email-walken@google.com>
	<20101117125756.GA5576@amd>
	<1290007734.2109.941.camel@laptop>
	<AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
	<20101117231143.GQ22876@dastard>
	<20101117235230.GL3290@thunk.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 18:52:30 -0500
"Ted Ts'o" <tytso@mit.edu> wrote:

> On Thu, Nov 18, 2010 at 10:11:43AM +1100, Dave Chinner wrote:
> > I don't think ->page_mkwrite can be worked around - we need that to
> > be called on the first write fault of any mmap()d page to ensure it
> > is set up correctly for writeback.  If we don't get write faults
> > after the page is mlock()d, then we need the ->page_mkwrite() call
> > during the mlock() call.
> 
> OK, so I'm not an mm hacker, so maybe I'm missing something.  Could
> part of this be fixed by simply sending the write faults for
> mlock()'ed pages, so page_mkwrite() gets called when the page is
> dirtied.  Seems like a real waste to have the file system pre-allocate
> all of the blocks for a mlock()'ed region.  Why does mlock() have to
> result in the write faults getting suppressed when the page is
> actually dirtied?

Yup, I don't think it would be too bad to take a minor fault each time
an mlocked page transitions from clean->dirty.

In fact we should already be doing that, after the mlocked page gets
written back by kupdate?  Hope so!

