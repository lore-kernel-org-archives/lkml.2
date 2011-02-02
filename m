Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1BBGWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 01:22:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46739 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752425Ab1BBGWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 01:22:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZAQ5keo4ZgT422M8sNlKl41Ci88miQTP9kwHvX5
	nhXblvqzoxVDHh
Subject: Re: [PATCH 1/3 v2] call_function_many: fix list delete vs add race
From: Mike Galbraith <efault@gmx.de>
To: Milton Miller <miltonm@bga.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        JBeulich@novell.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <ipi-paul-reply@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com> <ipi-list-reply@mdm.bga.com>
	 <smp-call-function-list-race-fix-v2@mdm.bga.com>
	 <20110201220026.GD2142@linux.vnet.ibm.com>  <ipi-paul-reply@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 07:22:01 +0100
Message-ID: <1296627721.7858.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 14:00 -0800, Milton Miller wrote:
> On Tue, 1 Feb 2011 about 14:00:26 -0800, "Paul E. McKenney" wrote:

> > Starting with smp_call_function_many():
> > 
> > o	The check for refs is redundant:
> > 
> > 		/* some callers might race with other cpus changing the mask */
> > 		if (unlikely(!refs)) {
> > 			csd_unlock(&data->csd);
> > 			return;
> > 		}
> > 
> > 	The memory barriers and atomic functions in
> > 	generic_smp_call_function_interrupt() prevent the callback from
> > 	being reused before the cpumask bits have all been cleared, right?
> 
> The issue is not the cpumask in the csd, but the mask passed in from the
> caller.  If other cpus clear the mask between the cpumask_first and and
> cpumask_next above (where we established there were at least two cpus not
> ourself) and the cpumask_copy, then this can happen.  Both Mike Galbraith
> and Jan Beulich saw this in practice (Mikes case was mm_cpumask(mm)).

Mine (and Jan's) is a flavor of one hit and fixed via copy in ia64.

http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75c1c91cb92806f960fcd6e53d2a0c21f343081c


	-Mike

