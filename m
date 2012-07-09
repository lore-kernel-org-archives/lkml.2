Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2GIOr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:47:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:51474 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab2GIOry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:47:54 -0400
Message-ID: <1341845268.3462.80.camel@twins>
Subject: Re: perf with precise attribute kills all KVM based VMs
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jul 2012 16:47:48 +0200
In-Reply-To: <4FFAED16.7050204@redhat.com>
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>
	 <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 17:39 +0300, Avi Kivity wrote:
> > Disabling PEBS events for guests isn't pretty though.. 
> 
> We already have atomic MSR switching at guest entry/exit time.  So it's
> not pretty in terms of not getting full profiling, but the code won't be
> too hard.  Basically we just have to exclude_guest any pebs event. 

OK, so ideally we'd do something like the below, except of course that
that isn't backwards compatible and will break the world :/

bugger that

---
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -336,6 +338,9 @@ int x86_setup_perfctr(struct perf_event *event)
                /* BTS is currently only allowed for user-mode. */
                if (!attr->exclude_kernel)
                        return -EOPNOTSUPP;
+
+               if (!attr->exclude_guest)
+                       return -EOPNOTSUPP;
        }
 
        hwc->config |= config;
@@ -378,6 +383,9 @@ int x86_pmu_hw_config(struct perf_event *event)
        if (event->attr.precise_ip) {
                int precise = 0;
 
+               if (!event->attr.exclude_guest)
+                       return -EOPNOTSUPP;
+
                /* Support for constant skid */
                if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
                        precise++;
