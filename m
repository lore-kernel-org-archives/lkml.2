Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0LWLjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:39:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41499 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752845Ab0LWLjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:39:31 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18mXlRrRJImmhj2jw42WyuVVo7RSuic+mzo/hDUFH
	EadwTwTDHRRbTR
Date: Thu, 23 Dec 2010 12:39:26 +0100
From: torbenh <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Sending some form of notifaction when sched_fifo throttling kicks
 in...
Message-ID: <20101223113926.GH14960@siel.b>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi...

when the rt_runtime budget is exceeded, the kernel silently stops
scheduling RT tasks. there is no way to distinguish this from 
a task taking very long to complete.

it would be very nice, if the kernel would send some form of notifaction
when it starts throttling things.

recording the timestamp of the last occurence of throttling
in a /proc file would be sufficient, if there were no cgroups.

would it be possible to add a readonly property to the cpu subsystem ?
there is already a printk_once, but thats pretty useless :)


from -rt kernel kernel/sched_rt.c:

----------------------------------------------------------------------------------
static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
{
	u64 runtime = sched_rt_runtime(rt_rq);

	if (rt_rq->rt_throttled)
		return rt_rq_throttled(rt_rq);

	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
		return 0;

	balance_runtime(rt_rq);
	runtime = sched_rt_runtime(rt_rq);
	if (runtime == RUNTIME_INF)
		return 0;

	if (rt_rq->rt_time > runtime) {
		rt_rq->rt_throttled = 1;
		printk_once(KERN_WARNING "sched: RT throttling activated\n");
+ // send some form of notification. 
		if (rt_rq_throttled(rt_rq)) {
			sched_rt_rq_dequeue(rt_rq);
			return 1;
		}
	}

	return 0;
}
-----------------------------------------------------------------------------------
-- 
torben Hohn
