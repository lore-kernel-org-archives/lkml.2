Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab1GDRLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:11:15 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:41603 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab1GDRKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:10:06 -0400
Message-Id: <20110704171000.123254263@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Mon, 04 Jul 2011 19:09:31 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: ebiederm@xmission.com, vgoyal@redhat.com, hbabu@us.ibm.com,
        mahesh@linux.vnet.ibm.com
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 9/9] kexec-tools: Add s390 kdump support
References: <20110704170922.976299676@linux.vnet.ibm.com>
Content-Disposition: inline; filename=kexec-tools-s390-kdump.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch adds kdump support for s390 to the kexec tool and enables the
"--load-panic" option. When loading the kdump kernel and ramdisk we add the
address of the crashkernel memory to the normal load address.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 kexec/arch/s390/kexec-image.c |   16 +++++++++++++---
 kexec/arch/s390/kexec-s390.c  |   24 +++++++++++++++++++++---
 2 files changed, 34 insertions(+), 6 deletions(-)

--- a/kexec/arch/s390/kexec-image.c
+++ b/kexec/arch/s390/kexec-image.c
@@ -18,6 +18,7 @@
 #include <unistd.h>
 #include <getopt.h>
 #include "../../kexec.h"
+#include "../../kexec-syscall.h"
 #include "kexec-s390.h"
 #include <arch/options.h>
 
@@ -32,6 +33,7 @@ image_s390_load(int argc, char **argv, c
 	int command_line_len;
 	off_t ramdisk_len;
 	unsigned int ramdisk_origin;
+	uint64_t crash_base, crash_end;
 	int opt;
 
 	static const struct option options[] =
@@ -47,6 +49,7 @@ image_s390_load(int argc, char **argv, c
 	command_line = NULL;
 	ramdisk_len = 0;
 	ramdisk_origin = 0;
+	crash_base = 0;
 
 	while ((opt = getopt_long(argc,argv,short_options,options,0)) != -1) {
 		switch(opt) {
@@ -71,10 +74,16 @@ image_s390_load(int argc, char **argv, c
 			return -1;
 		}
 	}
+	if (info->kexec_flags & KEXEC_ON_CRASH) {
+		if (parse_iomem_single("Crash kernel\n", &crash_base,
+				       &crash_end))
+			return -1;
+	}
 
 	/* Add kernel segment */
 	add_segment(info, kernel_buf + IMAGE_READ_OFFSET,
-		    kernel_size - IMAGE_READ_OFFSET, IMAGE_READ_OFFSET,
+		    kernel_size - IMAGE_READ_OFFSET,
+		    crash_base + IMAGE_READ_OFFSET,
 		    kernel_size - IMAGE_READ_OFFSET);
 
 	/* We do want to change the kernel image */
@@ -88,7 +97,8 @@ image_s390_load(int argc, char **argv, c
 			return -1;
 		}
 		ramdisk_origin = RAMDISK_ORIGIN_ADDR;
-		add_segment(info, rd_buffer, ramdisk_len, RAMDISK_ORIGIN_ADDR, ramdisk_len);
+		add_segment(info, rd_buffer, ramdisk_len,
+			    crash_base + RAMDISK_ORIGIN_ADDR, ramdisk_len);
 	}
 	
 	/* Register the ramdisk in the kernel. */
@@ -111,7 +121,7 @@ image_s390_load(int argc, char **argv, c
 		memcpy(krnl_buffer + COMMAND_LINE_OFFS, command_line, strlen(command_line));
 	}
 
-	info->entry = (void *) IMAGE_READ_OFFSET;
+	info->entry = (void *) crash_base + IMAGE_READ_OFFSET;
 
 	return 0;
 }
--- a/kexec/arch/s390/kexec-s390.c
+++ b/kexec/arch/s390/kexec-s390.c
@@ -37,8 +37,9 @@ static struct memory_range memory_range[
  */
 
 int get_memory_ranges(struct memory_range **range, int *ranges,
-		      unsigned long UNUSED(flags))
+		      unsigned long flags)
 {
+	char crash_kernel[] = "Crash kernel\n";
 	char sys_ram[] = "System RAM\n";
 	const char *iomem = proc_iomem();
 	FILE *fp;
@@ -62,7 +63,9 @@ int get_memory_ranges(struct memory_rang
 
 		sscanf(line,"%Lx-%Lx : %n", &start, &end, &cons);
 		str = line+cons;
-		if(memcmp(str,sys_ram,strlen(sys_ram)) == 0) {
+		if((memcmp(str,sys_ram,strlen(sys_ram)) == 0) ||
+		   ((flags & KEXEC_ON_CRASH) &&
+		   memcmp(str,crash_kernel,strlen(crash_kernel)) == 0)) {
 			memory_range[current_range].start = start;
 			memory_range[current_range].end = end;
 			memory_range[current_range].type = RANGE_RAM;
@@ -76,6 +79,18 @@ int get_memory_ranges(struct memory_rang
 	*range = memory_range;
 	*ranges = current_range;
 
+	if ((flags & KEXEC_ON_CRASH) && !(flags & KEXEC_PRESERVE_CONTEXT)) {
+		uint64_t start, end;
+
+		if (parse_iomem_single("Crash kernel\n", &start, &end)) {
+			fprintf(stderr, "parse_iomem_single failed.\n");
+			return -1;
+		}
+		if (start > mem_min)
+			mem_min = start;
+		if (end < mem_max)
+			mem_max = end;
+	}
 	return 0;
 }
 
@@ -112,5 +127,8 @@ void arch_update_purgatory(struct kexec_
 
 int is_crashkernel_mem_reserved(void)
 {
-	return 0; /* kdump is not supported on this platform (yet) */
+	uint64_t start, end;
+
+	return parse_iomem_single("Crash kernel\n", &start, &end) == 0 ?
+		(start != end) : 0;
 }

