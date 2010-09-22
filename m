Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab0IVH0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 03:26:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0IVH0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 03:26:20 -0400
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20100922043424.GH6676@balbir.in.ibm.com>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	 <1285061899.2275.824.camel@laptop> <1285062228.2275.826.camel@laptop>
	 <AANLkTik-oMNJdakwsH=22LzgYvgd35aom+Zu2WkchUte@mail.gmail.com>
	 <1285072975.2275.872.camel@laptop>
	 <AANLkTinmHGtLFRa4O5DNRGgoRtM4cy65JgCw=sYxEjNF@mail.gmail.com>
	 <1285077801.2275.881.camel@laptop>
	 <AANLkTimFgsOkMaX9FFidqL-6SHStgqW6v73F3rM-Kmmz@mail.gmail.com>
	 <1285086447.2275.887.camel@laptop>
	 <20100922043424.GH6676@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 09:25:58 +0200
Message-ID: <1285140358.2275.891.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 10:04 +0530, Balbir Singh wrote:

> That understanding is correct, but the whole approach sounds more
> complex due to several subsystems involved, the expectation is that
> we'll move perf to all the correct cgroups for each subsystem.

Well, we'll only move a completely dormant task to a cgroup and out
again.

> > > > If we were to fork a child that's simply sitting idle in waitpid() (or
> > > > any other blocking syscall) we can move that around cgroup without
> > > > affecting the cgroup itself.
> > > 
> > > But then things get a bit more complicated because the perf_event_open()
> > > has to be done in that child. File descriptors created in child processes
> > > and not shared with their parent. You'd have to pass file descriptors around.
> > > That seems overly complicated.
> > 
> > Uhm, no the trick is that the child remains absolutely dormant and
> > therefore doesn't accrue any accounting, all you need is a known task in
> > the cgroup, the parent can then specify the child pid to identify the
> > group.
> > 
> > Once you've opened the counter, you can move the kid out and kill it.
> > Note that moving it out of the cgroup before killing it ensure it never
> > wakes up inside that cgroup.
> 
> What the benefits of this complexity, not chaning perf_event_attr?

Yes, attach information should not be in _attr. And you avoid the hassle
of creating a special file and passing fds to it around.
