Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0DIOSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:18:14 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:48025 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0DIOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:18:09 -0400
Date: Fri, 9 Apr 2010 16:18:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.34-rc3
Message-ID: <20100409161804.32e14161@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Christian Borntraeger (1):
      [S390] s390: disable change bit override

Dan Carpenter (1):
      [S390] sclp_async: potential buffer overflow

Heiko Carstens (1):
      [S390] nss: add missing .previous statement to asm function

Julia Lawall (1):
      [S390] arch/s390/kernel: Add missing unlock

Martin Schwidefsky (3):
      [S390] fix io_return critical section cleanup
      [S390] increase default size of vmalloc area
      [S390] Update default configuration.

 arch/s390/defconfig             |   40 +++++++++++++++++++++++++++++---------
 arch/s390/include/asm/pgtable.h |    6 ++--
 arch/s390/kernel/early.c        |    3 +-
 arch/s390/kernel/entry.S        |    8 ++++++-
 arch/s390/kernel/entry64.S      |    8 ++++++-
 arch/s390/kernel/topology.c     |    3 +-
 arch/s390/mm/vmem.c             |   11 ++-------
 drivers/s390/char/sclp_async.c  |    2 +-
 8 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 7ae71cc..bcd6884 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.33-rc2
-# Mon Jan  4 09:03:07 2010
+# Linux kernel version: 2.6.34-rc3
+# Fri Apr  9 09:57:10 2010
 #
 CONFIG_SCHED_MC=y
 CONFIG_MMU=y
@@ -17,6 +17,7 @@ CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_TIME_VSYSCALL=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_GENERIC_BUG=y
+CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
 CONFIG_NO_IOMEM=y
 CONFIG_NO_DMA=y
 CONFIG_GENERIC_LOCKBREAK=y
@@ -62,15 +63,11 @@ CONFIG_TREE_RCU=y
 # CONFIG_RCU_TRACE is not set
 CONFIG_RCU_FANOUT=64
 # CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_RCU_FAST_NO_HZ is not set
 # CONFIG_TREE_RCU_TRACE is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=17
-CONFIG_GROUP_SCHED=y
-CONFIG_FAIR_GROUP_SCHED=y
-# CONFIG_RT_GROUP_SCHED is not set
-CONFIG_USER_SCHED=y
-# CONFIG_CGROUP_SCHED is not set
 CONFIG_CGROUPS=y
 # CONFIG_CGROUP_DEBUG is not set
 CONFIG_CGROUP_NS=y
@@ -79,6 +76,7 @@ CONFIG_CGROUP_NS=y
 # CONFIG_CPUSETS is not set
 # CONFIG_CGROUP_CPUACCT is not set
 # CONFIG_RESOURCE_COUNTERS is not set
+# CONFIG_CGROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_RELAY is not set
@@ -93,6 +91,7 @@ CONFIG_INITRAMFS_SOURCE=""
 CONFIG_RD_GZIP=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
+CONFIG_RD_LZO=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
@@ -126,6 +125,7 @@ CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
 # CONFIG_PROFILING is not set
+CONFIG_TRACEPOINTS=y
 CONFIG_HAVE_OPROFILE=y
 CONFIG_KPROBES=y
 CONFIG_HAVE_SYSCALL_WRAPPERS=y
@@ -134,6 +134,7 @@ CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
 CONFIG_HAVE_ARCH_TRACEHOOK=y
 CONFIG_USE_GENERIC_SMP_HELPERS=y
+CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
 CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES=y
 
 #
@@ -246,6 +247,7 @@ CONFIG_64BIT=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=32
 CONFIG_HOTPLUG_CPU=y
+# CONFIG_SCHED_BOOK is not set
 CONFIG_COMPAT=y
 CONFIG_SYSVIPC_COMPAT=y
 CONFIG_AUDIT_ARCH=y
@@ -345,13 +347,13 @@ CONFIG_PM_SLEEP=y
 CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION=""
 # CONFIG_PM_RUNTIME is not set
+CONFIG_PM_OPS=y
 CONFIG_NET=y
 
 #
 # Networking options
 #
 CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
 CONFIG_UNIX=y
 CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
@@ -529,6 +531,7 @@ CONFIG_NET_SCH_FIFO=y
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_NET_TCPPROBE is not set
+# CONFIG_NET_DROP_MONITOR is not set
 CONFIG_CAN=m
 CONFIG_CAN_RAW=m
 CONFIG_CAN_BCM=m
@@ -605,6 +608,7 @@ CONFIG_MISC_DEVICES=y
 #
 # SCSI device support
 #
+CONFIG_SCSI_MOD=y
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
 # CONFIG_SCSI_DMA is not set
@@ -863,6 +867,7 @@ CONFIG_MISC_FILESYSTEMS=y
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
+# CONFIG_LOGFS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_SQUASHFS is not set
 # CONFIG_VXFS_FS is not set
