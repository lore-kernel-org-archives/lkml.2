Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab0EUQPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:15:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:50145 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab0EUQPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:15:17 -0400
Subject: Re: [PATCH 0/4] perf: Precise task / softirq / hardirq filtered
 stats/profiles
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100521151230.GA20941@elte.hu>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
	 <20100521151230.GA20941@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 18:15:13 +0200
Message-ID: <1274458513.1674.1714.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 17:12 +0200, Ingo Molnar wrote:
> 'exclusion' is the ABI detail. The feature your patches 
> implement are to allow 'softirq limited' or 'task-context 
> limited' or 'hardirq profiling' - which is way cool.
> 
> One thing i'd like to see in this feature is for it to 
> work on pure event counting - i.e. 'perf stat' as well. 

Its not really exclusion, all it does is discard samples when in the
wrong context (which happens to work reasonably well for all the
swevents, except for the timer ones).

If you really want to do exclusion you have to disable/enable on *IRQ
entry/exit, but I guess that gets to be prohibitive on costs.

Implementing it shouldn't be too hard, just add some hooks to
irq_enter() irq_exit() and __do_softirq(). Each such hook should loop
over all active events and call ->stop/->start.

The only real problem would be poking at the hrtimer events from an
hrtimer interrupt :-)

