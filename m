Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0KJOR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:17:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:3057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0KJOR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,178,1288594800"; 
   d="scan'208";a="676138852"
Subject: Re: [RFC PATCH 1/2] perf: Enable group siblings on exec if
 attr::enable_on_exec set
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289391586.2191.100.camel@laptop>
References: <1289369711.2430.38.camel@minggr.sh.intel.com>
	 <1289391586.2191.100.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 22:17:57 +0800
Message-Id: <1289398677.2479.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 20:19 +0800, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 14:15 +0800, Lin Ming wrote:
> > Currently, only group leader is enabled on exec.
> 
> That's enough, right? If all sibling events are already enabled enabling
> the group leader makes the whole thing go.

No.

If the event group is disabled by default("perf stat" case) and will be
enabled at next exec, then actually only the group leader will be
enabled , because all siblings are explicitly disabled(->state ==
PERF_EVENT_STATE_OFF). So the siblings will never be enabled.

/*
 * Put a event into inactive state and update time fields.
 * Enabling the leader of a group effectively enables all
 * the group members that aren't explicitly disabled, so we
 * have to update their ->tstamp_enabled also.
 * Note: this works for group members as well as group leaders
 * since the non-leader members' sibling_lists will be empty.
 */             
static void __perf_event_mark_enabled(struct perf_event *event,
                                        struct perf_event_context *ctx)
{
        struct perf_event *sub;

        event->state = PERF_EVENT_STATE_INACTIVE;
        event->tstamp_enabled = ctx->time - event->total_time_enabled;
        list_for_each_entry(sub, &event->sibling_list, group_entry)
                if (sub->state >= PERF_EVENT_STATE_INACTIVE)
                        sub->tstamp_enabled =  
                                ctx->time - sub->total_time_enabled;
}



