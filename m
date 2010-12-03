Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab0LCLvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:51:31 -0500
Received: from www.tglx.de ([62.245.132.106]:33984 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423Ab0LCLva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:51:30 -0500
Date: Fri, 3 Dec 2010 12:51:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/4] perf/core improvements
In-Reply-To: <20101203004406.GA18492@ghostprotocols.net>
Message-ID: <alpine.LFD.2.00.1012031245220.2653@localhost6.localdomain6>
References: <1291318772-30880-1-git-send-email-acme@infradead.org> <alpine.LFD.2.00.1012022358380.2653@localhost6.localdomain6> <20101203004406.GA18492@ghostprotocols.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Arnaldo Carvalho de Melo wrote:
> Em Fri, Dec 03, 2010 at 12:00:09AM +0100, Thomas Gleixner escreveu:
> > Investigating. Please wait
> 
> Thanks, as I said on IRC, perhaps I neglected the non-perf bits of perf

It's a perf bit of perf. You simply broke the inheritance
code. Testing perf with something more complex than "sleep 1" might
have shown this :)

------------>

Subject: perf: Fix event inherit fallout of precalculated headers
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 03 Dec 2010 11:42:10 +0100

The precalculated header size is not updated when an event is inherited. That
results in bogus sample entries for all child events.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/perf_event.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-tip/kernel/perf_event.c
===================================================================
--- linux-2.6-tip.orig/kernel/perf_event.c
+++ linux-2.6-tip/kernel/perf_event.c
@@ -6184,6 +6184,12 @@ inherit_event(struct perf_event *parent_
 	child_event->overflow_handler = parent_event->overflow_handler;
 
 	/*
+	 * Precalculate sample_data sizes
+	 */
+	perf_event__header_size(child_event);
+	perf_event__id_header_size(child_event);
+
+	/*
 	 * Link it up in the child's context:
 	 */
 	raw_spin_lock_irqsave(&child_ctx->lock, flags);
