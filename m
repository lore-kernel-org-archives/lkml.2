Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1BQQFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:05:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:58968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1BQQFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:05:31 -0500
Subject: Re: [tip:perf/core] perf: Add cgroup support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTim2uXu+XBWdA-ZJOYFUyMrY+ze84QbMzohcN3Fo@mail.gmail.com>
References: <4d590250.114ddf0a.689e.4482@mx.google.com>
	 <tip-e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25@git.kernel.org>
	 <1297875452.2413.453.camel@twins>
	 <AANLkTimM6+gBWGZmbV9VFq76KR-UtsW==HmSEPZmSRyG@mail.gmail.com>
	 <1297942560.2413.1639.camel@twins>
	 <AANLkTi=0psOuX7kd=GH80+dEpziaTghQxjUTW82DhCC6@mail.gmail.com>
	 <1297957843.2413.1911.camel@twins>
	 <AANLkTim2uXu+XBWdA-ZJOYFUyMrY+ze84QbMzohcN3Fo@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Feb 2011 17:05:14 +0100
Message-ID: <1297958714.2413.1929.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 17:01 +0100, Stephane Eranian wrote:
> >
> > That part ended up avoiding a perf_clock() call, we could write that as:
> >
> >  perf_cgroup_set_timestamp(current, ctx->timestamp);
> >
> > since ctx->timestamp has just been set to perf_clock().
> 
> Ok so this one is just an optimization and not a locking problem, right?

Right, it was needed because we wanted to check ctx->lock, but if we
ensure we never call into the cgroup bits when we don't have an active
event that shouldn't be needed.

> I just realized that perf_cgroup_set_timestamp() is systematically
> calling perf_cgroup_from_task(). perf_events is touching cgroup
> data without knowing if this is really needed. But according to your
> earlier message, the call from __perf_event_enable() should be fine
> because we're holding ctx->lock. So  I think we should be fine here.

Right, so if we keep poking at cgroup data for which we're not sure to
have an event (which itself pins the cgroup) we need this extra check
and the above gets done automagically due to passing ctx around.
