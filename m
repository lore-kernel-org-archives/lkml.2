Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab2FMMvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:51:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40584 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2FMMvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:51:05 -0400
MIME-Version: 1.0
Date: Wed, 13 Jun 2012 14:51:03 +0200
Message-ID: <CABPqkBQa8ndydqkMDvc3kzu84_96FbK77TUkrfO3eSPXmv3dhQ@mail.gmail.com>
Subject: [BUG] perf: perf_output_sample() merge issue?
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I was looking at perf_output_sample() today, when I ran
into the following weird statement coming from:

commit a7ac67ea021b4603095d2aa458bc41641238f22c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Jun 27 16:47:16 2011 +0200

    perf: Remove the perf_output_begin(.sample) argument

    Since only samples call perf_output_sample() its much saner (and more


I think the intent of this commit was to add the watermark check
at the very end of the perf_output_sample() and NOT between processing
of RAW and BRANCH_STACK. Something may have gone wrong
in the merge.

Can you confirm this?


perf_output_sample()
{
        if (sample_type & PERF_SAMPLE_RAW) {
        }

        if (!event->attr.watermark) {
                int wakeup_events = event->attr.wakeup_events;

                if (wakeup_events) {
                        struct ring_buffer *rb = handle->rb;
                        int events = local_inc_return(&rb->events);

                        if (events >= wakeup_events) {
                                local_sub(wakeup_events, &rb->events);
                                local_inc(&rb->wakeup);
                        }
                }
        }

        if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
        }
}
