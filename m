Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2BBR2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:28:51 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46305 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab2BBR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:28:49 -0500
Date: Thu, 2 Feb 2012 09:13:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 14/41] rcu: Limit lazy-callback duration
Message-ID: <20120202171342.GP2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202020356.GL29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202020356.GL29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020217-1780-0000-0000-000002D22DE8
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110324; UDB=6.00027425; UTC=2012-02-02
 17:28:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 06:03:56PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:32AM -0800, Paul E. McKenney wrote:
> > Currently, a given CPU is permitted to remain in dyntick-idle mode
> > indefinitely if it has only lazy RCU callbacks queued.  This is vulnerable
> > to corner cases in NUMA systems, so limit the time to six seconds by
> > default.  (Currently controlled by a cpp macro.)
> 
> I wonder: should this scale with the number of callbacks, or do we not
> want to make estimates about memory usage based on that?

Interesting.  Which way would you scale it?  ;-)

> Interestingly, with kfree_rcu, we actually know at callback queuing time
> *exactly* how much memory we'll get back by calling the callback, and we
> could sum up those numbers.

We can indeed calculate for kfree_rcu(), but we won't be able to for
call_rcu_lazy(), which is my current approach for cases where you cannot
use kfree_rcu() due to (for example) freeing up a linked structure.
A very large fraction of the call_rcu()s in the kernel could become
call_rcu_lazy().

At some point in the future, it might make sense to tie into the
low-memory notifier, which could potentially allow the longer timeout
to be omitted.

My current guess is that the recent change allowing idle CPUs to
exhaust their callback lists will make this kind of fine-tuning
unnecessary, but we will see!

							Thanx, Paul

