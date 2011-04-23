Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1DWOvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 10:51:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:3049 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab1DWOvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 10:51:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,259,1301900400"; 
   d="scan'208";a="424341829"
Subject: Re: [2.6.39-rc2] perf top fails to mmap - bisected to 70db7533
From: Lin Ming <ming.m.lin@intel.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Tim Blechmann <tim@klingt.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTikWpnnHAfO2n2rN6ExtQyrsVaiqEQ@mail.gmail.com>
References: <inhgjs$54a$1@dough.gmane.org>	<4D9C84D5.6090303@gmail.com>
	 <20110406175217.GC4987@ghostprotocols.net>
	 <201104062248.23853.tim@klingt.org>	<4D9CE610.4020603@gmail.com>
	 <4D9CECF5.3090309@gmail.com>	<4DB1AED0.60600@gmail.com>
	 <BANLkTimosBfOBsUWQaimT0O53=pALx54AA@mail.gmail.com>
	 <BANLkTikWpnnHAfO2n2rN6ExtQyrsVaiqEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Apr 2011 22:51:11 +0800
Message-Id: <1303570271.3363.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-23 at 22:36 +0800, Lin Ming wrote:
> On Sat, Apr 23, 2011 at 12:37 AM, David Ahern <dsahern@gmail.com> wrote:
> > I know you've been busy with other stuff the past few weeks, but have
> > you had a chance to look into this? Basically, perf in 2.6.39 is broken
> > when trying to profile a process (-p argument to record or top).
> 
> Let me take a look at this.

Below patch fixes the same problem on my box.
Could you have a try it? 

>From 89f1ab02cd8da55f8829b2f2d7e700fdae77b3af Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Sat, 23 Apr 2011 14:54:33 +0000
Subject: [PATCH] perf: Allow set output event for task in the same thread group

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/perf_event.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8e81a98..17dbc49 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6379,9 +6379,10 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 		goto out;
 
 	/*
-	 * If its not a per-cpu buffer, it must be the same task.
+	 * If its not a per-cpu buffer, it must be the same task or in the same thread group.
 	 */
-	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+	if (output_event->cpu == -1 &&
+			!same_thread_group(output_event->ctx->task, event->ctx->task))
 		goto out;
 
 set:


> 
> Lin Ming
> 
> >
> > David


