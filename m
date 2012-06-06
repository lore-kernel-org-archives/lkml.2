Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2FFPxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:53:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2FFPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:53:04 -0400
Date: Wed, 6 Jun 2012 08:52:32 -0700
From: tip-bot for Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Message-ID: <tip-ceb1cbac8eda66cf0f889def226b4e82f8ff857b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, bp@amd64.org,
        tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, bp@amd64.org,
        tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <20120531073738.GH7511@linux.vnet.ibm.com>
References: <20120531073738.GH7511@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/x86:
  Calculate booted cores after construction of sibling_mask
Git-Commit-ID: ceb1cbac8eda66cf0f889def226b4e82f8ff857b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:52:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ceb1cbac8eda66cf0f889def226b4e82f8ff857b
Gitweb:     http://git.kernel.org/tip/ceb1cbac8eda66cf0f889def226b4e82f8ff857b
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Thu, 31 May 2012 13:07:38 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:37:59 +0200

sched/x86: Calculate booted cores after construction of sibling_mask

Commit 316ad248307fb ("sched/x86: Rewrite set_cpu_sibling_map()")
broke the booted_cores accounting.

The problem is that the booted_cores accounting needs all the
sibling links set up. So restore the second loop and add a comment as
to why its needed.

On qemu booted with -smp sockets=1,cores=2,threads=2;
Before:
 $ grep cores /proc/cpuinfo
 cpu cores       : 2
 cpu cores       : 1
 cpu cores       : 4
 cpu cores       : 3

With the patch:
 $ grep cores /proc/cpuinfo
 cpu cores       : 2
 cpu cores       : 2
 cpu cores       : 2
 cpu cores       : 2

Reported-by: Prarit Bhargava <prarit@redhat.com>
Reported-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120531073738.GH7511@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fd019d7..3fab55b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -382,6 +382,15 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		if ((i == cpu) || (has_mc && match_llc(c, o)))
 			link_mask(llc_shared, cpu, i);
 
+	}
+
+	/*
+	 * This needs a separate iteration over the cpus because we rely on all
+	 * cpu_sibling_mask links to be set-up.
+	 */
+	for_each_cpu(i, cpu_sibling_setup_mask) {
+		o = &cpu_data(i);
+
 		if ((i == cpu) || (has_mc && match_mc(c, o))) {
 			link_mask(core, cpu, i);
 
