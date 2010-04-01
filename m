Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab0DAUh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:37:56 -0400
Received: from www.tglx.de ([62.245.132.106]:42028 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471Ab0DAUhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:37:53 -0400
Date: Thu, 1 Apr 2010 22:37:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chase Douglas <chase.douglas@canonical.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till
 after load update period
In-Reply-To: <m2k40ec3ea41004011332t80436b03q69ff8cad735037a@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004012233550.32352@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>  <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>  <20100401122740.a1ae80a7.akpm@linux-foundation.org>  <alpine.LFD.2.00.1004012133570.32352@localhost.localdomain> 
 <h2s40ec3ea41004011300zaa5699f0kcf07434fec9b1aab@mail.gmail.com>  <alpine.LFD.2.00.1004012203270.32352@localhost.localdomain> <m2k40ec3ea41004011332t80436b03q69ff8cad735037a@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Chase Douglas wrote:

> On Thu, Apr 1, 2010 at 4:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Also we need to think about a more clever way than just accounting the
> > number of running and uninterruptible tasks. What we really want is to
> > use the numbers which the scheduler has handy, i.e how many tasks did
> > we run since we did the last loadavg calculation. It was always
> > possible (even before the big loadavg changes) to create a task which
> > consumes 50% of a CPU and never shows up in the loadavg calculations
> > at all.
> 
> I'm not sure I follow how knowing how many tasks have been run since
> the last LOAD_FREQ expiration will help, or is that just an example of
> the kind of data the scheduler has available that may be useful?

Yes, it's just an example. Look at the following (UP) scenario:

-> tick	calcs loadavg

-> task is woken and runs for 50% of a tick
-> task goes to sleep

-> tick	calcs loadavg

So loadavg will say 0 forever, while we in reality know that there was
significant work on that CPU - at least when we have a sched_clock
which has a better granularity than the tick itself.

Thanks,

	tglx
