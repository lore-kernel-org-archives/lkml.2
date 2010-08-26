Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0HZM6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 08:58:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:49148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0HZM6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 08:58:20 -0400
Subject: Re: [PATCH] perf: fix possible divide-by-zero in
 perf_swevent_overflow()
From: Peter Zijlstra <peterz@infradead.org>
To: DDD <dongdong.deng@windriver.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C765FD3.9060904@windriver.com>
References: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com>
	 <1282824727.1975.747.camel@laptop>  <4C765FD3.9060904@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Aug 2010 14:58:06 +0200
Message-ID: <1282827486.1975.845.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 20:36 +0800, DDD wrote:
> Peter Zijlstra wrote:
> > On Thu, 2010-08-26 at 20:07 +0800, Dongdong Deng wrote:
> >> The event->hw.last_period is possible to zero, thus it will
> >> cause divide_by_zero later in perf_swevent_set_period().
> > 
> > How can it be zero?
> 
> When I am running the kgdbts to test the hw_breakpoint_layer with kgdb,
> I get a call trace as following and this problem is hardly to reproduce.
> 
> Maybe the root cause was from kgdb/hw_breakpoint_layer,

Yeah, I think there's a bug in the hw_breakpoint stuff, does something
like the below fix it?


> but add a checking is good to us and harmless. :-)

Except that code path is already too bloated and should be reduced not
added to and conditionals are expensive.


---
 kernel/hw_breakpoint.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index d71a987..f57ebee 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -600,9 +600,20 @@ static int __init init_hw_breakpoint(void)
 }
 core_initcall(init_hw_breakpoint);
 
+static int hw_breakpoint_enable(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->sample_period) {
+		hwc->last_period = hwc->sample_period;
+		perf_swevent_set_period(event);
+	}
+
+	return arch_install_hw_breakpoint(event);
+}
 
 struct pmu perf_ops_bp = {
-	.enable		= arch_install_hw_breakpoint,
+	.enable		= hw_breakpoint_enable,
 	.disable	= arch_uninstall_hw_breakpoint,
 	.read		= hw_breakpoint_pmu_read,
 };

