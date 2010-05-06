Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab0EFODl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:03:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab0EFODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:03:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=LFTH94PBCZpYJsG37kr5sAjBPmFkqV2Efd02fWRJOr6DUuaJvxaLvFGReiaZBCPQv
	doPIBsFzyV86nJFs7mnjg==
MIME-Version: 1.0
Date: Thu, 6 May 2010 16:03:26 +0200
Message-ID: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
Subject: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU 
	utilization
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at ctx_flexible_sched_in(), the logic is that if  group_sched_in()
fails for a HW group, then no other HW group in the list is even tried.
I don't understand this restriction. Groups are independent of each other.
The failure of one group should not block others from being scheduled,
otherwise you under-utilize the PMU.

What is the reason for this restriction? Can we lift it somehow?

static void
ctx_flexible_sched_in(struct perf_event_context *ctx,
                      struct perf_cpu_context *cpuctx)
{
        struct perf_event *event;
        int can_add_hw = 1;

        list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
                /* Ignore events in OFF or ERROR state */
                if (event->state <= PERF_EVENT_STATE_OFF)
                        continue;
                /*
                 * Listen to the 'cpu' scheduling filter constraint
                 * of events:
                 */
                if (event->cpu != -1 && event->cpu != smp_processor_id())
                        continue;

                if (group_can_go_on(event, cpuctx, can_add_hw))
                        if (group_sched_in(event, cpuctx, ctx))
                                can_add_hw = 0;
        }
}
