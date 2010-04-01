Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab0DAUSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:18:53 -0400
Received: from www.tglx.de ([62.245.132.106]:48885 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758775Ab0DAUSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:18:50 -0400
Date: Thu, 1 Apr 2010 22:18:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chase Douglas <chase.douglas@canonical.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till
 after load update period
In-Reply-To: <h2s40ec3ea41004011300zaa5699f0kcf07434fec9b1aab@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004012203270.32352@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>  <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>  <20100401122740.a1ae80a7.akpm@linux-foundation.org>  <alpine.LFD.2.00.1004012133570.32352@localhost.localdomain>
 <h2s40ec3ea41004011300zaa5699f0kcf07434fec9b1aab@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Chase Douglas wrote:
> On Thu, Apr 1, 2010 at 3:37 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Yes, we can do something smarter. First thing is to fix the
> > nr_uninterruptible accounting which can become negative. Peter looked
> > into that already and we really need to fix this first before doing
> > anything smart about that load avg stuff.
> 
> I noticed this too, and figured it was some clever accounting :). If
> this is a real bug, I'd be happy to take a look at it as well.
> 
> What do you have in mind as a smarter way of fixing this issue, and
> why is it dependent on fixing the absolute values of each runqueue's
> nr_uninterruptible count?

Well, the uninterruptible count imbalance is preventing us to calc the
load avg per cpu, which is something the power saving folks are
interested in.

If that is fixed we probably have a good chance to collect the per cpu
stuff and build a combined one - have not looked into the gory details
of the math yet.

Also we need to think about a more clever way than just accounting the
number of running and uninterruptible tasks. What we really want is to
use the numbers which the scheduler has handy, i.e how many tasks did
we run since we did the last loadavg calculation. It was always
possible (even before the big loadavg changes) to create a task which
consumes 50% of a CPU and never shows up in the loadavg calculations
at all.

Thanks,

	tglx
