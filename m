Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0DGMJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:09:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:43170 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0DGMJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:09:13 -0400
Subject: Re: [PATCH] perf: Store active software events in a hashlist
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100407115839.GE5143@nowhere>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com>
	 <1270567653.20295.11.camel@laptop> <1270631093.5109.569.camel@twins>
	 <20100407115839.GE5143@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 14:09:10 +0200
Message-ID: <1270642150.20295.831.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 13:58 +0200, Frederic Weisbecker wrote:
> On Wed, Apr 07, 2010 at 11:04:53AM +0200, Peter Zijlstra wrote:
> > On Tue, 2010-04-06 at 17:27 +0200, Peter Zijlstra wrote:
> > > On Mon, 2010-04-05 at 16:08 +0200, Frederic Weisbecker wrote:
> > > > Each time a software event triggers, we need to walk through
> > > > the entire list of events from the current cpu and task contexts
> > > > to retrieve a running perf event that matches.
> > > > We also need to check a matching perf event is actually counting.
> > > > 
> > > > This walk is wasteful and makes the event fast path scaling
> > > > down with a growing number of events running on the same
> > > > contexts.
> > > > 
> > > > To solve this, we store the running perf events in a hashlist to
> > > > get an immediate access to them against their type:event_id when
> > > > they trigger. 
> > > 
> > > So we have a hash-table per-cpu, each event takes a ref on the hash
> > > table, when the thing is empty we free it.
> > > 
> > > When the event->cpu == -1 (all cpus) we take a ref on all possible cpu's
> > > hash-table (should be online I figure, but that requires adding a
> > > hotplug handler).
> > > 
> > > Then on event enable/disable we actually add the event to the hash-table
> > > belonging to the cpu the event/task gets scheduled on, since each event
> > > can only ever be active on one cpu.
> > > 
> > > Right?
> > > 
> > > So looks good, altough I think we want to do that online/hotplug thing.
> > 
> > Alternatively, you can simply but the hash table into the per-cpu
> > structure and not allocate it, its only a single page (half a page if
> > you use 32bit or actually use 8 bits.
> 
> 
> As you prefer. This would indeed make it more simple, but that would also
> make these pages unused most of the time.

True I suppose,.. have a go at that hotplug stuff, the only thing I
worried about was that refcount stuff getting rather ugly.

