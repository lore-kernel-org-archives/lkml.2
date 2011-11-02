Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1KBKCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:02:32 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:49080 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1KBKCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:02:31 -0400
Message-ID: <1320228143.2776.12.camel@br98xy6r>
Subject: [PATCH] kdump: Add missing RAM resource in crash_shrink_memory()
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Date: Wed, 02 Nov 2011 11:02:23 +0100
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

When shrinking crashkernel memory using /sys/kernel/kexec_crash_size for
the newly added memory no RAM resource is created at the moment.

Example:

$ cat /proc/iomem
00000000-bfffffff : System RAM
  00000000-005b7ac3 : Kernel code
  005b7ac4-009743bf : Kernel data
  009bb000-00a85c33 : Kernel bss
c0000000-cfffffff : Crash kernel
d0000000-ffffffff : System RAM

$ echo 0 > /sys/kernel/kexec_crash_size
$ cat /proc/iomem
00000000-bfffffff : System RAM
  00000000-005b7ac3 : Kernel code
  005b7ac4-009743bf : Kernel data
  009bb000-00a85c33 : Kernel bss
                                 <<-- here is System RAM missing
d0000000-ffffffff : System RAM

One result of this bug is that the memory chunk can never be set offline
using memory hotplug. With this patch I insert a new "System RAM" resource
for the released memory. Then the upper example looks like the following:

$ echo 0 > /sys/kernel/kexec_crash_size
$ cat /proc/iomem
00000000-bfffffff : System RAM
  00000000-005b7ac3 : Kernel code
  005b7ac4-009743bf : Kernel data
  009bb000-00a85c33 : Kernel bss
c0000000-cfffffff : System RAM   <<-- new rescoure
d0000000-ffffffff : System RAM

And now I can set chunk c0000000-cfffffff offline.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 kernel/kexec.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1132,6 +1132,7 @@ int crash_shrink_memory(unsigned long ne
 {
 	int ret = 0;
 	unsigned long start, end;
+	struct resource *ram_res;
 
 	mutex_lock(&kexec_mutex);
 
@@ -1149,6 +1150,12 @@ int crash_shrink_memory(unsigned long ne
 		goto unlock;
 	}
 
+	ram_res = kzalloc(sizeof(*ram_res), GFP_KERNEL);
+	if (!ram_res) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
 	start = roundup(start, KEXEC_CRASH_MEM_ALIGN);
 	end = roundup(start + new_size, KEXEC_CRASH_MEM_ALIGN);
 
@@ -1157,7 +1164,15 @@ int crash_shrink_memory(unsigned long ne
 
 	if ((start == end) && (crashk_res.parent != NULL))
 		release_resource(&crashk_res);
+
+	ram_res->start = end;
+	ram_res->end = crashk_res.end;
+	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
+	ram_res->name = "System RAM";
+
 	crashk_res.end = end - 1;
+
+	insert_resource(&iomem_resource, ram_res);
 	crash_unmap_reserved_pages();
 
 unlock:


