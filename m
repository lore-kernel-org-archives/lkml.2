Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab0IUQ2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:28:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:35326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab0IUQ2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:28:06 -0400
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <AANLkTimFgsOkMaX9FFidqL-6SHStgqW6v73F3rM-Kmmz@mail.gmail.com>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	 <1285061899.2275.824.camel@laptop> <1285062228.2275.826.camel@laptop>
	 <AANLkTik-oMNJdakwsH=22LzgYvgd35aom+Zu2WkchUte@mail.gmail.com>
	 <1285072975.2275.872.camel@laptop>
	 <AANLkTinmHGtLFRa4O5DNRGgoRtM4cy65JgCw=sYxEjNF@mail.gmail.com>
	 <1285077801.2275.881.camel@laptop>
	 <AANLkTimFgsOkMaX9FFidqL-6SHStgqW6v73F3rM-Kmmz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Sep 2010 18:27:27 +0200
Message-ID: <1285086447.2275.887.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 18:17 +0200, Stephane Eranian wrote:
> On Tue, Sep 21, 2010 at 4:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-09-21 at 15:38 +0200, Stephane Eranian wrote:
> >> > Hmm, indeed. One thing we can do about that is move perf into the
> >> > cgroup, create the counter (disabled) using self to identify the cgroup,
> >> > move perf back to where it came from, and enable the counter.
> >> >
> >> Yes, that's another possibility. I wonder if there are any non-obvious
> >> difficulties with this approach.
> >
> > Yes, there is, but I think we can fix it. The problem with moving perf
> > itself around is that perf is not a fully dormant process and can thus
> > interact with the cgroup state.
> >
> I was thinking about memory accounting for instance.

I think the memory controller only accounts things when the process
actually touches something. A process that never wakes will never touch
anything.

> > If we were to fork a child that's simply sitting idle in waitpid() (or
> > any other blocking syscall) we can move that around cgroup without
> > affecting the cgroup itself.
> 
> But then things get a bit more complicated because the perf_event_open()
> has to be done in that child. File descriptors created in child processes
> and not shared with their parent. You'd have to pass file descriptors around.
> That seems overly complicated.

Uhm, no the trick is that the child remains absolutely dormant and
therefore doesn't accrue any accounting, all you need is a known task in
the cgroup, the parent can then specify the child pid to identify the
group.

Once you've opened the counter, you can move the kid out and kill it.
Note that moving it out of the cgroup before killing it ensure it never
wakes up inside that cgroup.


