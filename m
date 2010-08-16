Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0HPSQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:16:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0HPSQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:16:09 -0400
X-Authority-Analysis: v=1.1 cv=nbWoJD01ruQLYOYE44JZbYtzz81AmFDL3LnuPvZDHs8= c=1 sm=0 a=KqZB06XCtXAA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=6pJ3OuKiDP6GzGk1fnsA:9 a=06LPC770z9_6PaxmLhkA:7 a=xXLS7SVnb_ckx6pABZvW4PTD1roA:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [LOCKDEP BUG][2.6.36-rc1] xt_info_wrlock?
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1281981301.3268.110.camel@gandalf.stny.rr.com>
References: <1281978469.3268.55.camel@gandalf.stny.rr.com>
	 <1281979893.2524.54.camel@edumazet-laptop>
	 <1281981301.3268.110.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 16 Aug 2010 14:16:06 -0400
Message-ID: <1281982566.3268.137.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 13:55 -0400, Steven Rostedt wrote:

Re-looking at the code, I think I figured it out. But it should really
be documented better.


> 
> Please tell me what prevents an interrupt going off after we grab the
> xt_info_wrlock(cpu) in get_counters().
> 
> IOW, what prevents this:
> 
> 	get_counters() {

I left out here:

		for_each_possible_cpu(cpu) {
			if (cpu == curcpu)
				continue;

which means that we are grabbing the lock for other CPUs, and that a
softirq would not be a problem.

> 		xt_info_wrlock(cpu);
> 
> 		<interrupt> --> softirq
> 
> 			xt_info_rblock_bh();
> 				/* which grabs the writer lock */
> 			DEADLOCK!!
> 

Your patchwork patch has:


@@ -729,8 +729,10 @@  static void get_counters(const struct
xt_table_info *t,
 	local_bh_enable();
 	/* Processing counters from other cpus, we can let bottom half enabled,
 	 * (preemption is disabled)
+	 * We must turn off lockdep to avoid a false positive.
 	 */
 
+	lockdep_off();
 	for_each_possible_cpu(cpu) {


We need a better comment than that. Could that be changed to something like:

	/*
	 * lockdep tests if we grab a lock and can be preempted by 
	 * a softirq and that softirq grabs the same lock causing a
	 * deadlock.
	 * This is a special case because this is a per-cpu lock,
	 * and we are only grabbing the lock for other CPUs. A softirq
	 * will only takes its local CPU lock thus, if we are preempted
	 * by a softirq, then it will grab the current CPU lock which
	 * we do not take here.
	 *
	 * Simply disable lockdep here until it can handle this situation.
	 */

Thanks,

-- Steve



