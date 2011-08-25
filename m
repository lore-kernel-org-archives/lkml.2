Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1HYRTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:19:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59224 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1HYRTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:19:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=XYDZItKBF066PwbZrln+1c04xWGz9p5alR/oHYENImVgINp3kDEEwo/E/mbnG8VK2
	VeydkhDV2s5/KBvNGcxIw==
MIME-Version: 1.0
Date: Thu, 25 Aug 2011 19:19:15 +0200
Message-ID: <CABPqkBS_Og3Vbe90xwyzA8S5ftfF08gMtJdtpqQTHFOwm+CAkg@mail.gmail.com>
Subject: [BUG] perf_event: semantic of PERF_SAMPLE_READ unclear
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was looking at the kernel code dealing with PERF_SAMPLE_READ. You use
this option if you want to capture the values of other events in your
event group
on overflow.

This is similar to what you can do with a read() on an event group
leader. If you've
setup PERF_FORMAT_READ, then you can read the values of the other events
in your event group.

The issue at stake here is what values for the other counters. In
particular, how
recent are those values? Ideally, you'd like those values to be as recent as the
value of the main event.

In the case of sampling, you'd like to capture the values of the other events at
the time of the overflow or very close to it.

In either case, you'd like to get a consistent view of the events,
i.e., take their
values as close as possible from each other.

In the case of read(), the values are all retrieved from the actual counters if
the event group is active. Thus, you get the most recent values
possible. If it's not
active, then it's been saved, and the SW counter represents the most recent
values.

In the case of sampling, however, it is not clear what you get.

The perf_output_read() routine does not read the actual counters.
Instead, it relies
on the SW counter, event->count,  updated via x86_perf_event_update()
who knows when.
I think this could be a problem as the 'snapshot' you're getting is
not really consistent.

I think the perf_output_read() function must read the actual counters
or force an update
of the SW counters before saving the counts into the buffer. Because
we are in the interrupt
handler, we are guaranteed to have the events in the actual counters.
But the difficulty is that
we cannot grab any locks, not sure we need one given the call path.
