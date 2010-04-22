Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0DVQXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:23:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45177 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0DVQXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IVuu8s6TbKZVTMGOFyBOIkZf6Fajl7bTMZ6rK0ugFKWnjFGTyVMWKA2/VrGBLqfrO2
         6qjx0q0tnSbib0PY75+JPX8fxy45vAhOyAUM1b2mAd11bAO41FWHSMW+G2KjMolg5iFt
         i8qtPb03T6Lu5RpohGdgEHsY1goDEMxonYZHQ=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: [PATCH 3/5] Support second memory region in crash_shrink_memory()
Date: Thu, 22 Apr 2010 18:23:10 +0200
Message-Id: <1271953392-6324-4-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes crash_shrink_memory() to work with previosly added
memory region also. When shrink occurs, second region is shrunk first.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/kexec.c |   55 ++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index b8fd6eb..dfaa01e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1117,10 +1117,36 @@ static void free_reserved_phys_range(unsigned long begin, unsigned long end)
 	}
 }
 
+int crash_shrink_region(struct resource *crashk, unsigned long new_size)
+{
+	unsigned long start, end, size;
+
+	start = crashk->start;
+	end = crashk->end;
+	size = end - start + 1;
+
+	if (!size || new_size == size) /* Nothing to free */
+		return 0;
+
+	if (new_size > size)
+		return -EINVAL;
+
+	start = roundup(start, PAGE_SIZE);
+	end = roundup(start + new_size, PAGE_SIZE);
+
+	free_reserved_phys_range(end, crashk->end);
+
+	if (start == end)
+		release_resource(crashk);
+	crashk->end = end - 1;
+
+	return 0;
+}
+
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
-	unsigned long start, end;
+	unsigned long crash_size, low_size;
 
 	mutex_lock(&kexec_mutex);
 
@@ -1128,26 +1154,25 @@ int crash_shrink_memory(unsigned long new_size)
 		ret = -ENOENT;
 		goto unlock;
 	}
-	start = crashk_res.start;
-	end = crashk_res.end;
 
-	if (new_size >= end - start + 1) {
+	crash_size = low_size = crashk_res.end - crashk_res.start + 1;
+	crash_size += crashk_res_hi.end - crashk_res_hi.start + 1;
+
+	if (crash_size == new_size)
+		goto unlock;
+	if (crash_size < new_size) {
 		ret = -EINVAL;
-		if (new_size == end - start + 1)
-			ret = 0;
 		goto unlock;
 	}
 
-	start = roundup(start, PAGE_SIZE);
-	end = roundup(start + new_size, PAGE_SIZE);
-
-	free_reserved_phys_range(end, crashk_res.end);
-
-	if (start == end) {
-		crashk_res.end = end;
-		release_resource(&crashk_res);
+	if (new_size < low_size) {
+		/* Reap crashk_res_hi */
+		ret = crash_shrink_region(&crashk_res_hi, 0);
+		if (ret)
+			goto unlock;
+		ret = crash_shrink_region(&crashk_res, new_size);
 	} else
-		crashk_res.end = end - 1;
+		ret = crash_shrink_region(&crashk_res_hi, new_size - low_size);
 
 unlock:
 	mutex_unlock(&kexec_mutex);
-- 
1.7.0.1

