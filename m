Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab1ADEC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 23:02:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1ADEC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 23:02:56 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=tMzCIMjc3p4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=Sl7ErhBh2-yPmHqNI6YA:9 a=gvI1CTCOPqPfS90Bh30A:7 a=S7QFkPD5cMqxj8qTDn5PcXAvNfsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][RT][PATCH 4/4] rtmutex: Ensure only the top waiter or
 higher priority task can take the lock
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20101223225117.180036615@goodmis.org>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225117.180036615@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 03 Jan 2011 23:02:53 -0500
Message-ID: <1294113773.3948.203.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 17:47 -0500, Steven Rostedt wrote:
> plain text document attachment
> (0004-rtmutex-Ensure-only-the-top-waiter-or-higher-priorit.patch)
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> In current rtmutex, the pending owner may be boosted by the tasks
> in the rtmutex's waitlist when the pending owner is deboosted
> or a task in the waitlist is boosted. This boosting is unrelated,
> because the pending owner does not really take the rtmutex.
> It is not reasonable.
> 

I'm still hitting some bugs with the port to -rt, but I also noticed
something that doesn't look too good.

There's several places in the kernel where a task may release and
acquire the same lock multiple times in a row.

The old way of removing the pending owner from the lists and waking it
up once, would have the high prio task wake it up once, and then it can
grab the locks multiple times without modifying the list, since the
pending owner is already awake and not in the pi list anymore.

The new way has the owner remove the woken task from its pi list and
wakes it up, but when it steals the lock again, it adds this owner back
to its pi list. When it releases the lock, it wakes it up again and
removes it from its pi list again. This happens over and over again.

Running dbench, I see this happen (probably on one of the dcache locks)
literally a 100 times in a row.

I'm a bit nervous to add this overhead. I'm still working in debug mode
so I'm not at a point to do real benchmarks yet.

-- Steve


