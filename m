Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab2ILOk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:40:59 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52210 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758899Ab2ILOk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:40:57 -0400
MIME-Version: 1.0
Date: Wed, 12 Sep 2012 16:40:55 +0200
Message-ID: <CABPqkBSemt4hsoFfGkm3pac+R+aUJ6Kd9LBTWM-JtKMOF4VM9Q@mail.gmail.com>
Subject: [BUG] perf: multiplexing and hotplug CPU problem
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As I was debugging my hrtimer patch, I ran a few tests
with hotplug CPU. In others words, I offline a CPU while
there is an active monitoring session which causes multiplexing.

When the CPU goes down, all is well. But when it comes back,
things go wrong. No kernel crashes but wrong results and multiplexing
does not work anymore.

I investigated this some more and found out there is an issue
on re-activation.

During shutdown, system-wide events are scheduled out AND removed
from the event lists. Consequently, ctx->nr_events and ctx->nr_active
go to zero.

When the CPU is brought back online and tools do start/stop on the events
they can be scheduled back in, and therefore increment ctx->nr_active.
Because list_add_event() is not called again, you may end up with
ctx->nr_events < ctx->nr_active which is wrong. Events may not
be a lists and therefore they cannot get multiplexed again.

It is not clear to me why we need to remove the events from any
list (list_del_event) when the CPU goes down.

Why isn't calling event_sched_out() enough?
If events are kept on lists, why not try to schedule them back in when
the CPU is brought back online?