@@ -891,6 +896,7 @@ CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
+# CONFIG_CEPH_FS is not set
 # CONFIG_CIFS is not set
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
@@ -952,6 +958,7 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_LOCK_STAT is not set
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+CONFIG_STACKTRACE=y
 # CONFIG_DEBUG_KOBJECT is not set
 CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
@@ -973,12 +980,17 @@ CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
 # CONFIG_DEBUG_PAGEALLOC is not set
+CONFIG_NOP_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
 CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
+CONFIG_RING_BUFFER=y
+CONFIG_EVENT_TRACING=y
+CONFIG_CONTEXT_SWITCH_TRACER=y
+CONFIG_TRACING=y
 CONFIG_TRACING_SUPPORT=y
 CONFIG_FTRACE=y
 # CONFIG_FUNCTION_TRACER is not set
@@ -995,10 +1007,15 @@ CONFIG_BRANCH_PROFILE_NONE=y
 # CONFIG_KMEMTRACE is not set
 # CONFIG_WORKQUEUE_TRACER is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
+CONFIG_KPROBE_EVENT=y
+# CONFIG_RING_BUFFER_BENCHMARK is not set
 # CONFIG_DYNAMIC_DEBUG is not set
 CONFIG_SAMPLES=y
+# CONFIG_SAMPLE_TRACEPOINTS is not set
+# CONFIG_SAMPLE_TRACE_EVENTS is not set
 # CONFIG_SAMPLE_KOBJECT is not set
 # CONFIG_SAMPLE_KPROBES is not set
+# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
 
 #
 # Security options
@@ -1032,6 +1049,7 @@ CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_MANAGER2=y
 CONFIG_CRYPTO_GF128MUL=m
 # CONFIG_CRYPTO_NULL is not set
+# CONFIG_CRYPTO_PCRYPT is not set
 CONFIG_CRYPTO_WORKQUEUE=y
 # CONFIG_CRYPTO_CRYPTD is not set
 CONFIG_CRYPTO_AUTHENC=m
@@ -1119,7 +1137,7 @@ CONFIG_CRYPTO_SHA512_S390=m
 # CONFIG_CRYPTO_DES_S390 is not set
 # CONFIG_CRYPTO_AES_S390 is not set
 CONFIG_S390_PRNG=m
-# CONFIG_BINARY_PRINTF is not set
+CONFIG_BINARY_PRINTF=y
 
 #
 # Library routines
@@ -1136,14 +1154,16 @@ CONFIG_LIBCRC32C=m
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
 CONFIG_LZO_COMPRESS=m
-CONFIG_LZO_DECOMPRESS=m
+CONFIG_LZO_DECOMPRESS=y
 CONFIG_DECOMPRESS_GZIP=y
 CONFIG_DECOMPRESS_BZIP2=y
 CONFIG_DECOMPRESS_LZMA=y
+CONFIG_DECOMPRESS_LZO=y
 CONFIG_NLATTR=y
 CONFIG_HAVE_KVM=y
 CONFIG_VIRTUALIZATION=y
 CONFIG_KVM=m
+# CONFIG_VHOST_NET is not set
 CONFIG_VIRTIO=y
 CONFIG_VIRTIO_RING=y
 CONFIG_VIRTIO_BALLOON=m
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 9b5b918..89a504c 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -105,7 +105,7 @@ extern char empty_zero_page[PAGE_SIZE];
 #ifndef __ASSEMBLY__
 /*
  * The vmalloc area will always be on the topmost area of the kernel
- * mapping. We reserve 96MB (31bit) / 1GB (64bit) for vmalloc,
+ * mapping. We reserve 96MB (31bit) / 128GB (64bit) for vmalloc,
  * which should be enough for any sane case.
  * By putting vmalloc at the top, we maximise the gap between physical
  * memory and vmalloc to catch misplaced memory accesses. As a side
@@ -120,8 +120,8 @@ extern unsigned long VMALLOC_START;
 #define VMALLOC_END	0x7e000000UL
 #define VMEM_MAP_END	0x80000000UL
 #else /* __s390x__ */
-#define VMALLOC_SIZE	(1UL << 30)
-#define VMALLOC_END	0x3e040000000UL
+#define VMALLOC_SIZE	(128UL << 30)
+#define VMALLOC_END	0x3e000000000UL
 #define VMEM_MAP_END	0x40000000000UL
 #endif /* __s390x__ */
 
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 31d618a..2d92c2c 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -82,7 +82,8 @@ asm(
 	"	lm	6,15,24(15)\n"
 #endif
 	"	br	14\n"
-	"	.size	savesys_ipl_nss, .-savesys_ipl_nss\n");
+	"	.size	savesys_ipl_nss, .-savesys_ipl_nss\n"
+	"	.previous\n");
 
 static __initdata char upper_command_line[COMMAND_LINE_SIZE];
 
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 4348f9b..6af7045 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -964,7 +964,7 @@ cleanup_critical:
 	clc	4(4,%r12),BASED(cleanup_table_io_work_loop)
 	bl	BASED(0f)
 	clc	4(4,%r12),BASED(cleanup_table_io_work_loop+4)
