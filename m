Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2ILMsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:48:11 -0400
Received: from [205.233.59.134] ([205.233.59.134]:44985 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab2ILMsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:48:08 -0400
Message-ID: <1347453696.15764.24.camel@twins>
Subject: Re: [PATCH tip/core/rcu 11/26] rcu: Exit RCU extended QS on user
 preemption
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Date: Wed, 12 Sep 2012 14:41:36 +0200
In-Reply-To: <20120912120627.GA14705@somewhere>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
	 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346360743-3628-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346950959.18408.47.camel@twins> <1346951591.18408.48.camel@twins>
	 <20120910202611.GB19268@somewhere> <1347442413.2124.70.camel@twins>
	 <20120912120627.GA14705@somewhere>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 14:06 +0200, Frederic Weisbecker wrote:
> 
> 1) This can happen if something calls set_need_resched() while no other task is
> on the runqueue.

People really shouldn't be doing that... I think I know why RCU does
this, but yuck. I also think RCU can avoid doing this, but its a toss up
if that's worth the trouble.

> 2) Remote wake up done but we haven't yet received the schedule IPI.
> 
> 3) Non IPI remote wakeup you're referring above, I'm not sure
> what you mean though.

Well there's two ways of doing remote wakeups, one is doing the wakeup
from the waking cpu and sending an IPI over to reschedule iff you need
wakeup-preemption, the other is queueing the task remotely and sending
an IPI to do the wakeup on the remote cpu.

The former has the problem, the latter not. 

See ttwu_queue().

We could of course mandate that all remote wakeups to special nohz cpus
get queued. That would just leave us with RCU and it would simply not
send resched IPIs to extended quiescent CPUs anyway, right?

So at that point all return to user schedule() calls have nr_running > 1
and the tick is running and RCU is not in extended quiescent state.
Since either we had nr_running > 1 and pre and post state are the same,
or we had nr_running == 1 and we just got a fresh wakeup pushing it to
2, the wakeup will have executed on our cpu and have re-started the tick
and kicked RCU into active gear again.

We cannot hit return to user schedule() with nr_running == 0, simply
because in that case there's no userspace to return to, only the idle
thread and that's very much not userspace :-)

Hmm ?
