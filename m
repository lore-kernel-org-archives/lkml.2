Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab2EaHhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:37:47 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55765 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab2EaHhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:37:46 -0400
Date: Thu, 31 May 2012 13:07:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org
Subject: [PATCH] sched/x86: Calculate booted cores after construction of
 sibling_mask
Message-ID: <20120531073738.GH7511@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12053107-8256-0000-0000-000002BE0CA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While booting tip (1d06e6d354) on qemu with -smp sockets=1,cores=2,threads=2
topology. There is a mismatch between the number of cores actually present
and cores reported.

Changes related to calculating the number of booted cores was introduced
by 316ad248307fb (sched/x86: Rewrite set_cpu_sibling_map()). With the
clean up, the calculation of booted cores per package is done on an
incompletely constructed sibling_mask per cpu.

sched/x86: Calculate booted cores after construction of sibling_mask

This patch re-introduces the old behaviour of constructing the complete
sibling mask of the cpu, before calculating the number of cores booted.

On qemu booted with -smp sockets=1,cores=2,threads=2,
Before:
$ cat /proc/cpuinfo |grep cores
cpu cores       : 2
cpu cores       : 1
cpu cores       : 4
cpu cores       : 3

With the patch:
$ cat /proc/cpuinfo |grep cores
cpu cores       : 2
cpu cores       : 2
cpu cores       : 2
cpu cores       : 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 arch/x86/kernel/smpboot.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fd019d7..a8d78f3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -382,7 +382,12 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		if ((i == cpu) || (has_mc && match_llc(c, o)))
 			link_mask(llc_shared, cpu, i);

-		if ((i == cpu) || (has_mc && match_mc(c, o))) {
+	}
+
+	for_each_cpu(i, cpu_sibling_setup_mask) {
+		o = &cpu_data(i);
+
+	if ((i == cpu) || (has_mc && match_mc(c, o))) {
 			link_mask(core, cpu, i);

 			/*