-	bl	BASED(cleanup_io_return)
+	bl	BASED(cleanup_io_work_loop)
 0:
 	br	%r14
 
@@ -1039,6 +1039,12 @@ cleanup_sysc_leave_insn:
 
 cleanup_io_return:
 	mvc	__LC_RETURN_PSW(4),0(%r12)
+	mvc	__LC_RETURN_PSW+4(4),BASED(cleanup_table_io_return)
+	la	%r12,__LC_RETURN_PSW
+	br	%r14
+
+cleanup_io_work_loop:
+	mvc	__LC_RETURN_PSW(4),0(%r12)
 	mvc	__LC_RETURN_PSW+4(4),BASED(cleanup_table_io_work_loop)
 	la	%r12,__LC_RETURN_PSW
 	br	%r14
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 29fd0f1..52106d5 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -946,7 +946,7 @@ cleanup_critical:
 	clc	8(8,%r12),BASED(cleanup_table_io_work_loop)
 	jl	0f
 	clc	8(8,%r12),BASED(cleanup_table_io_work_loop+8)
-	jl	cleanup_io_return
+	jl	cleanup_io_work_loop
 0:
 	br	%r14
 
@@ -1021,6 +1021,12 @@ cleanup_sysc_leave_insn:
 
 cleanup_io_return:
 	mvc	__LC_RETURN_PSW(8),0(%r12)
+	mvc	__LC_RETURN_PSW+8(8),BASED(cleanup_table_io_return)
+	la	%r12,__LC_RETURN_PSW
+	br	%r14
+
+cleanup_io_work_loop:
+	mvc	__LC_RETURN_PSW(8),0(%r12)
 	mvc	__LC_RETURN_PSW+8(8),BASED(cleanup_table_io_work_loop)
 	la	%r12,__LC_RETURN_PSW
 	br	%r14
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 14ef6f0..247b4c2 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -165,10 +165,11 @@ static void tl_to_cores(struct tl_info *info)
 		default:
 			clear_cores();
 			machine_has_topology = 0;
-			return;
+			goto out;
 		}
 		tle = next_tle(tle);
 	}
+out:
 	spin_unlock_irq(&topology_lock);
 }
 
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 8ea3144..90165e7 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -71,12 +71,8 @@ static pte_t __ref *vmem_pte_alloc(void)
 		pte = alloc_bootmem(PTRS_PER_PTE * sizeof(pte_t));
 	if (!pte)
 		return NULL;
-	if (MACHINE_HAS_HPAGE)
-		clear_table((unsigned long *) pte, _PAGE_TYPE_EMPTY | _PAGE_CO,
-			    PTRS_PER_PTE * sizeof(pte_t));
-	else
-		clear_table((unsigned long *) pte, _PAGE_TYPE_EMPTY,
-			    PTRS_PER_PTE * sizeof(pte_t));
+	clear_table((unsigned long *) pte, _PAGE_TYPE_EMPTY,
+		    PTRS_PER_PTE * sizeof(pte_t));
 	return pte;
 }
 
@@ -117,8 +113,7 @@ static int vmem_add_mem(unsigned long start, unsigned long size, int ro)
 		if (MACHINE_HAS_HPAGE && !(address & ~HPAGE_MASK) &&
 		    (address + HPAGE_SIZE <= start + size) &&
 		    (address >= HPAGE_SIZE)) {
-			pte_val(pte) |= _SEGMENT_ENTRY_LARGE |
-					_SEGMENT_ENTRY_CO;
+			pte_val(pte) |= _SEGMENT_ENTRY_LARGE;
 			pmd_val(*pm_dir) = pte_val(pte);
 			address += HPAGE_SIZE - PAGE_SIZE;
 			continue;
diff --git a/drivers/s390/char/sclp_async.c b/drivers/s390/char/sclp_async.c
index 2aecf7f..7ad30e7 100644
--- a/drivers/s390/char/sclp_async.c
+++ b/drivers/s390/char/sclp_async.c
@@ -85,7 +85,7 @@ static int proc_handler_callhome(struct ctl_table *ctl, int write,
 		rc = copy_from_user(buf, buffer, sizeof(buf));
 		if (rc != 0)
 			return -EFAULT;
-		buf[len - 1] = '\0';
+		buf[sizeof(buf) - 1] = '\0';
 		if (strict_strtoul(buf, 0, &val) != 0)
 			return -EINVAL;
 		if (val != 0 && val != 1)
