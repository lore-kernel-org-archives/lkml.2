Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab0LFNLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:11:40 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42032 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0LFNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:11:39 -0500
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
From: Ian Munsie <imunsie@au1.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
In-reply-to: <alpine.LFD.2.00.1012061359140.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6> <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com> <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6> <1291637998-sup-4601@au1.ibm.com> <alpine.LFD.2.00.1012061359140.2653@localhost6.localdomain6>
Date: Tue, 07 Dec 2010 00:11:28 +1100
Message-Id: <1291640985-sup-4443@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Thomas Gleixner's message of Tue Dec 07 00:04:20 +1100 2010:
> > I just moved them into this routine to keep all the dispatching in one
> > place, whether delayed or not. These particular events will still be
> > processed immediately when encountered in the file. Only >=
> > PERF_RECORD_MMAP && <= PERF_RECORD_SAMPLE will be delayed via the
> > perf_session__process_timed function.
> 
> Gah. This is nasty. I really prefer the explicit split of instant
> processed and possibly delayed events. That makes the code clear and
> easy to extend. I just want to add a new event type at the right place
> and not worry about magic comparisions in some other place.

Fair enough, I'll split them back out.

> > For instance, suppose we ran this on an old kernel without support for
> > timestamps on every event (so timestamps are only on sample events):
> > 
> > perf record -T
> > perf report
> > 
> > If perf report tried to process the events in order, all the events
> > without timestamps would be processed first -- including the
> > PERF_RECORD_EXIT event, which would cause every sample not to be
> > attributed. Falling back means we should get no worse than the old
> > behaviour, while an upgraded kernel will provide the timestamps and
> > should not fall back.
> 
> Ok, but you'll break existing code which does only care about sample
> ordering if you do that at the session level unconditionally.

Good point. I'll give this some thought overnight.

Cheers,
-Ian
