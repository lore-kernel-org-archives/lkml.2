Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab2JaApI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:45:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63290 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab2JaApB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <1351642073.4004.38.camel@gandalf.local.home>
References: <20121029202711.062749374@goodmis.org>
	<20121029203847.242305452@goodmis.org>
	<1351618787.8467.136.camel@gandalf.local.home>
	<CAFTL4hyD=JU6UgayiXZ-UfusWEn9Rjsy7qTHN8NQZ4pL2HV-=Q@mail.gmail.com>
	<1351642073.4004.38.camel@gandalf.local.home>
Date: Wed, 31 Oct 2012 01:45:00 +0100
Message-ID: <CAFTL4hxbenHe-8deFnx3hy9yAC_tojrgOcz5U93sQEZGty7Jxg@mail.gmail.com>
Subject: Re: [PATCH 04/32] x86: New cpuset nohz irq vector
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/31 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2012-10-31 at 00:51 +0100, Frederic Weisbecker wrote:
>
>> > Probably just use irq_work for self ipis, and normal ipis for other
>> > CPUs.
>>
>> Right. And that's one more reason why we want to know if the arch
>> implements irq work with self ipis or not. If the arch can't, then we
>> just don't stop the tick.
>
> We can just allow certain archs to have cpuset/nohz. Make it depend on
> features that you want (or makes nohz easier to implement).

Right.

>>
>> > Also, what reason do we have to force a task out of nohz? IOW, do we
>> > really need this?
>>
>> When a posix CPU timer is enqueued, when a new task is enqueued, etc...
>
> I was thinking about something other than itself. That is, who would
> enqueue a posix cpu timer on the cpu other than the task running with
> nohz on that cpu?

If the posix cpu timer is process wide (ie: whole threadgroup) this can happen.

> A new task would send the schedule ipi too. Which would enqueue the task
> and take the cpu out of nohz, no?

Not if it's enqueued locally. And in this case we don't want to
restart the tick from the ttwu path in order to avoid funny locking
scenario. So a self IPI would do the trick.

>> irq work should be just fine. No need to add more overhead on the
>> schedule ipi I think.
>
> irq_work can send the work to another CPU right? This part I wasn't sure
> about.

"Claiming" a work itself can be a cross CPU competition: multiple CPUs
may want to queue the work at the same time, only one should succeed.
Once claimed though, the work can only been enqueued locally.
