Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2DQPPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:15:00 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45887 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2DQPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:14:58 -0400
Date: Tue, 17 Apr 2012 08:05:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: New RCU related warning due to rcu_preempt_depth() changes
Message-ID: <20120417150556.GB2404@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+1xoqdJjTe+BMe_ebMBSg57gs2FA60T_0WKhrHvfDoE8AvCuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqdJjTe+BMe_ebMBSg57gs2FA60T_0WKhrHvfDoE8AvCuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041715-1780-0000-0000-000004D4EDA2
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000269; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00131692; UDB=6.00030996; UTC=2012-04-17
 15:14:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 10:42:47AM +0200, Sasha Levin wrote:
> Hi Paul,
> 
> It looks like commit 7298b03 ("rcu: Move __rcu_read_lock() and
> __rcu_read_unlock() to per-CPU variables") is causing the following
> warning (I've added the extra fields on the second line):
> 
> [   77.330920] BUG: sleeping function called from invalid context at
> mm/memory.c:3933
> [   77.336571] in_atomic(): 0, irqs_disabled(): 0, preempt count: 0,
> preempt offset: 0, rcu depth: 1, pid: 5669, name: trinity
> [   77.344135] no locks held by trinity/5669.
> [   77.349644] Pid: 5669, comm: trinity Tainted: G        W
> 3.4.0-rc3-next-20120417-sasha-dirty #83
> [   77.354401] Call Trace:
> [   77.355956]  [<ffffffff810e83f3>] __might_sleep+0x1f3/0x210
> [   77.358811]  [<ffffffff81198eaf>] might_fault+0x2f/0xa0
> [   77.361997]  [<ffffffff810e3228>] schedule_tail+0x88/0xb0
> [   77.364671]  [<ffffffff826a01d3>] ret_from_fork+0x13/0x80
> 
> As you can see, rcu_preempt_depth() returns 1 when running in that
> context, which looks pretty odd.

Ouch!!!

So it looks like I missed a place where I need to save and restore
the new per-CPU rcu_read_lock_nesting and rcu_read_unlock_special
variables.  My (probably hopelessly naive) guess is that I need to add
a rcu_switch_from() and rcu_switch_to() into schedule_tail(), but to
make rcu_switch_from() take the task_struct pointer as an argument,
passing in prev.

Does this make sense, or am I still missing something here?

							Thanx, Paul

