Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab2CGVqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:46:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64335 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2CGVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:46:14 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH] exec: reduce the amount of preemptive stack growth on task creation
Date: Wed,  7 Mar 2012 22:45:45 +0100
Message-Id: <1331156745-1908-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change we used to grow stack by 128k on exec,
but the reason for this was not explained and this had a few downsides:

* Every core dump contained at least that much data in the dumped
stack image - embedded people with on-the-fly crash analyzers
were not amused;

* Memory monitoring tools were showing all processes
as using at least 128+4k of stack, depriving users of
potentially useful information about actual stack usage.

After this change, a top utility equipped with memory display mode
shows meaningful stack size data instead of 132k for almost everyone:

  PID   VSZ VSZRW   RSS (SHR) DIRTY (SHR) STACK^COMMAND
 1875  107m 33172 96392 11176 42504     0  3160 kmail
 1943  338m  293m  100m  2764 80032    64   116 /usr/app/firefox-3.6/firefox-bin
 1861 30156  3788 20076 16464  9320  6468    52 kdesktop [kdeinit]
 1863 32292  3836 22112 17160  9648  6460    40 kicker [kdeinit]
 1859 28740  2804 18444 16068  8224  6484    40 kwin [kdeinit]
 1845 28048  2240 17884 15576  7764  6020    40 kded [kdeinit]
 1797  283m  275m 23088   808 19636     0    36 X :0
 1865 32556  2844 20448 15188  9916  6488    36 knotify [kdeinit]
 1855 27056  2736 16296 14844  7896  6496    36 kaccess [kdeinit]
 1858 26960  2736 16428 14948  7828  6500    36 ksmserver [kdeinit]
 1836 25980  1920 15492 15132  7276  6988    36 kdeinit Running...
 1842 25920  1116 14372 13816  6556  6060    32 klauncher [kdeinit]
 1839 24456   832 11964 11596  6360  6040    32 dcopserver [kdeinit] --nosid
 1877  4996   508  1836   688   532     0    24 /bin/bash
 1867  2036   516   912   588   268     0    20 ksysguardd
 1796  2640   216   764   616   136     0    20 xinit
 1063  1684   208   524   388   100     0    20 rpc.portmap
 1126  1704   200   520   420    60     0    20 gpm -D -2 -m /dev/psaux -t ps2
 1856  1488   184   348   284    56     0    20 kwrapper ksmserver
 1127   896    48   196   156    40     0    20 top
 1268   884    36   184   148    28     0    20 crond -f -d7

Patch is run-tested on x86-64.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 fs/exec.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 153dee1..c33b9d6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -730,7 +730,20 @@ int setup_arg_pages(struct linux_binprm *bprm,
 	/* mprotect_fixup is overkill to remove the temporary stack flags */
 	vma->vm_flags &= ~VM_STACK_INCOMPLETE_SETUP;
 
-	stack_expand = 131072UL; /* randomly 32*4k (or 2*64k) pages */
+	/*
+	 * Pre-emptively grow the stack by a few pages. (why?)
+	 * We used to grow it by 128k here, but the reason for this
+	 * was not explained and this had a few downsides:
+	 * every core dump contained at least that much data in the dumped
+	 * stack image - embedded people with on-the-fly crash analyzers
+	 * were not amused;
+	 * memory monitoring tools were showing all processes
+	 * as using at least 132k of stack, depriving users of
+	 * potentially useful information about actual stack usage.
+	 */
+	stack_expand = 16 * 1024;
+	if (stack_expand < PAGE_SIZE) /* some arches have 64k pages */
+		stack_expand = PAGE_SIZE;
 	stack_size = vma->vm_end - vma->vm_start;
 	/*
 	 * Align this down to a page boundary as expand_stack
-- 
1.6.2.4

