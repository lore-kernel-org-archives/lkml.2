Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab1LFK2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:28:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35566 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab1LFK2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:28:18 -0500
Message-ID: <1323167246.32012.60.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Date: Tue, 06 Dec 2011 11:27:26 +0100
In-Reply-To: <1323165152.32012.51.camel@twins>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
	 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111205091924.GA28117@zhy> <20111205164505.GB2326@linux.vnet.ibm.com>
	 <20111206012635.GA32498@zhy> <1323165152.32012.51.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 10:52 +0100, Peter Zijlstra wrote:
> On Tue, 2011-12-06 at 09:26 +0800, Yong Zhang wrote:
> 
> > Yeah, because we call might_sleep() in rt_mutex_lock() unconditionally.
> > But in this case the 'BUG: sleeping function called from invalid context
> > at *' is obviously false positive.
> 
> Why can't this mutex acquisition not block?

Gaah!! I see, this 5342e269 patch is revolting.. guys that's really vile
don't do that!

I tried reading the RCU code but I gave up.. rcu_boost() does:

  rt_mutex_init_proxy_locked();
  raw_spin_unlock_irqrestore();
  rt_mutex_lock();
  rt_mutex_unlock();

vs rcu_read_unlock_special()'s RCU_READ_UNLOCK_BLOCKED branch:

  rt_mutex_unlock();


The latter looks to be unbalanced because I can't actually find a
matching lock. Also, all of that is ran with IRQs enabled. So what's the
problem?


