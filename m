Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2LLTj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:39:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab2LLTjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:39:22 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=uR51_XVMv30A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=lJNXu2PuPr0A:10 a=7ytzXt4uK6ZxC01KpIsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212192733.221810086@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 12 Dec 2012 14:27:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: [RFC][PATCH RT 0/4 v2] sched/rt: Lower rq lock contention latencies on many CPU boxes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version I rearranged the patches a little so that the IPI patch
comes last. As the first 3 patches are less controversal, and should
probably be added now.

The difference in this version was that I added more comments, but
more importantly I also added a sched feature called RT_PUSH_IPI.
When this feature is enabled, it switches the pull logic to send
an IPI to the RT overloaded CPU to do a push instead of doing  the
pull locally.

When the feature is disabled, the push/pull logic stays the same as
it always has (with rq lock contention).

Now I've discussed this with Clark, and we noticed that the contention
didn't show up until we tried it on a 24 CPU machine. On a 16 CPU machine
it ran fine. Thus, by default, machines with 16 or less CPUs will
have the RT_PUSH_IPI feature disabled. Machines with 17 or more
possible CPUs will have the feature enabled at boot up. Note, we haven't
tried it on a machine with 17 to 23 CPUs.

It is safe to enable or disable this feature at run time, although
you may cause latencies in doing so, but there shouldn't be any missed
wakeups or anything else that is serious. The worse that can happen
is that you miss a pull, and an RT task will stay on its CPU when it
could have migrated to another CPU that just lowered its priority.
Well, if you are worried about that, don't change it when you care :-)

The 16 CPUs is just a heuristic, and people may debate it. And perhaps
you may not like how the push/pull default changes between different
machines. I could also add a command line switch to force enable/disable
at boot, and/or I could add a config as well.

Right now, by default <= 16 CPU machines are as it always was, and
17 or more CPU machines have this new logic enabled. Either one can
change it at run time via the debugfs directory (unfortunately it's
not a sysctl).

Comments?

-- Steve

