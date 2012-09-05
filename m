Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2IETXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:23:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2IETXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:23:51 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=18yvFWKpt00A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=d83lr9tk0qMA:10 a=D19gQVrFAAAA:8 a=WlzXjZuLfmP8YWLMPZwA:9 a=PUjeQqilurYA:10 a=b3D6R9wpAFoA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346873028.27919.70.camel@gandalf.local.home>
Subject: Re: lockdep WARNING for run_timer_softirq()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Wed, 05 Sep 2012 15:23:48 -0400
In-Reply-To: <1346865555.2600.38.camel@twins>
References: <20120831072149.GA7821@localhost>
	 <1346845644.2461.27.camel@laptop>
	 <1346854836.27919.51.camel@gandalf.local.home>
	 <1346864947.2600.33.camel@twins>
	 <1346865298.27919.58.camel@gandalf.local.home>
	 <1346865555.2600.38.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 19:19 +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 13:14 -0400, Steven Rostedt wrote:
> > 
> > This looks very familiar to Fengguang's previous bug report. I can't
> > seem to find it on LKML.org. Probably because of the two attachments
> > (dmesg and config) caused lkml to nuke it.
> > 
> > I'll forward it to you. 
> 
> Yuck that looks like fun too.. doesn't look like the if() thing though.

I'm able to trigger a similar bug too. And this is what I've found.

between:

	lockdep_softirq_exit();
and
	__local_bh_enable(SOFTIRQ_OFFSET);

the __local_bh_enable() is being traced, which means we call the
ftrace_ops_list_func() (which is called instead of the direct function
in some configs). This does a:

	op = rcu_dereference_raw(ftrace_ops_list);

where rcu_dereference_raw() eventually calls rcu_read_lock_held() which
calls lock_is_held(), and this does the consistency checks, where
lockdep thinks we are no longer in the softirq, but we haven't gotten to
the point in __local_bh_enable() where the preempt_count is decremented
to state this.

But this doesn't look the same as the branch tracer. I'll continue
looking into that one.

-- Steve


