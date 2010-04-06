Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0DFP1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:27:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:57623 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab0DFP1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:27:36 -0400
Subject: Re: [PATCH] perf: Store active software events in a hashlist
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 17:27:33 +0200
Message-ID: <1270567653.20295.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 16:08 +0200, Frederic Weisbecker wrote:
> Each time a software event triggers, we need to walk through
> the entire list of events from the current cpu and task contexts
> to retrieve a running perf event that matches.
> We also need to check a matching perf event is actually counting.
> 
> This walk is wasteful and makes the event fast path scaling
> down with a growing number of events running on the same
> contexts.
> 
> To solve this, we store the running perf events in a hashlist to
> get an immediate access to them against their type:event_id when
> they trigger. 

So we have a hash-table per-cpu, each event takes a ref on the hash
table, when the thing is empty we free it.

When the event->cpu == -1 (all cpus) we take a ref on all possible cpu's
hash-table (should be online I figure, but that requires adding a
hotplug handler).

Then on event enable/disable we actually add the event to the hash-table
belonging to the cpu the event/task gets scheduled on, since each event
can only ever be active on one cpu.

Right?

So looks good, altough I think we want to do that online/hotplug thing.

