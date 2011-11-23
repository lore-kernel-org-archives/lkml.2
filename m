Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1KWNSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:18:09 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:53570 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1KWNSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:18:08 -0500
Message-ID: <1322054283.10119.11.camel@br98xy6r>
Subject: [PATCH v2] kdump: crashk_res init check for
 /sys/kernel/kexec_crash_size
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: akpm@linux-foundation.org
Cc: Simon Horman <horms@verge.net.au>, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 23 Nov 2011 14:18:03 +0100
In-Reply-To: <20111123102214.GA4914@verge.net.au>
References: <1322043068.10119.7.camel@br98xy6r>
	 <20111123102214.GA4914@verge.net.au>
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

In addition to that this patch also simplifies the "ret = -EINVAL"
vs. "ret = 0" logic as suggested by Simon Horman.

Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 kernel/kexec.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1131,7 +1131,7 @@ void __weak crash_free_reserved_phys_ran
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
-	unsigned long start, end;
+	unsigned long start, end, old_size;
 
 	mutex_lock(&kexec_mutex);
 
@@ -1141,11 +1141,9 @@ int crash_shrink_memory(unsigned long ne
 	}
 	start = crashk_res.start;
 	end = crashk_res.end;
-
-	if (new_size >= end - start + 1) {
-		ret = -EINVAL;
-		if (new_size == end - start + 1)
-			ret = 0;
+	old_size = (end == 0) ? 0 : end - start + 1;
+	if (new_size >= old_size) {
+		ret = (new_size == old_size) ? 0 : -EINVAL;
 		goto unlock;
 	}
 


