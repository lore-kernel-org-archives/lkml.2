Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1KIOxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:53:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1KIOxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:53:14 -0500
Subject: Re: [PATCH RFC tip/core/rcu 28/28] rcu: Fix idle-task checks
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Wed, 09 Nov 2011 15:52:44 +0100
In-Reply-To: <20111103045509.GH2042@leaf>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-28-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111103045509.GH2042@leaf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320850364.19727.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 21:55 -0700, Josh Triplett wrote:
> On Wed, Nov 02, 2011 at 01:30:49PM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > RCU has traditionally relied on idle_cpu() to determine whether a given
> > CPU is running in the context of an idle task, but recent changes have
> > invalidated this approach.  This commit therefore switches from idle_cpu
> > to "current->pid != 0".
> 
> Could you elaborate a bit on "recent changes"?  It looks like you mean
> commit 908a3283728d92df36e0c7cd63304fd35e93a8a9; if so, could you add
> that reference to the commit message?

Oh, that was unintended fallout, idle_cpu() was taken to mean is this
cpu currently idle, and was changed to not return true when there's
pending wakeups, since in that case the cpu isn't actually idle, even
though it might still be running the idle task.

> Also, the hard-coded use of "current->pid != 0" concerns me.  Could this
> use some existing function?  Does idle_task() help?  If no appropriate
> predicate exists, perhaps it should.  is_idle_task(current)?

Right, current == idle_task(smp_processor_id()) will test if the current
task is the idle task for the current cpu, regardless of whether the cpu
is actually idle or not.

Then again, the ->pid == 0 thing seems to be fairly solid as well,
having just looked at the fork_idle() code etc.. 
