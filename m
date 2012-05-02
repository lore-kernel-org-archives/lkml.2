Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2EBVyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:54:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48025 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2EBVyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:54:40 -0400
Date: Wed, 2 May 2012 14:54:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
Message-ID: <20120502215406.GL2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
 <1335832418.20866.95.camel@pasglop>
 <alpine.LSU.2.00.1204302142310.27208@eggly.anvils>
 <20120501142208.GA2441@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
 <20120501232516.GR2441@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1205021324430.24246@eggly.anvils>
 <1335993615.4088.1.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335993615.4088.1.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050221-6148-0000-0000-0000058298F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 07:20:15AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2012-05-02 at 13:25 -0700, Hugh Dickins wrote:
> > Got it at last.  Embarrassingly obvious.  __rcu_read_lock() and
> > __rcu_read_unlock() are not safe to be using __this_cpu operations,
> > the cpu may change in between the rmw's read and write: they should
> > be using this_cpu operations (or, I put preempt_disable/enable in the
> > __rcu_read_unlock below).  __this_cpus there work out fine on x86,
> > which was given good instructions to use; but not so well on PowerPC.
> > 
> > I've been running successfully for an hour now with the patch below;
> > but I expect you'll want to consider the tradeoffs, and may choose a
> > different solution.
> 
> Didn't Linus recently rant about these __this_cpu vs this_cpu nonsense ?
> 
> I thought that was going out..

Linus did rant about __raw_get_cpu_var() because it cannot use the x86
%fs segement overrides a bit more than a month ago.  The __this_cpu
stuff is useful if you have preemption disabled -- avoids the extra
layer of preempt_disable().

Or was this a different rant?

							Thanx, Paul

