Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0ESRwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:52:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0ESRwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:52:00 -0400
X-Authority-Analysis: v=1.1 cv=DB4JU8ZWelvwd5d0x20oybKyR86uyiSly0XbcMdosrc= c=1 sm=0 a=Fe3ICOQhGXcA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=D19gQVrFAAAA:8 a=07d9gI8wAAAA:8 a=lA-ZuMOiFAHGlj5E2MsA:9 a=et-i8iMnysZvlGFP64Kt6sEkLK4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [RFC] Unified Ring Buffer (Next Generation)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 13:51:54 -0400
Message-ID: <1274291514.26328.930.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More than a year and a half ago (September 2008), at Linux Plumbers, we
had a meeting with several kernel developers to come up with a unified
ring buffer. A generic ring buffer in the kernel that any subsystem
could use. After coming up with a set of requirements, I worked on
implementing it. One of the requirements was to start off simple and
work to become a more complete buffering system.

I posted a set of patches to LKML and several developers (including
Linus) got involved in the design of the ring buffer:


Here's the thread that started the development:

http://lkml.org/lkml/2008/9/19/275

And the ring buffer we ended with here:

http://lkml.org/lkml/2008/9/29/155

And a nice article in LWN about it as well:

http://lwn.net/Articles/300992/


This ring buffer replaced ftrace's ring buffer, as well as oprofile's
ring buffer, and other utilities in the kernel moved over to interacting
with ftrace directly. Although, the ring buffer was a separate entity
from ftrace and it was not required to use ftrace to use the ring
buffer.

The design of the ring buffer was focused more towards in kernel users
and for use with the splice() system call. It did not (and still does
not) support a mmap interface.

In December of 2008 a new utility was created called "perf". At the time
it was a performance counter. In September of 2009, it was converted
over into performance events.

At the time, the unified ring buffer was still not lockless, so it could
lose events in NMI context.

Peter Zijlstra, took a look at the unified ring buffer and found that it
did not suite his needs. He needed a reliable ring buffer in NMI context
as well as something that can mmap to userspace.

At that time, I was working on other aspects of the kernel and did not
have the time to help him come up with something that he could use.
Having to get work done, Peter implemented his own ring buffer for use
with perf.

I do not blame Peter for this, since any developer (including myself)
would have done the same.

Unfortunately, we are now back with more than one ring buffer in the
kernel. What's worse, neither of them can perform all the features
needed. This is putting a bit of stress on the users of these tools, not
to mention the stress on the developers as well.


In June of 2009, I finally made the ring buffer lockless:

http://lkml.org/lkml/2009/6/10/381

Again, LWN wrote up a nice article about this as well:

http://lwn.net/Articles/340400/


But it was too late, and still did not support mmap. Perf was already
dependent on its own ring buffer, and now we are back to where we were
before the unified ring buffer existed.


This email is about finding a solution to the problem. If we can once
again create a generic ring buffer that handles all requirements, then
we can also merge the functionality of ftrace into perf, and lower the
duplication of code within the kernel.


This time around, I'm asking Mathieu Desnoyers to come to the plate, and
see if he can handle the task.

I'm hoping that this email will start a thread that gets everyone into
agreement and produces something that will make everyone happy.

-- Steve


