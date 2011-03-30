Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252Ab1C3VRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:17:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965239Ab1C3VJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238939"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: fweisbec@gmail.com, acme@redhat.com, ak@linux.intel.com,
        eranian@google.com, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [245/275] perf: Better fit max unprivileged mlock pages for tools needs
Message-Id: <20110330210811.A60503E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Frederic Weisbecker <fweisbec@gmail.com>

commit 880f57318450dbead6a03f9e31a1468924d6dd88 upstream.

The maximum kilobytes of locked memory that an unprivileged user
can reserve is of 512 kB = 128 pages by default, scaled to the
number of onlined CPUs, which fits well with the tools that use
128 data pages by default.

However tools actually use 129 pages, because they need one more
for the user control page. Thus the default mlock threshold is
not sufficient for the default tools needs and we always end up
to evaluate the constant mlock rlimit policy, which doesn't have
this scaling with the number of online CPUs.

Hence, on systems that have more than 16 CPUs, we overlap the
rlimit threshold and fail to mmap:

	$ perf record ls
	Error: failed to mmap with 1 (Operation not permitted)

Just increase the max unprivileged mlock threshold by one page
so that it supports well perf tools even after 16 CPUs.

Reported-by: Han Pingtian <phan@redhat.com>
Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/perf_event.c
===================================================================
--- linux-2.6.35.y.orig/kernel/perf_event.c	2011-03-29 22:50:14.502887326 -0700
+++ linux-2.6.35.y/kernel/perf_event.c	2011-03-29 23:53:39.047538547 -0700
@@ -58,7 +58,8 @@
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
+/* Minimum for 128 pages + 1 for the user control page */
+int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
 
 /*
  * max perf event sample rate
