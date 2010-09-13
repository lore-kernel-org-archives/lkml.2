Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab0IMDVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:21:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:44931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab0IMDVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:21:36 -0400
Date: Mon, 13 Sep 2010 13:21:16 +1000
From: Neil Brown <neilb@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 05/17] writeback: quit throttling when signal pending
Message-ID: <20100913132116.3917e5d5@notabene>
In-Reply-To: <20100913015529.GB5312@localhost>
References: <20100912154945.758129106@intel.com>
	<20100912155203.355459925@intel.com>
	<20100913064654.3cce885c@notabene>
	<20100913015529.GB5312@localhost>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 09:55:29 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Mon, Sep 13, 2010 at 04:46:54AM +0800, Neil Brown wrote:
> > On Sun, 12 Sep 2010 23:49:50 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > This allows quick response to Ctrl-C etc. for impatient users.
> > > 
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > ---
> > >  mm/page-writeback.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > --- linux-next.orig/mm/page-writeback.c	2010-09-09 16:01:14.000000000 +0800
> > > +++ linux-next/mm/page-writeback.c	2010-09-09 16:02:27.000000000 +0800
> > > @@ -553,6 +553,9 @@ static void balance_dirty_pages(struct a
> > >  		__set_current_state(TASK_INTERRUPTIBLE);
> > >  		io_schedule_timeout(pause);
> > >  
> > > +		if (signal_pending(current))
> > > +			break;
> > > +
> > 
> > Given the patch description,  I think you might want "fatal_signal_pending()"
> > here ???
> 
> __fatal_signal_pending() tests SIGKILL only, while the one often used
> and need more quick responding is SIGINT..
>

I thought that at first too....  but I don't think that is the case.

In kernel/signal.c, in complete_signal, we have
  if (sig_fatal() ...)
           ....
		sigaddset(&t->pending.signal, SIGKILL);

where sig_fatal is

#define sig_fatal(t, signr) \
	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)


so (if I'm reading the code correctly), if a process receives a signal for
which the handler is SIG_DFL, then SIGKILL is set in the pending mask, so
__fatal_signal_pending will be true.

So it fatal_signal_pending should catch any signal that will cause the
process to exit.  I assume that it what you want...

NeilBrown
