Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab2HaIOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:14:06 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:34646 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2HaIOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:14:02 -0400
Date: Fri, 31 Aug 2012 10:13:55 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.6-rc4
Message-ID: <20120831101355.433a1745@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12083108-3548-0000-0000-000002F9E21B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive a couple of s390 bug fixes for 3.5-rc4:

Geert Uytterhoeven (1):
      s390: Always use "long" for ssize_t to match size_t

Heiko Carstens (3):
      s390/dasd: fix ioctl return value
      s390/smp: add missing smp_store_status() for !SMP
      s390/32: Don't clobber personality flags on exec

 arch/s390/include/asm/elf.h         |    3 ++-
 arch/s390/include/asm/posix_types.h |    3 +--
 arch/s390/include/asm/smp.h         |    1 +
 drivers/s390/block/dasd_eckd.c      |    2 +-
 drivers/s390/block/dasd_ioctl.c     |    7 ++-----
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index 32e8449..9b94a16 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -180,7 +180,8 @@ extern char elf_platform[];
 #define ELF_PLATFORM (elf_platform)
 
 #ifndef CONFIG_64BIT
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 #else /* CONFIG_64BIT */
 #define SET_PERSONALITY(ex)					\
 do {								\
diff --git a/arch/s390/include/asm/posix_types.h b/arch/s390/include/asm/posix_types.h
index 7bcc14e..bf2a2ad 100644
--- a/arch/s390/include/asm/posix_types.h
+++ b/arch/s390/include/asm/posix_types.h
@@ -13,6 +13,7 @@
  */
 
 typedef unsigned long   __kernel_size_t;
+typedef long            __kernel_ssize_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short	__kernel_old_dev_t;
@@ -25,7 +26,6 @@ typedef unsigned short  __kernel_mode_t;
 typedef unsigned short  __kernel_ipc_pid_t;
 typedef unsigned short  __kernel_uid_t;
 typedef unsigned short  __kernel_gid_t;
-typedef int             __kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
 
 #else /* __s390x__ */
@@ -35,7 +35,6 @@ typedef unsigned int    __kernel_mode_t;
 typedef int             __kernel_ipc_pid_t;
 typedef unsigned int    __kernel_uid_t;
 typedef unsigned int    __kernel_gid_t;
-typedef long            __kernel_ssize_t;
 typedef long            __kernel_ptrdiff_t;
 typedef unsigned long   __kernel_sigset_t;      /* at least 32 bits */
 
diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index a0a8340..ce26ac3 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -44,6 +44,7 @@ static inline void smp_call_online_cpu(void (*func)(void *), void *data)
 }
 
 static inline int smp_find_processor_id(int address) { return 0; }
+static inline int smp_store_status(int cpu) { return 0; }
 static inline int smp_vcpu_scheduled(int cpu) { return 1; }
 static inline void smp_yield_cpu(int cpu) { }
 static inline void smp_yield(void) { }
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 40a826a..2fb2b9e 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3804,7 +3804,7 @@ dasd_eckd_ioctl(struct dasd_block *block, unsigned int cmd, void __user *argp)
 	case BIODASDSYMMIO:
 		return dasd_symm_io(device, argp);
 	default:
-		return -ENOIOCTLCMD;
+		return -ENOTTY;
 	}
 }
 
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index cceae70..654c692 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -498,12 +498,9 @@ int dasd_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	default:
 		/* if the discipline has an ioctl method try it. */
-		if (base->discipline->ioctl) {
+		rc = -ENOTTY;
+		if (base->discipline->ioctl)
 			rc = base->discipline->ioctl(block, cmd, argp);
-			if (rc == -ENOIOCTLCMD)
-				rc = -EINVAL;
-		} else
-			rc = -EINVAL;
 	}
 	dasd_put_device(base);
 	return rc;

