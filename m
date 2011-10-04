Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab1JDWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:13:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:44144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDWN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:13:28 -0400
Subject: Re: Quick review of -rt RCU-related patches
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Oct 2011 00:12:35 +0200
In-Reply-To: <alpine.LFD.2.02.1110042322450.18778@ionos>
References: <20111004174755.GA4762@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1110042322450.18778@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317766355.32543.38.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 00:05 +0200, Thomas Gleixner wrote:
> > peter_zijlstra-frob-rcu.patch
> > 
> >       Looks OK.  Hmmm...  Should this one go to mainline?
> >       Oh, looks equivalent, actually.  So why the change?
> 
> Peter ? 

-       if (in_irq() || in_serving_softirq()) {
+       if (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET)) {


For !rt its equivalent yes, for rt otoh its not:

int in_serving_softirq(void)
{
        int res;

        preempt_disable();
        res = __get_cpu_var(local_softirq_runner) == current;
        preempt_enable();
        return res;
}

However invoke_softirq() will still add SOFTIRQ_OFFSET so we need to
look at that to avoid recursion issues.

The changelog describes this. So this change is a direct consequence of
-rt frobbing the softirq stuff and thus isn't needed upstream. 
