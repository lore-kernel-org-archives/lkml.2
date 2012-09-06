Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2IFV4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:56:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2IFV4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:56:40 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tH-HXrYtrmAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=2LRdTIhJ_zgA:10 a=x2oc_8r-AAAA:8 a=2dp5XVxkT3K5qZoIV_0A:9 a=PUjeQqilurYA:10 a=S6B0uP62o2EA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346968599.1680.55.camel@gandalf.local.home>
Subject: Re: lockdep WARNING on check_critical_timing()
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 06 Sep 2012 17:56:39 -0400
In-Reply-To: <20120906212914.GE2448@linux.vnet.ibm.com>
References: <20120905015937.GA20175@localhost>
	 <1346965229.1680.48.camel@gandalf.local.home>
	 <20120906212914.GE2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 14:29 -0700, Paul E. McKenney wrote:
>  
> > Didn't we talk about having the rcu_dereference_raw() not do the check?
> > The function tracer is just too invasive to add work arounds to prevent
> > lockdep from screaming about it.
> 
> Actually, rcu_dereference_raw() is already supposed to bypass the
> lockdep checks.  And the code looks to me like it does the bypass,
> OR-ing "1" into the asssertion condition.
> 
> So what am I missing here?

>From my tree, I see:

#define rcu_dereference_raw(p) rcu_dereference_check(p, 1)

#define rcu_dereference_check(p, c) \
	__rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)

Note the 'c' comes after rcu_read_lock_held()

static inline int rcu_read_lock_held(void)
{
	if (!debug_lockdep_rcu_enabled())
		return 1;
	if (rcu_is_cpu_idle())
		return 0;
	if (!rcu_lockdep_current_cpu_online())
		return 0;
	return lock_is_held(&rcu_lock_map);
}

Then when lock_is_held() is called, we get the false warning message.

-- Steve


