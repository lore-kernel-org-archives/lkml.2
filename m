Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2AIEzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 23:55:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:1775 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab2AIEzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 23:55:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93738467"
Date: Mon, 9 Jan 2012 12:55:15 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?utf-8?B?0JjQu9GM0Y8g0KLRg9C80LDQudC60LjQvQ==?= 
	<librarian_rus@yahoo.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: A regression in recent 3.2 kernel: bdi_dirty_limit() divide
 error
Message-ID: <20120109045515.GB3976@localhost>
References: <1325884395.57034.YahooMailClassic@web161605.mail.bf1.yahoo.com>
 <20120107145645.GA4997@localhost>
 <1325954125.2442.27.camel@twins>
 <20120108023305.GA5074@localhost>
 <1326017954.2442.35.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326017954.2442.35.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 11:19:14AM +0100, Peter Zijlstra wrote:
> On Sun, 2012-01-08 at 10:33 +0800, Wu Fengguang wrote:
> > On Sat, Jan 07, 2012 at 05:35:25PM +0100, Peter Zijlstra wrote:
> > > On Sat, 2012-01-07 at 22:56 +0800, Wu Fengguang wrote:
> > > > Subject: 
> > > > Date: Sat Jan 07 22:50:45 CST 2012
> > > > 
> > > > The uninitilized shift may lead to denominator=0 in
> > > > prop_fraction_percpu() and divide error in bdi_dirty_limit().
> > > 
> > > I'm not seeing how, only proc_change_shift() can change ->index, and it
> > > does that after it writes ->pg[index]->shift.
> > 
> > Then I lose the clue why bdi_dirty_limit() will divide error at all.
> 
> You and me both, the weird thing is, this code hasn't been changes like
> forever and I can't recall any such weirdness. 
> 
> In fact, prop_fraction_percpu() sets the denominator to period_2 +
> (global_count & counter_mask). 
> 
> The only way to make that 0 is to overflow the unsigned long.. did the
> crash happen on 32bit -- I never saw the initial report?

No, it's a 64bit kernel. Sorry I should have forwarded the initial
complete report.

> But even then, we limit PROP_MAX_SHIFT to 3*BITS_PER_LONG/4, I don't
> think that could ever overflow.

It seems PROP_MAX_SHIFT should be set to <=32 on 64bit box, because

1) bdi_dirty_limit() only uses the lower 32 bit of the denominator
   by calling do_div()

2) (bdi_dirty * numerator) could easily overflow if numerator used
   up to 48 bits, leaving only 16 bits to bdi_dirty

And I guess (2) may be the root cause of a related old bug:

sudden drops of bdi_thresh
http://lkml.indiana.edu/hypermail/linux/kernel/1109.0/00183.html
http://lkml.indiana.edu/hypermail/linux/kernel/1109.0/00183/10-3.1.0-rc1%2Bbalance_dirty_pages-pages.png

> > prop_change_shift() does
> > 
> >         change ->pg[index]->shift
> >         smp_wmb()
> >         change ->index
> > 
> > Will the read side prop_fraction_percpu() need some read memory barrier?
> 
> It actually has one, see prop_get_global()...

Ah yes! Sorry for overlooking this.

Regards,
Fengguang
