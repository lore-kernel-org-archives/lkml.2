Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772Ab2CUFwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:52:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56153 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2CUFwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:52:06 -0400
MIME-Version: 1.0
Date: Wed, 21 Mar 2012 11:22:05 +0530
Message-ID: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
Subject: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
From: Rajesh Bhagat <rajesh.lnx@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 60ec8a88ba671fa0b424f7b4467dba3ea8a2a2c8 Mon Sep 17 00:00:00 2001
From: Rajesh Bhagat <rajesh.lnx@gmail.com>
Date: Tue, 20 Mar 2012 10:35:59 +0530
Subject: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue

This patch resets the trace_array using tracing_reset_online_cpus, if same
tracer is set again instead of just returning from funtion tracing_set_tracer.

problem description
-------------------
once function tracer is set, set_ftrace_filter not working.
/debug/tracing # echo function > current_tracer
/debug/tracing # echo schedule > set_ftrace_filter
/debug/tracing # echo function > current_tracer
/debug/tracing #  cat trace
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
          <idle>-0     [000]    21.997778: irq_enter <-handle_IRQ
          <idle>-0     [000]    21.997785: idle_cpu <-irq_enter
          <idle>-0     [000]    21.997794: local_bh_disable <-irq_enter
          <idle>-0     [000]    21.997800: tick_check_idle <-irq_enter
          <idle>-0     [000]    21.997807:
tick_check_oneshot_broadcast <-tick_check_idle
          <idle>-0     [000]    21.997814: _local_bh_enable <-irq_enter

After applying this patch, only filtered functions are traced.

Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
---
 kernel/trace/trace.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3f1bc5..f4fb190 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3058,8 +3058,10 @@ static int tracing_set_tracer(const char *buf)
        ret = -EINVAL;
        goto out;
    }
-   if (t == current_trace)
+   if (t == current_trace) {
+       tracing_reset_online_cpus(tr);
        goto out;
+   }

    trace_branch_disable();
    if (current_trace && current_trace->reset)
-- 
1.7.6
