Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2IEODT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:03:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48233 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2IEODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:03:17 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 16:03:15 +0200
Message-ID: <CABPqkBQGNx0od5-nkRDsrXkKa3+TAYW07j59ct5b17gPU-Oqeg@mail.gmail.com>
Subject: [BUG] perf: perf_swevent PMU should not be on rotation_list
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was looking at the rotation code and I found out that when
I monitor a SW event (in my case a probe), I end up having
two PMUs on the rotation list on Intel Core: cpu and software.

I thought there was no multiplexing needed for SW events.

So why is the SW PMU on the rotation list causing extra
iterations through the rotation code?

Shouldn't we do something like:

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -771,6 +780,9 @@ static void perf_pmu_rotate_start(struct pmu *pmu)
        struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
        struct list_head *head = &__get_cpu_var(rotation_list);

+       if (pmu->type == PERF_TYPE_SOFTWARE)
+               return;
+
        WARN_ON(!irqs_disabled());

        if (list_empty(&cpuctx->rotation_list))
