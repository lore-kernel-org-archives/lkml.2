Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab2IFKOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 06:14:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40043 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab2IFKOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 06:14:15 -0400
Message-ID: <1346926417.2600.73.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu] Add callback-free CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 12:13:37 +0200
In-Reply-To: <20120905234443.GY3308@linux.vnet.ibm.com>
References: <20120905213945.GA15216@linux.vnet.ibm.com>
	 <1346881720.2600.48.camel@twins> <20120905234443.GY3308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 16:44 -0700, Paul E. McKenney wrote:

> I was excited by this possibility when you first mentioned it, but
> the low-OS-jitter fans are going to need the grace-period computation
> to be offloaded as well. 

Sure, but it seems to me pulling the grace period machinery out is a
much harder feat and should be a patch (series) on its own. Also..

>  So if I use your (admittedly much simpler)
> approach, I get to rewrite it when Frederic's adaptive-ticks work goes
> in. 

I don't see how Frederic's work affects any of this, that would simple
put RCU into extended quiescent state (aka. idle) while in userspace. In
that state the grace period machinery is stopped all together, so it
doesn't matter who would've ran it. 

>  Given that this is probably happening relatively soon, it would be
> better if I just did the implementation that will be needed long-term,
> rather than rewriting.
> 
> Though I am sure that people will be sad about fewer RCU patches.  ;-)

Always...

Now thinking about this grace machinery stuff a little more, would it be
possible to stick the entire state machine in a kthread and replace all
current hooks, like the tick and rcu_read_unlock_special with a message
passing construct such that they pass their event on to the kthread?

That way you could run the entire state thing from a kthread with random
affinity, all 'per-cpu' data would still be fine since only the one
kthread will access it, even though locality might suffer somewhat.

This would also not suffer from the having to keep one cpu special and
the ugly bouncing etc..


