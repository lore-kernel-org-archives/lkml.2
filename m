Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0IXUb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:31:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:53965 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0IXUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:31:27 -0400
Message-ID: <4C9D0A82.5020406@windriver.com>
Date: Fri, 24 Sep 2010 15:30:58 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: a.p.zijlstra@chello.nl, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: kgdb segv in the latest tip due to perf ctx changes
References: <20100924180417.GC1818@jolsa.brq.redhat.com>
In-Reply-To: <20100924180417.GC1818@jolsa.brq.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080701090502060403010908"
X-OriginalArrivalTime: 24 Sep 2010 20:31:00.0155 (UTC) FILETIME=[6664C0B0:01CB5C27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080701090502060403010908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jiri,

Can you try this simple patch which is attached?



On 09/24/2010 01:04 PM, Jiri Olsa wrote:
> while starting kgdb early debug on latest tip tree,
> I got SIGSEGV inside kernel in following location:
>
>   
[clip]
> I found out it's due to foolowing commit, that's causing the init code
> to be called without the ctx field being defined...
>
> commit c3f00c70276d8ae82578c8b773e2db657f69a478
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Wed Aug 18 14:37:15 2010 +0200
>
>
>   

I took a look at the tip core, and the ctx parameter is no longer passed
into the perf_event_alloc() from perf_event_create_kernel_counter() kgdb
no longer gets it filled in for free.

The reality is that kgdb never had a true context or a way to mark the
hw breakpoint as a kernel only context for the hw breakpoint
reservations.  The patch is only a short term fix perhaps until on of
the perf guys explains the right way to use it. :-)

Thanks,
Jason.


--------------080701090502060403010908
Content-Type: text/x-diff;
 name="0001-Fix-null-dereference-when-using-early-kgdb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Fix-null-dereference-when-using-early-kgdb.patch"

>From 17f3febd001a26aee9a75c61152b60b7e0ae1ea9 Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Fri, 24 Sep 2010 15:21:11 -0500
Subject: [PATCH] Fix null dereference when using early kgdb

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/hw_breakpoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 3b714e8..3c7ccdf 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -213,7 +213,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	       int weight)
 {
 	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->ctx->task;
+	struct task_struct *tsk = bp->ctx ? bp->ctx->task : NULL;
 
 	/* Pinned counter cpu profiling */
 	if (!tsk) {
-- 
1.6.3.3


--------------080701090502060403010908--
