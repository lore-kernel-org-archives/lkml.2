Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2JVNVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:21:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43214 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2JVNVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:21:01 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH v2 0/2] perf: enforce exclusive PMU access for SNB INST_RETIRED:PREC_DIST
Date: Mon, 22 Oct 2012 15:20:50 +0200
Message-Id: <1350912052-10066-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@gmail.com>

The following patch set enforces exclusive PMU access for
Intel SandyBridge INST_REITRED:PREC_DIST event when used
with PEBS as described in the SDM Vol 3b. Without this,
the sample distribution may not be correct.

The kernel now rejects PEBS + INST_RETIRED:PREC_DIST
on SNB if attr->exclusive is not set. One reason to
do it this way is to make sure users understands the
restriction. If the kernel were to force exclusive
on the fly, users would have cases where they would
get no samples and no error messages to understand
why.

The first patch extends perf to allow users to request
exclusive PMU access by introducing a new modifier: x.
For instance:
  $ perf record -e r01c0:ppx .....
or
  $ perf record -e cpu/event=0xc0,umask=0x1/ppx ....

In V2, we fixed the pr_info() issue. We know use
pr_warn_once(). Also fixed the max repeat factor
for the event modifier in the event parser.

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (2):
  perf tools: add event modifier to request exclusive PMU access
  perf: enforce SNB exclusive access for INST_RETIRED:PREC_DIST

 arch/x86/kernel/cpu/perf_event.h       |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |   30 +++++++++++++++++++++++++-----
 tools/perf/util/parse-events.c         |    7 +++++++
 tools/perf/util/parse-events.l         |    2 +-
 4 files changed, 34 insertions(+), 7 deletions(-)

-- 
1.7.9.5

