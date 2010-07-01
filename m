Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab0GASON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:14:13 -0400
Received: from kroah.org ([198.145.64.141]:60025 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab0GASKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:10:46 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:28:56 2010
Message-Id: <20100701172856.882121276@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:26:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [05/23] powerpc/pseries: Only call start-cpu when a CPU is stopped
In-Reply-To: <20100701175134.GA2098@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit aef40e87d866355ffd279ab21021de733242d0d5 upstream.

Currently we always call start-cpu irrespective of if the CPU is
stopped or not. Unfortunatley on POWER7, firmware seems to not like
start-cpu being called when a cpu already been started.  This was not
the case on POWER6 and earlier.

This patch checks to see if the CPU is stopped or not via an
query-cpu-stopped-state call, and only calls start-cpu on CPUs which
are stopped.

This fixes a bug with kexec on POWER7 on PHYP where only the primary
thread would make it to the second kernel.

Reported-by: Ankita Garg <ankita@linux.vnet.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/smp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -84,6 +84,12 @@ static inline int __devinit smp_startup_
 
 	pcpu = get_hard_smp_processor_id(lcpu);
 
+	/* Check to see if the CPU out of FW already for kexec */
+	if (smp_query_cpu_stopped(pcpu) == QCSS_NOT_STOPPED){
+		cpu_set(lcpu, of_spin_map);
+		return 1;
+	}
+
 	/* Fixup atomic count: it exited inside IRQ handler. */
 	task_thread_info(paca[lcpu].__current)->preempt_count	= 0;
 


