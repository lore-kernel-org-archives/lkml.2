Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2J3Xvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:51:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37817 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2J3Xve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:51:34 -0400
MIME-Version: 1.0
In-Reply-To: <1351618787.8467.136.camel@gandalf.local.home>
References: <20121029202711.062749374@goodmis.org>
	<20121029203847.242305452@goodmis.org>
	<1351618787.8467.136.camel@gandalf.local.home>
Date: Wed, 31 Oct 2012 00:51:33 +0100
Message-ID: <CAFTL4hyD=JU6UgayiXZ-UfusWEn9Rjsy7qTHN8NQZ4pL2HV-=Q@mail.gmail.com>
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

2012/10/30 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2012-10-29 at 16:27 -0400, Steven Rostedt wrote:
>> plain text document attachment
>> (0004-x86-New-cpuset-nohz-irq-vector.patch)
>> From: Frederic Weisbecker <fweisbec@gmail.com>
>>
>> We need a way to send an IPI (remote or local) in order to
>> asynchronously restart the tick for CPUs in nohz adaptive mode.
>>
>> This must be asynchronous such that we can trigger it with irqs
>> disabled. This must be usable as a self-IPI as well for example
>> in cases where we want to avoid random dealock scenario while
>> restarting the tick inline otherwise.
>>
>> This only settles the x86 backend. The core tick restart function
>> will be defined in a later patch.
>>
>> [CHECKME: Perhaps we instead need to use irq work for self IPIs.
>> But we also need a way to send async remote IPIs.]
>
> Probably just use irq_work for self ipis, and normal ipis for other
> CPUs.

Right. And that's one more reason why we want to know if the arch
implements irq work with self ipis or not. If the arch can't, then we
just don't stop the tick.

> Also, what reason do we have to force a task out of nohz? IOW, do we
> really need this?

When a posix CPU timer is enqueued, when a new task is enqueued, etc...

>
> Also, perhaps we could just tag onto the schedule_ipi() function instead
> of having to create a new IPI for all archs?

irq work should be just fine. No need to add more overhead on the
schedule ipi I think.
