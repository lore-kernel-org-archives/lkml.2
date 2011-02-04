Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1BDNFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:05:54 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1BDNFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:05:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=JjROT0WWW2KEfmhmmLsQx1HiRugvLxGtUB1WL0fs6jPuAyV1Skd0dVcrRY0RMBO963
         s5XcZe07jK4Vgu++bSDA==
Message-ID: <4d4bf9ac.cf03d90a.2908.2186@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 4 Feb 2011 14:00:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        gorcunov@gmail.com, ming.m.lin@intel.com
Subject: [PATCH 0/2] perf_events: add support for Intel fixed counter 2
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series of patches adds support for Intel fixed counter 2
on processors which implement architectural perfmon v2 and later.

Fixed counter 2 is wired to count reference cycles. It corrresponds
to architected event UNHALTED_REFERENCE_CYCLES. This is a very useful
event because:
	- it is imune to Turbo Mode on Intel Nehalem and follow-ons
	- it is imune to frequency scaling, including during idle

In other words, it keeps a constant correlation to time. It is
therefore a good source a reliable timings comparable to TSC.

The other advantage of providing access to this counter is that
it offers an additional cycle-counting counter. This is useful
when the NMI watchdog is active because it already consumes one
such counter.

The difficulty in providing access to the counter (and event) is
that the encoding 0x013c is ambiguous. It also corresponds to event
CPU_CLK_UNHALTED:REF_P (or BUS) which is measured on generic counters.
The issue is that this event counts a different kind of cycles: bus cycles.
Thus, the event code 0x13c is not enough to differentiate what the user
wants.

This series of patches solves this problem by introducing a custom
encoding for UNHALTED_REFERENCE_CYCLES (0xff3c) and improving
the constraint infrastructure to handle events which can ONLY be
measured on fixed counters.

The UNHALTED_REFERENCE_CYCLES (and fixed counter 2) is available on
all Intel processors since architectural perfmon v2 (Intel Yonah).

[PATCH 0/2] - Introduction
[PATCH 1/2] - Improvement to X86 constraints management
[PATCH 0/2] - add fixed counter 2 support

Signed-off-by: Stephane Eranian <eranian@google.com>
---
