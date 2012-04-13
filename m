Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2DMLzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:55:18 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:33953 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2DMLzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:55:15 -0400
Date: Fri, 13 Apr 2012 14:55:12 +0300 (EEST)
From: mroos@linux.ee
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: suspicious RCU usage warnings in 3.3.0
In-Reply-To: <20120412045428.GB2497@linux.vnet.ibm.com>
Message-ID: <alpine.SOC.1.00.1204131444150.2736@math.ut.ee>
References: <20120411171004.016ddd95@nehalam.linuxnetplumber.net> <20120411.201854.1070083308359208025.davem@davemloft.net> <20120412004507.GF2473@linux.vnet.ibm.com> <20120411.210843.716144028821174908.davem@davemloft.net>
 <20120412045428.GB2497@linux.vnet.ibm.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sparc64: Eliminate obsolete __handle_softirq() function
> 
> The invocation of softirq is now handled by irq_exit(), so there is no
> need for sparc64 to invoke it on the trap-return path.  In fact, doing so
> is a bug because if the trap occurred in the idle loop, this invocation
> can result in lockdep-RCU failures.  The problem is that RCU ignores idle
> CPUs, and the sparc64 trap-return path to the softirq handlers fails to
> tell RCU that the CPU must be considered non-idle while those handlers
> are executing.  This means that RCU is ignoring any RCU read-side critical
> sections in those handlers, which in turn means that RCU-protected data
> can be yanked out from under those read-side critical sections.
> 
> The shiny new lockdep-RCU ability to detect RCU read-side critical sections
> that RCU is ignoring located this problem.
> 
> The fix is straightforward: Make sparc64 stop manually invoking the
> softirq handlers.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

It works for me on Sun Fire V100 - no more RCU warnings under ping 
flood.

Tested-by: Meelis Roos <mroos@linux.ee>

-- 
Meelis Roos (mroos@linux.ee)
