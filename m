Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab1BKAyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:54:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53648 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab1BKAyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:54:23 -0500
Message-ID: <4D548904.9000003@cn.fujitsu.com>
Date: Fri, 11 Feb 2011 08:55:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>	<1297095037.13327.47.camel@laptop>	<AANLkTi=abaUN6m9ZWQuri_Y-487YZzjnTujQMP61QdmW@mail.gmail.com>	<1297244844.13327.155.camel@laptop> <AANLkTingFKyux-u6Aw8jg=cKca7QV7bQEHjDzC-4Dg04@mail.gmail.com>
In-Reply-To: <AANLkTingFKyux-u6Aw8jg=cKca7QV7bQEHjDzC-4Dg04@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-11 08:53:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-11 08:53:29,
	Serialize complete at 2011-02-11 08:53:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> while there is already cgroup monitoring active. In that case and if we do not
>>> want to wait until there is at least one ctxsw on all CPUs, then we have to
>>> check if the other threads are not already running on the other CPUs.If so,
>>> we need to do a cgroup switch on those CPUs. Otherwise, we have nothing to
>>> do. Am I getting this right?
>>
>> Right, so if any of those tasks is currently running, that cpu will be
>> monitoring their old cgroup, hence we send an IPI to flip cgroups.
>>
> I have built a test case where this would trigger. I launched a multi-threaded
> app, and then I move the pid into a cgroup via: echo PID >/cgroup/tests/tasks.
> I don't see any perf_cgroup move beyond the PID passed.
> 
> I looked at kernel/cgroup.c and I could not find a invocation of
> ss->attach() that
> would pass threadgroup = true. So I am confused here.
> 
> I wonder how the cgroupfs 'echo PID >tasks' interface would make the distinction
> between PID and TID. It seems possible to move one thread of a multi-threaded
> process into a cgroup but not the others.
> 

You can do this:

	# echo PID > cgroup.procs

When the patchset that implements the above feature is accepted. See:

	https://lkml.org/lkml/2011/2/7/418

The below commit that confused you is actually a part of the above patchset,
but it sneaked into the kernel accidentally:

commit be367d09927023d081f9199665c8500f69f14d22
Author: Ben Blum <bblum@google.com>
Date:   Wed Sep 23 15:56:31 2009 -0700

    cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time
