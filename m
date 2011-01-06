Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1AFAaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:24 -0500
Received: from kroah.org ([198.145.64.141]:35830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab1AFAaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:18 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:04 2011
Message-Id: <20110106002304.487332434@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [082/152] printk: Fix wake_up_klogd() vs cpu hotplug
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 49f4138346b3cec2706adff02658fe27ceb1e46f upstream.

wake_up_klogd() may get called from preemptible context but uses
__raw_get_cpu_var() to write to a per cpu variable. If it gets preempted
between getting the address and writing to it, the cpu in question could be
offline if the process gets scheduled back and hence writes to the per cpu data
of an offline cpu.

This buggy behaviour was introduced with fa33507a "printk: robustify
printk, fix #2" which was supposed to fix a "using smp_processor_id() in
preemptible" warning.

Let's use this_cpu_write() instead which disables preemption and makes sure
that the outlined scenario cannot happen.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101126124247.GC7023@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1070,7 +1070,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		__raw_get_cpu_var(printk_pending) = 1;
+		this_cpu_write(printk_pending, 1);
 }
 
 /**


