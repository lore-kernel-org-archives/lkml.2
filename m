Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1AJKaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:30:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:40645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753090Ab1AJKaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:30:04 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZvM8RXGYZaLiQENH/yurysRKJ5ckI0X2omwNboB
	Vlw7RLcvCqTQu6
Subject: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: bharata@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110110091622.GF2772@in.ibm.com>
References: <20110110091622.GF2772@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 11:29:48 +0100
Message-ID: <1294655388.8197.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 14:46 +0530, Bharata B Rao wrote:
> Hi,
> 
> With autogroup ON, sched_setscheduler() fails when I try to change the
> scheduling policy of a normal task to either RR or FIFO.
> 
> sched_setscheduler() returns -EPERM when it finds that the group doesn't
> have any rt bandwidth. This is expected because with autogroup, the task
> is in an autogroup for which task_group(p)->rt_bandwidth.rt_runtime is 0.
> 
> I guess the task needs to be moved to appropriate cgroup (from its current
> autogroup) when such policy change is requested, but I wasn't sure if
> group change from sched_setscheduler() can be achieved easily.

Right, autogroup should be excluding CONFIG_RT_GROUP_SCHED, since it
doesn't currently support it.

sched: SCHED_AUTOGROUP selection excludes RT_GROUP_SCHED

Autogroup does not support realtime task groups, so make selection of
SCHED_AUTOGROUP exclude RT_GROUP_SCHED.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Reported-by:Bharata B Rao <bharata@linux.vnet.ibm.com>

---
 init/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -699,6 +699,7 @@ config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
 	depends on EXPERIMENTAL
 	depends on CGROUP_SCHED
+	depends on !SCHED_AUTOGROUP
 	default n
 	help
 	  This feature lets you explicitly allocate real CPU bandwidth
@@ -807,6 +808,10 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+	  Note: SCHED_AUTOGROUP does not support realtime tasks, and prevents
+	  enabling RT_GROUP_SCHED.  If you intend to use group scheduling for
+	  realtime tasks, do not enable this option.
+
 config MM_OWNER
 	bool
 


