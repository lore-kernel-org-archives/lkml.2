Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab0KLQSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:18:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39792 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0KLQST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:18:19 -0500
Subject: Re: [RFC][PATCH 07/22] sched: SCHED_DEADLINE push and pull logic
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333935.8661.148.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333935.8661.148.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 17:17:53 +0100
Message-ID: <1289578673.2084.314.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:32 +0200, Raistlin wrote:
> Add dynamic migrations to SCHED_DEADLINE, so that tasks can
> be moved among CPUs when necessary. It is also possible to bind a
> task to a (set of) CPU(s), thus restricting its capability of
> migrating, or forbidding migrations at all.
> 
> The very same approach used in sched_rt is utilised:
>  - -deadline tasks are kept into CPU-specific runqueues,
>  - -deadline tasks are migrated among runqueues to achieve the
>    following:
>     * on an M-CPU system the M earliest deadline ready tasks
>       are always running;
>     * affinity/cpusets settings of all the -deadline tasks is
>       always respected. 

I haven't fully digested the patch, I keep getting side-tracked and its
a large patch.. however, I thought we would only allow 2 affinities,
strict per-cpu and full root-domain?

Since there are no existing applications using this, this won't break
anything except maybe some expectations :-)

The advantage of restricting the sched_setaffinity() calls like this is
that we can make the schedulability tests saner.

Keep 2 per-cpu utilization counts, a hard-rt and a soft-rt, and ensure
the sum stays <= 1. Use the hard-rt one for the planned SF_HARD_RT flag,
use the soft-rt one for !SF_HARD_RT with nr_cpus_allowed == 1, and use
\Sum (1-h-s) over the root domain for nr_cpus_allowed != 1.

Once you start allowing masks in between its nearly impossible to
guarantee anything.

