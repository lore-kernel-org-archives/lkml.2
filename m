Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab2ERKr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:47:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab2ERKrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:47:24 -0400
Date: Fri, 18 May 2012 03:47:13 -0700
From: "tip-bot for Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <tip-0ab711ae6ab0db7696b43c74f9ba9de4d7fc1deb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, mst@redhat.com, mtosatti@redhat.com,
        tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, mtosatti@redhat.com,
        tglx@linutronix.de, avi@redhat.com
In-Reply-To: <e019d1a125316f10d3e3a4b2f6bda41473f4fb72.1337184153.git.mst@redhat.com>
References: <e019d1a125316f10d3e3a4b2f6bda41473f4fb72.1337184153.git.mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Implement EIO micro-optimization
Git-Commit-ID: 0ab711ae6ab0db7696b43c74f9ba9de4d7fc1deb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:47:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ab711ae6ab0db7696b43c74f9ba9de4d7fc1deb
Gitweb:     http://git.kernel.org/tip/0ab711ae6ab0db7696b43c74f9ba9de4d7fc1deb
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Wed, 16 May 2012 19:03:58 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 09:46:09 +0200

x86/apic: Implement EIO micro-optimization

We know both register and value for eoi beforehand,
so there's no need to check it and no need to do math
to calculate the msr. Saves instructions/branches
on each EOI when using x2apic.

I looked at the objdump output to verify that the
generated code looks right and actually is shorter.

The real improvemements will be on the KVM guest side
though, those come in a later patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: gleb@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/e019d1a125316f10d3e3a4b2f6bda41473f4fb72.1337184153.git.mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h           |    5 +++++
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index bf8d065..eaff479 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -138,6 +138,11 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 	wrmsr(APIC_BASE_MSR + (reg >> 4), v, 0);
 }
 
+static inline void native_apic_msr_eoi_write(u32 reg, u32 v)
+{
+	wrmsr(APIC_BASE_MSR + (APIC_EOI >> 4), APIC_EOI_ACK, 0);
+}
+
 static inline u32 native_apic_msr_read(u32 reg)
 {
 	u64 msr;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index a5baa78..ff35cff 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -260,7 +260,7 @@ static struct apic apic_x2apic_cluster = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
-	.eoi_write			= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8340356..c17e982 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -172,7 +172,7 @@ static struct apic apic_x2apic_phys = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
-	.eoi_write			= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 5b0e3d0..c6d03f7 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -404,7 +404,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
-	.eoi_write			= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
