Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2GIOv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:51:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38109 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315Ab2GIOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:58 -0400
Message-Id: <20120709143118.396190830@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 12/48] powerpc/xmon: Use cpumask iterator to avoid warning
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit bc1d7702910c7c7e88eb60b58429dbfe293683ce upstream.

We have a bug report where the kernel hits a warning in the cpumask
code:

WARNING: at include/linux/cpumask.h:107

Which is:
        WARN_ON_ONCE(cpu >= nr_cpumask_bits);

The backtrace is:
        cpu_cmd
        cmds
        xmon_core
        xmon
        die

xmon is iterating through 0 to NR_CPUS. I'm not sure why we are still
open coding this but iterating above nr_cpu_ids is definitely a bug.

This patch iterates through all possible cpus, in case we issue a
system reset and CPUs in an offline state call in.

Perhaps the old code was trying to handle CPUs that were in the
partition but were never started (eg kexec into a kernel with an
nr_cpus= boot option). They are going to die way before we get into
xmon since we haven't set any kernel state up for them.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/xmon/xmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 0f3ab06..eab3492 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -971,7 +971,7 @@ static int cpu_cmd(void)
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		count = 0;
-		for (cpu = 0; cpu < NR_CPUS; ++cpu) {
+		for_each_possible_cpu(cpu) {
 			if (cpumask_test_cpu(cpu, &cpus_in_xmon)) {
 				if (count == 0)
 					printf(" %x", cpu);


