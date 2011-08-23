Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1HWXjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:39:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:57365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab1HWXjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:39:08 -0400
Date: Tue, 23 Aug 2011 23:38:22 GMT
Message-Id: <201108232338.p7NNcMw2031946@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 3.1-rc4
Cc: <stable@kernel.org>, Andres Salomon <dilinger@queued.net>,
        Daniel Drake <dsd@laptop.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jack Steiner <steiner@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Fox <pgf@laptop.org>, Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 23 Aug 2011 23:38:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 140d0b2108faebc77c6523296e211e509cb9f5f9:

  Do 'shm_init_ns()' in an early pure_initcall (2011-08-04 19:35:59 -1000)

Note: the int $0x80 commit will look newer than it really is; I
amended the description to Cc:stable on it.

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

H. Peter Anvin (1):
      x86-32, vdso: On system call restart after SYSENTER, use int $0x80

Jack Steiner (1):
      x86, UV: Remove UV delay in starting slave cpus

Paul Fox (1):
      x86, olpc: Wait for last byte of EC command to be accepted

 arch/x86/kernel/apic/x2apic_uv_x.c |    1 -
 arch/x86/platform/olpc/olpc.c      |    4 ++--
 arch/x86/vdso/vdso32/sysenter.S    |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index adc66c3..34b1859 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -207,7 +207,6 @@ static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_ri
 	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_INIT;
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
-	mdelay(10);
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 8b9940e..7cce722 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -161,13 +161,13 @@ restart:
 	if (inbuf && inlen) {
 		/* write data to EC */
 		for (i = 0; i < inlen; i++) {
+			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
+			outb(inbuf[i], 0x68);
 			if (wait_on_ibf(0x6c, 0)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC accept data!\n");
 				goto err;
 			}
-			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
-			outb(inbuf[i], 0x68);
 		}
 	}
 	if (outbuf && outlen) {
diff --git a/arch/x86/vdso/vdso32/sysenter.S b/arch/x86/vdso/vdso32/sysenter.S
index e2800af..e354bce 100644
--- a/arch/x86/vdso/vdso32/sysenter.S
+++ b/arch/x86/vdso/vdso32/sysenter.S
@@ -43,7 +43,7 @@ __kernel_vsyscall:
 	.space 7,0x90
 
 	/* 14: System call restart point is here! (SYSENTER_RETURN-2) */
-	jmp .Lenter_kernel
+	int $0x80
 	/* 16: System call normal return point is here! */
 VDSO32_SYSENTER_RETURN:	/* Symbol used by sysenter.c via vdso32-syms.h */
 	pop %ebp
