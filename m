Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab2GLWgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:36:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392Ab2GLWgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 014/187] powerpc/xmon: Use cpumask iterator to avoid warning
Date: Thu, 12 Jul 2012 15:32:50 -0700
Message-Id: <20120712191523.579620712@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/xmon/xmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


