Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1LVVjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:39:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab1LVVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:39:33 -0500
Date: Thu, 22 Dec 2011 16:39:30 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [rfc] disable scheduler warnings during oopses.
Message-ID: <20111222213929.GA4722@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The panic-on-framebuffer code seems to cause a schedule
to occur during an oops. This causes a bunch of extra
spew as can be seen in https://bugzilla.redhat.com/attachment.cgi?id=549230

Would this (untested) patch be sufficient here, or does the drm
code need rearchitecting to not perform allocations during panic ?

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..627f788 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4321,6 +4321,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
+	if (oops_in_progress)
+		return;
+
 	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
 		prev->comm, prev->pid, preempt_count());
 
