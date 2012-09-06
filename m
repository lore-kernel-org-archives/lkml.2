Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2IFWWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:22:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38747 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2IFWWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:22:47 -0400
Date: Thu, 6 Sep 2012 15:22:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall
 warnings
Message-ID: <20120906222239.GQ2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346943414.18408.31.camel@twins>
 <1346944049.1680.23.camel@gandalf.local.home>
 <1346944758.18408.35.camel@twins>
 <20120906210354.GC2448@linux.vnet.ibm.com>
 <1346967661.1680.52.camel@gandalf.local.home>
 <20120906215838.GM2448@linux.vnet.ibm.com>
 <1346969153.1680.60.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346969153.1680.60.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090622-2398-0000-0000-00000A5C433C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00171894; UDB=6.00038983; UTC=2012-09-06
 22:22:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 06:05:53PM -0400, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 14:58 -0700, Paul E. McKenney wrote:
> 
> > > All these cases deserve a warning.
> > 
> > Agreed, and that is the whole purpose of the stall warnings.
> 
> Then let me ask the question again. According to the change log:
> 
> > If a given CPU avoids the idle loop but also avoids starting a new
> > RCU grace period for a full minute, RCU can issue spurious RCU CPU
> > stall warnings.  This commit fixes this issue by adding a check for
> > ongoing grace period to avoid these spurious stall warnings.
> 
> I'm still confused by what is "this issue"? And why is it being fixed.
> It sounds to me that the "issue" was a CPU avoiding starting a new RCU
> grace period for a full minute. Which to me sounds like a bug in which
> we *want* a warning. Why is this patch needed?

Ah!

It is perfectly legal to avoid -starting- an RCU grace period for a
minute, or even longer.  If RCU has nothing to do, in other words, if no
one registers any RCU callbacks, then RCU need not start a grace period.

Of course, this would mean that it would eventually be a full minute
since the last start of a grace period.  This is not a problem, after
all, Linux went through a full ten years before experiencing its first
grace period.

But the stall-warning code just checked how long it had been since
the last start of a grace period, failing to note that this grace
period had long since completed.  So it splatted out a warning.
This warning was spurious in the sense that there was no bug aside
from the missing check that the grace period was still in progress.

And this commit fixes that bug in RCU.

							Thanx, Paul

