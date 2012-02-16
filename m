Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab2BPO7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:59:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41811 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2BPO67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:58:59 -0500
Message-ID: <1329404302.2293.237.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
 implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Date: Thu, 16 Feb 2012 15:58:22 +0100
In-Reply-To: <20120216145233.GA6275@Krystal>
References: <20120213020951.GA12138@linux.vnet.ibm.com>
	 <20120215143116.GA1696@Krystal> <20120215145144.GA6277@Krystal>
	 <20120216063805.GF2976@linux.vnet.ibm.com> <20120216110030.GA1425@Krystal>
	 <1329393115.2293.204.camel@twins> <20120216121807.GA3426@Krystal>
	 <1329396281.2293.213.camel@twins> <20120216145233.GA6275@Krystal>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 09:52 -0500, Mathieu Desnoyers wrote:
> Ah, so this is what I missed: the context switch has its lock/unlock
> pair, the following migration is performed under its own lock/unlock
> pair, and the following context switch also has its lock/unlock pair. So
> yes, this should be sufficient to act as a full memory barrier. 

In fact it typically looks like:

 LOCK(rq0->lock)
  switch-from-A
 UNLOCK(rq0->lock);

	LOCK(rq0->lock);
	LOCK(rq1->lock);
	  migrate-A
	UNLOCK(rq1->lock);
	UNLOCK(rq0->lock);

		LOCK(rq1->lock);
		  switch-to-A
		UNLOCK(rq1->lock);

the migrate taking both locks involved guarantees that the switch-to
always comes _after_ the switch_from. The migrate might be performed on
a completely unrelated cpu although typically it would be either the old
(push) or the new (pull).
