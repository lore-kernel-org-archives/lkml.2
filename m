Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1B0MJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 07:09:30 -0500
Received: from lokagrupo.gerwinski.de ([213.239.212.49]:44812 "EHLO
	lokagrupo.gerwinski.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1B0MJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 07:09:27 -0500
X-Greylist: delayed 16279 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Feb 2011 07:09:27 EST
Date: Sun, 27 Feb 2011 08:37:55 +0100
Message-ID: <1298792275.19234.928360@goedel.fjf.gnu.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=us-ascii
Subject: brk() should check randomize_va_space rather
	then CONFIG_COMPAT_BRK
To: linux-kernel@vger.kernel.org
From: Frank Heckenbach <f.heckenbach@fh-soft.de>
User-Agent: semail 20060101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brk() syscall checks CONFIG_COMPAT_BRK to decide whether the brk
area starts just after the end of the code+bss.

Since CONFIG_COMPAT_BRK can be overridden by
/proc/sys/kernel/randomize_va_space, it should rather check this
variable (which is initialized in mm/memory.c from
CONFIG_COMPAT_BRK), see the patch below.

I've tested it with an old libc5 binary: Without the patch, if the
kernel was configured without CONFIG_COMPAT_BRK, the first malloc()
fails with any setting of randomize_va_space. With the patch
applied, the program runs correctly with randomize_va_space < 2, but
not with randomize_va_space == 2, as it should be.

--- linux-2.6.37.2/mm/mmap.c.orig	2011-02-25 00:09:00.000000000 +0100
+++ linux-2.6.37.2/mm/mmap.c	2011-02-26 01:13:53.000000000 +0100
@@ -252,11 +252,11 @@
 
 	down_write(&mm->mmap_sem);
 
-#ifdef CONFIG_COMPAT_BRK
-	min_brk = mm->end_code;
-#else
-	min_brk = mm->start_brk;
-#endif
+	if (randomize_va_space < 2)
+		min_brk = mm->end_code;
+	else
+		min_brk = mm->start_brk;
+
 	if (brk < min_brk)
 		goto out;
 
