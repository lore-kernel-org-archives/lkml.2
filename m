Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab0KRPjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:39:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104Ab0KRPjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:39:44 -0500
Date: Thu, 18 Nov 2010 16:32:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>,
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
Subject: Re: [PATCH] sched: Simplify cpu-hot-unplug task migration
Message-ID: <20101118153229.GA32495@redhat.com>
References: <1289673355.2109.79.camel@laptop> <20101113195857.GA11411@redhat.com> <1289680291.2109.244.camel@laptop> <1289681497.2109.270.camel@laptop> <1289691081.2109.452.camel@laptop> <1289851597.2109.547.camel@laptop> <20101117192713.GA11910@redhat.com> <1290022954.2109.1217.camel@laptop> <20101118140515.GA29303@redhat.com> <1290090249.2109.1522.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290090249.2109.1522.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18, Peter Zijlstra wrote:
>
> There is no firm guarantee the dying cpu actually got to running the
> idle thread (there's a guarantee it will at some point), so we ought to
> maintain that wait-loop, possibly using cpu_relax(), I don't see the
> point in calling yield() here.

Agreed. But do we need to wait at all?

With or without this change, even if we know that rq->idle is running
we can't know if it (say) already started play_dead_common() or not.

We are going to call __cpu_die(), afaics it should do the necessary
synchronization in any case.

For example, native_cpu_die() waits for cpu_state == CPU_DEAD in a
loop. Of course it should work in practice (it also does msleep),
but in theory there is no guarantee.

So. Can't we just remove this wait-loop? We know that rq->idle
will be scheduled "soon", I don't understand why it is necessary
to ensure that context_switch() has already happened.

Oleg.

