Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1KWKLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:11:14 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:40267 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1KWKLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:11:12 -0500
Message-ID: <1322043068.10119.7.camel@br98xy6r>
Subject: [PATCH] kdump: crashk_res init check for
 /sys/kernel/kexec_crash_size
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: akpm@linux-foundation.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 23 Nov 2011 11:11:08 +0100
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently it is possible to set the crash_size via the sysfs
/sys/kernel/kexec_crash_size even if no crash kernel memory has
been defined with the "crashkernel" parameter. In this case
"crashk_res" is not initialized and crashk_res.start = crashk_res.end = 0.
Unfortunately resource_size(&crashk_res) returns 1 in this case.
This breaks the s390 implementation of crash_(un)map_reserved_pages().

To fix the problem the correct "old_size" is now calculated in
crash_shrink_memory(). "old_size is set to "0" if crashk_res is
not initialized. With this change crash_shrink_memory() will do nothing,
when "crashk_res" is not initialized. It will return "0" for
"echo 0 > /sys/kernel/kexec_crash_size" and -EINVAL for
"echo [not zero] > /sys/kernel/kexec_crash_size".

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 kernel/kexec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1131,7 +1131,7 @@ void __weak crash_free_reserved_phys_ran
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
-	unsigned long start, end;
+	unsigned long start, end, old_size;
 
 	mutex_lock(&kexec_mutex);
 
@@ -1141,10 +1141,10 @@ int crash_shrink_memory(unsigned long ne
 	}
 	start = crashk_res.start;
 	end = crashk_res.end;
-
-	if (new_size >= end - start + 1) {
+	old_size = (end == 0) ? 0 : end - start + 1;
+	if (new_size >= old_size) {
 		ret = -EINVAL;
-		if (new_size == end - start + 1)
+		if (new_size == old_size)
 			ret = 0;
 		goto unlock;
 	}


