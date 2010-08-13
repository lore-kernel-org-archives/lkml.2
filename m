Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313Ab0HMIMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 04:12:13 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:56279 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab0HMIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 04:12:09 -0400
Date: Fri, 13 Aug 2010 10:12:03 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.35+ #2
Message-ID: <20100813101203.3848cd17@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
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

Heiko Carstens (6):
      [S390] dasd: fix format string types
      [S390] sys_personality: follow u_long to unsigned int conversion
      [S390] zcrypt: fix Kconfig dependencies
      [S390] wire up prlimit64 and fanotify* syscalls
      [S390] appldata: fix dev_get_stats 64 bit conversion
      [S390] partitions: fix build error in ibm partition detection code

 arch/s390/appldata/appldata_net_sum.c |    3 ++-
 arch/s390/include/asm/unistd.h        |    5 ++++-
 arch/s390/kernel/compat_wrapper.S     |   26 +++++++++++++++++++++++++-
 arch/s390/kernel/entry.h              |    2 +-
 arch/s390/kernel/sys_s390.c           |    4 ++--
 arch/s390/kernel/syscalls.S           |    3 +++
 drivers/crypto/Kconfig                |    2 +-
 drivers/s390/block/dasd.c             |    4 ++--
 fs/partitions/ibm.c                   |    2 +-
 9 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index f02e89c..5da7c56 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -85,9 +85,10 @@ static void appldata_get_net_sum_data(void *data)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
+		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;
-		const struct net_device_stats *stats = dev_get_stats(dev, &temp);
 
+		stats = dev_get_stats(dev, &temp);
 		rx_packets += stats->rx_packets;
 		tx_packets += stats->tx_packets;
 		rx_bytes   += stats->rx_bytes;
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 5f00751..1049ef2 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -269,7 +269,10 @@
 #define	__NR_pwritev		329
 #define __NR_rt_tgsigqueueinfo	330
 #define __NR_perf_event_open	331
-#define NR_syscalls 332
+#define __NR_fanotify_init	332
+#define __NR_fanotify_mark	333
+#define __NR_prlimit64		334
+#define NR_syscalls 335
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 672ce52..8e60fb2 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -614,7 +614,7 @@ sys32_sysfs_wrapper:
 
 	.globl	sys32_personality_wrapper
 sys32_personality_wrapper:
-	llgfr	%r2,%r2			# unsigned long
+	llgfr	%r2,%r2			# unsigned int
 	jg	sys_s390_personality	# branch to system call
 
 	.globl	sys32_setfsuid16_wrapper
@@ -1853,3 +1853,27 @@ sys32_execve_wrapper:
 	llgtr	%r3,%r3			# compat_uptr_t *
 	llgtr	%r4,%r4			# compat_uptr_t *
 	jg	sys32_execve		# branch to system call
+
+	.globl	sys_fanotify_init_wrapper
+sys_fanotify_init_wrapper:
+	llgfr	%r2,%r2			# unsigned int
+	llgfr	%r3,%r3			# unsigned int
+	jg	sys_fanotify_init	# branch to system call
+
+	.globl	sys_fanotify_mark_wrapper
+sys_fanotify_mark_wrapper:
+	lgfr	%r2,%r2			# int
+	llgfr	%r3,%r3			# unsigned int
+	sllg	%r4,%r4,32		# get high word of 64bit mask
+	lr	%r4,%r5			# get low word of 64bit mask
+	llgfr	%r5,%r6			# unsigned int
+	llgt	%r6,164(%r15)		# char *
+	jg	sys_fanotify_mark	# branch to system call
+
+	.globl	sys_prlimit64_wrapper
+sys_prlimit64_wrapper:
+	lgfr	%r2,%r2			# pid_t
+	llgfr	%r3,%r3			# unsigned int
+	llgtr	%r4,%r4			# const struct rlimit64 __user *
+	llgtr	%r5,%r5			# struct rlimit64 __user *
+	jg	sys_prlimit64		# branch to system call
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index eb15c12..5bb1e6b 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -31,7 +31,7 @@ struct old_sigaction;
 long sys_mmap2(struct s390_mmap_arg_struct __user  *arg);
 long sys_s390_ipc(uint call, int first, unsigned long second,
 	     unsigned long third, void __user *ptr);
-long sys_s390_personality(unsigned long personality);
+long sys_s390_personality(unsigned int personality);
 long sys_s390_fadvise64(int fd, u32 offset_high, u32 offset_low,
 		    size_t len, int advice);
 long sys_s390_fadvise64_64(struct fadvise64_64_args __user *args);
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index 7b6b0f8..4760814 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -131,9 +131,9 @@ SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
 }
 
 #ifdef CONFIG_64BIT
-SYSCALL_DEFINE1(s390_personality, unsigned long, personality)
+SYSCALL_DEFINE1(s390_personality, unsigned int, personality)
 {
-	int ret;
+	unsigned int ret;
 
 	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
 		personality = PER_LINUX32;
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 201ce6b..a8fee1b 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -340,3 +340,6 @@ SYSCALL(sys_preadv,sys_preadv,compat_sys_preadv_wrapper)
 SYSCALL(sys_pwritev,sys_pwritev,compat_sys_pwritev_wrapper)
 SYSCALL(sys_rt_tgsigqueueinfo,sys_rt_tgsigqueueinfo,compat_sys_rt_tgsigqueueinfo_wrapper) /* 330 */
 SYSCALL(sys_perf_event_open,sys_perf_event_open,sys_perf_event_open_wrapper)
+SYSCALL(sys_fanotify_init,sys_fanotify_init,sys_fanotify_init_wrapper)
+SYSCALL(sys_fanotify_mark,sys_fanotify_mark,sys_fanotify_mark_wrapper)
+SYSCALL(sys_prlimit64,sys_prlimit64,sys_prlimit64_wrapper)
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index fbf94cf..ea0b386 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -77,7 +77,7 @@ config ZCRYPT
 
 config ZCRYPT_MONOLITHIC
 	bool "Monolithic zcrypt module"
-	depends on ZCRYPT="m"
+	depends on ZCRYPT
 	help
 	  Select this option if you want to have a single module z90crypt,
 	  that contains all parts of the crypto device driver (ap bus,
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 1a84fae..8373ca0 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1325,14 +1325,14 @@ static void __dasd_device_check_expire(struct dasd_device *device)
 		if (device->discipline->term_IO(cqr) != 0) {
 			/* Hmpf, try again in 5 sec */
 			dev_err(&device->cdev->dev,
-				"cqr %p timed out (%is) but cannot be "
+				"cqr %p timed out (%lus) but cannot be "
 				"ended, retrying in 5 s\n",
 				cqr, (cqr->expires/HZ));
 			cqr->expires += 5*HZ;
 			dasd_device_set_timer(device, 5*HZ);
 		} else {
 			dev_err(&device->cdev->dev,
-				"cqr %p timed out (%is), %i retries "
+				"cqr %p timed out (%lus), %i retries "
 				"remaining\n", cqr, (cqr->expires/HZ),
 				cqr->retries);
 		}
diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index d1b8a5c..d513a07 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -182,7 +182,7 @@ int ibm_partition(struct parsed_partitions *state)
 				offset = (info->label_block + 1);
 			} else {
 				/* unlabeled disk */
-				strlcat(tmp, sizeof(tmp), "(nonl)", PAGE_SIZE);
+				strlcat(state->pp_buf, "(nonl)", PAGE_SIZE);
 				size = i_size >> 9;
 				offset = (info->label_block + 1);
 			}
