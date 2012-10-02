Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2JBNep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:34:45 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60516 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2JBNeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:34:44 -0400
MIME-Version: 1.0
In-Reply-To: <1349183446.7780.32.camel@twins>
References: <20121002114218.GA5891@krava.brq.redhat.com>
	<1349178781.7780.29.camel@twins>
	<20121002123921.GB6379@krava.brq.redhat.com>
	<CABPqkBQvhUk=3OU4brv0LefZnRn2xSALA2-cVmE3A1wazDT=XA@mail.gmail.com>
	<1349183446.7780.32.camel@twins>
Date: Tue, 2 Oct 2012 15:34:42 +0200
Message-ID: <CABPqkBSRTDbN7Sq9Pg0GOUFNiKGpVgOBY82ZMK--4Tgy9=iZDA@mail.gmail.com>
Subject: Re: [PATCH] perf cgroups: Fix perf_cgroup_switch schedule in warning
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 3:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-10-02 at 14:48 +0200, Stephane Eranian wrote:
>> Not sure, I understand what active_pmu represents.
>
> Its a 'random' pmu of those that share the cpuctx, exactly so you can
> limit pmu iterations to those with unique cpuctx instances.
>
> Its assigned when we create a cpuctx to the pmu creating it, its
> re-assigned on pmu destruction (if that ever were to happen).
>
Yeah, I saw that. active_pmu point to whatever was the last PMU
sharing the cpuctx.

But I guess what is confusing is the name. It has nothing to do
with active vs. inactive. They are all active.

In cgroup_switch(), we must go over all syswide events from all PMUs to
sched out all the ones monitoring ONLY the current cgroup. You must do
this only once per switch. So given that the events are linked off of cpuctx,
what matters is that we go over all unique cpuctx once. Hence, I think
your patch solves the problem, though this is kinda obscure why.

> I realize the name isn't really helping but at the time I couldn't come
> up with anything better :/
>
> If you've got a good suggestion I'd be glad to rename it.

how about unique_pmu?  And adding a comment in cgroup_switch()

+               /* ensure we process each cpuctx only once */
+               if (cpuctx->active_pmu != pmu)
+                       continue;
