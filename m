Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab0JFTEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:04:38 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51759 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755139Ab0JFTEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:04:37 -0400
Date: Wed, 6 Oct 2010 15:04:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] poll(): add poll_wait_set_exclusive()
Message-ID: <20101006190434.GA5783@Krystal>
References: <20101006175635.GA21652@Krystal> <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:23:15 up 13 days, 22:25,  6 users,  load average: 0.01, 0.07,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Wed, Oct 6, 2010 at 10:56 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> > Executive summary:
> >
> > Addition of the new internal API:
> 
> Executive summary: no.
> 
> You need to explain first how you could _ever_ use this without
> breaking select/poll semantics totally.
> 
> IOW, you need to explain the user space interface first. Before you do
> that, this patch is total and utter crap that is expressly designed to
> used only in a manner that is a pure bug.

You are right. My approach breaks the select/poll semantics. This is why I'm
asking for input if we want to solve the more general problem. For the moment,
the poll_wait_set_exclusive() solution was only meant to be used for debugfs
kernel pseudo-files, which fall out of the POSIX scope.

Maybe what I am trying to do is too far from the poll() semantic and does not
apply in the general case, but I clearly see the need, at least in the use-case
detailed below, to wake up only one thread at a time, whether we call this
"poll" or something else. One way to make it available more generally might be
to add a new open() flag and require that all open() of a given file should use
the flag to provide the "wakeup only one thread" behavior.

For reference, here is the use-case: The user-space daemon runs typically one
thread per cpu, each with a handle on many file descriptors. Each thread waits
for data to be available using poll(). In order to follow the poll semantic,
when data becomes available on a file descriptor, the kernel wakes up all
threads at once, but in my case only one of them will successfully consume the
data (all other thread's splice or read will fail with -ENODATA). With many
threads, these useless wakeups add an unwanted overhead and scalability
limitation.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
