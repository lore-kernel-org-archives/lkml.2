Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1DQIvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 04:51:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:48660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1DQIvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 04:51:00 -0400
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110417081827.GC29733@elte.hu>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
	 <1302943877.32491.9.camel@twins> <20110417081540.GL31407@erda.amd.com>
	 <20110417081827.GC29733@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Apr 2011 10:53:32 +0200
Message-ID: <1303030412.2035.52.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 10:18 +0200, Ingo Molnar wrote:
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > > I'd really prefer not to do this for .39, and I'll have to sit down and 
> > > actually read this code. It looks like we went from O(n^2) to O(n!) or 
> > > somesuch, also not much of an improvement. I'll have to analyze the solver 
> > > to see what it does for 'simple' constraints set to see if it will indeed 
> > > be more expensive than the O(n^2) solver we had.
> > 
> > It wont be more expensive, if there is a solution. But if there is no one we 
> > walk all possible ways now which is something like O(n!).
> 
> So with 6 counters it would be a loop of 720, with 8 counters a loop of 40320, 
> with 10 counters a loop of 3628800 ... O(n!) is not fun.

Right, and we'll hit this case at least once when scheduling a
over-committed system. Intel Sandy Bridge can have 8 counters per core +
3 fixed counters, giving an n=11 situation. You do _NOT_ want to have
one 39916800 cycle loop before we determine the PMU isn't schedulable,
that's simply unacceptable.

There's a fine point between maximum PMU utilization and acceptable
performance here, and an O(n!) algorithm is really not acceptable. If
you can find a polynomial algorithm that improves the AMD-F15 situation
we can talk.

As it stands I'm tempted to have AMD suffer its terrible PMU design
decisions, if you want this fixed, fix the silicon.

