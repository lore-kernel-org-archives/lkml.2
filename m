Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2AXPjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:39:31 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60841 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393Ab2AXPja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:39:30 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBSqA071Yt4KcCH25P6HZ1C8OOGFfcjOQ_aLmBRc3ir=9A@mail.gmail.com>
References: <1326127761-2723-1-git-send-email-eranian@google.com>
	<CABPqkBTYrEeSefnXr4-ezmXHjNv1XkfVZGULzY5-=FE3tr3pfg@mail.gmail.com>
	<1327321532.2446.6.camel@twins>
	<CABPqkBSqA071Yt4KcCH25P6HZ1C8OOGFfcjOQ_aLmBRc3ir=9A@mail.gmail.com>
Date: Tue, 24 Jan 2012 16:39:28 +0100
Message-ID: <CABPqkBSALpYBTpaJo4Wor6weM-XM3PRxj23u8N+Kihvm36Hj8w@mail.gmail.com>
Subject: Re: [PATCH 00/13] perf_events: add support for sampling taken
 branches (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The branch stack sampling patch exposes a flaw in the sampling
buffer format as currently exported by the kernel.

In the current format, sample records (RECORD_SAMPLE) are NOT
self-describing. That means that by looking at the fixed size header, it
is not possible to determine which event caused the sample to be recorded
and what's in the body of the variable length sample.

Such introspection is only possible once we know the event unique id
(PERF_SAMPLE_ID). But to get the event ID, we need to parse the
sample. But, given that a sample has a variable length, there is no
predefined position for that ID in the sample. You have a chicken
and egg problem here. There is no room left in the fixed size header
to fit this in.

This works today with perf because perf applies the SAME sample_type
to ALL events, i.e., all events have the same body layout. This is a limitation
of the tool. The kernel API clearly allows more flexibility but it is
hindered by
the problem I described above.

With branch sampling, this becomes more problematic because if you
are sampling on many events, it may not be necessary nor useful to capture
the branch sample stack for each event. With existing HW, the branch
stack uses at most 264 bytes in a sample. You'd be consuming the buffer
space much faster for nothing.

We need to solve this problem yet maintain backward compatibility with old
version of tools.

The kernel sampling buffer format needs to evolve to have fixed size header
that are more self-describing. The header somehow needs to contain the event
ID or the sample_type for type=RECORD_SAMPLE. I would prefer the former
because if we ever need more than 64-bits for sample_type, we would have the
same problem again. Having the event ID, requires that it be generated
systematically. That is not the case today.

That new buffer format could be requested, as a flag, when the event is created.
That would ensure backward compatibility.

An alternative would be to find a way to encode the event ID at a known position
somehow in the body of a RECORD_SAMPLE. But I don't see how that would be
possible (given there is already the sample_id_all stuff).

Any comments?
