Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab2GAPFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 11:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab2GAPFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 11:05:07 -0400
Date: Sun, 1 Jul 2012 18:05:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, mtosatti@redhat.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] apic: fix kvm build on UP without IOAPIC
Message-ID: <20120701150506.GA31304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On UP i386, when APIC is disabled
# CONFIG_X86_UP_APIC is not set
# CONFIG_PCI_IOAPIC is not set

code looking at apicdrivers never has any effect but it
still gets compiled in. In particular, this causes
build failures with kvm, but it generally bloats the kernel
unnecessarily.

Fix by defining both __apicdrivers and __apicdrivers_end
to be NULL when CONFIG_X86_LOCAL_APIC is unset: I verified
that as the result any loop scanning __apicdrivers gets optimized out by
the compiler.

Warning: a .config with apic disabled doesn't seem to boot
for me (even without this patch). Still verifying why,
meanwhile this patch is compile-tested only.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Note: if this patch makes sense, can x86 maintainers
please ACK applying it through the kvm tree, since that is
where we see the issue that it addresses?
Avi, Marcelo, maybe you can carry this in kvm/linux-next as a temporary
measure so that linux-next builds?

 arch/x86/include/asm/apic.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eaff479..aa5b2ee 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -417,7 +417,12 @@ extern struct apic *apic;
 	__aligned(sizeof(struct apic *))				\
 	__section(.apicdrivers) = { &sym1, &sym2 }
 
+#ifdef CONFIG_X86_LOCAL_APIC
 extern struct apic *__apicdrivers[], *__apicdrivers_end[];
+#else
+#define __apicdrivers ((struct apic **)NULL)
+#define __apicdrivers_end ((struct apic **)NULL)
+#endif
 
 /*
  * APIC functionality to boot other CPUs - only used on SMP:
-- 
MST
