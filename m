Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0DVQYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:24:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45177 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0DVQX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MV/rGyS35iqXZXnRoa1VatrEE1HSTDr6DUI7agbJ2Byojq9CV8TuQaODzWWh+ArIpu
         7LRlFPFY8dyVuxJ/bYHMrML16FGHnCyBXEXs6SFVNlsmsd9Pw+wCmxPbFZDTCR5Rya8n
         PJ6Lpy8WMLP7Es7bZpfC6mUbtWT/403wrKmiE=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: [PATCH 5/5] kexec: update documentation
Date: Thu, 22 Apr 2010 18:23:12 +0200
Message-Id: <1271953392-6324-6-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention new crashkernel= syntax in documentation.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 Documentation/kdump/kdump.txt       |   40 +++++++++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |   19 +++++++++++-----
 2 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index cab61d8..9f93d17 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -266,7 +266,47 @@ This would mean:
     2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
     3) if the RAM size is larger than 2G, then reserve 128M
 
+Avoiding memory reservation problem on large systems
+====================================================
 
+For large systems with huge amount of memory dump-capture kernel
+requires more memory to handle properly old kernel's pages. However,
+it raises issues with h/w-dependent limitations on some platforms. For
+example, on x86-64 system kernel and initrd still have to be placed in
+first 2 gigabytes, because kernel starts executing in 32-bit mode, and
+kdump purgatory code can jump only to 32-bit signed addresses. This
+limitation is a real problem in cases, when dump-capturing region is
+large and cannot fit in good area. For such cases it's possible to use
+special crashkernel syntax:
+
+    crashkernel=<low>/<high>
+
+<low> and <high> are memory regions for dump-capture kernel in usual
+crashkernel format (size@offset). For example:
+
+    crashkernel=64M/1G@4G
+
+This would mean to allocate 64M of memory at the lowest valid address
+and to allocate 1G at physical address 4G.
+
+New syntax for extended format (in case of memory dependent
+reservation):
+
+    crashkernel=<range1>:<low_size1>[/<high_size1>]
+                [,<range2>:<low_size2>[/high_size2],...]
+                [@low_offset][/high_offset]
+    range=start-[end]
+
+For example:
+
+    crashkernel=2G-32G:256M,32G-:256M/1G@0/8G
+
+This would mean:
+
+    1) if the RAM is smaller than 2G, then don't reserve anything
+    2) if the RAM size is between 2G and 32G (exclusive), then reserve 256M
+    3) if the RAM size is larger than 32G, then reserve 256M at first suitable
+    address (offset 0 means automatically) and reserve 1G at address 8G
 
 Boot into System Kernel
 =======================
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e2202e9..5e9f234 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -568,16 +568,23 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format:
 			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
 
-	crashkernel=nn[KMG]@ss[KMG]
-			[KNL] Reserve a chunk of physical memory to
-			hold a kernel to switch to with kexec on panic.
-
-	crashkernel=range1:size1[,range2:size2,...][@offset]
-			[KNL] Same as above, but depends on the memory
+	crashkernel=	[KNL]
+		nn[KMG]@ss[KMG]
+			Reserve a chunk of physical memory to hold a
+			kernel to switch to with kexec on panic.
+		nn1[KMG]@ss1[KMG]/nn2[KMG]@ss2[KMG]
+			Same as above, but reserve 2 chunks of
+			physical memory.
+
+	crashkernel=	[KNL]
+		range1:size1[,range2:size2,...][@offset]
+			Same as above, but depends on the memory
 			in the running system. The syntax of range is
 			start-[end] where start and end are both
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for a example.
+		range1:size1lo/size1hi[,range2:size2lo/size2hi,...][@offset_lo][/offset_hi]
+			Same as above, but reserve 2 chunks of memory.
 
 	cs89x0_dma=	[HW,NET]
 			Format: <dma>
-- 
1.7.0.1

