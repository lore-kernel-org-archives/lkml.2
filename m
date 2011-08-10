Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1HJTQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:16:40 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54933 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754730Ab1HJTQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:16:30 -0400
Date: Wed, 10 Aug 2011 15:16:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de
Subject: Re: [RFC PATCH][3.0] Tracepoint: dissociate from module mutex
Message-ID: <20110810191627.GA8525@Krystal>
References: <20110810174101.GA6523@Krystal> <20110810180522.GB2988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810180522.GB2988@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:16:11 up 260 days, 19 min,  4 users,  load average: 0.00,
	0.01, 0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Wed, Aug 10, 2011 at 01:41:01PM -0400, Mathieu Desnoyers wrote:
> > Copy the information needed from struct module into a local module list
> > held within tracepoint.c from within the module coming/going notifier.
> > 
> > This vastly simplifies locking of tracepoint registration /
> > unregistration, because we don't have to take the module mutex to
> > register and unregister tracepoints anymore. Steven Rostedt ran into
> > dependency problems related to modules mutex vs kprobes mutex vs ftrace
> > mutex vs tracepoint mutex that seems to be hard to fix without removing
> > this dependency between tracepoint and module mutex. (note: it should be
> > investigated whether kprobes could benefit of being dissociated from the
> > modules mutex too.)
> > 
> > This also fixes module handling of tracepoint list iterators, because it
> > was expecting the list to be sorted by pointer address. Given we have
> > control on our own list now, it's OK to sort this list which has
> > tracepoints as its only purpose. The reason why this sorting is required
> > is to handle the fact that seq files (and any read() operation from
> > user-space) cannot hold the tracepoint mutex across multiple calls, so
> > list entries may vanish between calls. With sorting, the tracepoint
> > iterator becomes usable even if the list don't contain the exact item
> > pointed to by the iterator anymore.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: tglx@linutronix.de
> > ---
> >  include/linux/module.h     |   12 ---
> >  include/linux/tracepoint.h |   25 +++---
> >  kernel/module.c            |   47 ------------
> >  kernel/tracepoint.c        |  165 +++++++++++++++++++++++++++++++++++++++------
> >  4 files changed, 156 insertions(+), 93 deletions(-)
> 
> Hi Mathieu,
> 
> This is similar to the approach we have taken in the jump label code -
> on module insert/remove we store pointers into module table, so that we
> don't require the module_mutex during update time. It has been working
> well there, so this design makes sense to me at least.

OK, I'll add your acked-by. Thanks!

Mathieu

> 
> Thanks,
> 
> -Jason

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
