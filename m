Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2EKHiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab2EKHiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:38:15 -0400
Date: Fri, 11 May 2012 10:38:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 3/7] x86: add apic->eoi_write callback
Message-ID: <c9dfa88160a52d906f51652fcc999e04261daf37.1336679924.git.mst@redhat.com>
References: <cover.1336679924.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336679924.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add eoi_write callback so that kvm can override
eoi accesses without touching the rest of the apic.
As a side-effect, this will enable a micro-optimization
for apics using msr.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/apic.h           |   15 ++++++++++++++-
 arch/x86/kernel/apic/apic_flat_64.c   |    2 ++
 arch/x86/kernel/apic/apic_noop.c      |    1 +
 arch/x86/kernel/apic/apic_numachip.c  |    1 +
 arch/x86/kernel/apic/bigsmp_32.c      |    1 +
 arch/x86/kernel/apic/es7000_32.c      |    2 ++
 arch/x86/kernel/apic/numaq_32.c       |    1 +
 arch/x86/kernel/apic/probe_32.c       |    1 +
 arch/x86/kernel/apic/summit_32.c      |    1 +
 arch/x86/kernel/apic/x2apic_cluster.c |    1 +
 arch/x86/kernel/apic/x2apic_phys.c    |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c    |    1 +
 12 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a09e9ab..74efb8d 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -351,6 +351,13 @@ struct apic {
 	/* apic ops */
 	u32 (*read)(u32 reg);
 	void (*write)(u32 reg, u32 v);
+        /*
+	 * eoi_write has the same signature as write.
+	 * Drivers can support both eoi_write and write by passing the same
+	 * callback value. Kernel can override eoi_write and fall back
+	 * on write for EOI.
+	 */
+	void (*eoi_write)(u32 reg, u32 v);
 	u64 (*icr_read)(void);
 	void (*icr_write)(u32 low, u32 high);
 	void (*wait_icr_idle)(void);
@@ -426,6 +433,11 @@ static inline void apic_write(u32 reg, u32 val)
 	apic->write(reg, val);
 }
 
+static inline void apic_eoi(void)
+{
+	apic->eoi_write(APIC_EOI, APIC_EOI_ACK);
+}
+
 static inline u64 apic_icr_read(void)
 {
 	return apic->icr_read();
@@ -450,6 +462,7 @@ static inline u32 safe_apic_wait_icr_idle(void)
 
 static inline u32 apic_read(u32 reg) { return 0; }
 static inline void apic_write(u32 reg, u32 val) { }
+static inline void apic_eoi(void) { }
 static inline u64 apic_icr_read(void) { return 0; }
 static inline void apic_icr_write(u32 low, u32 high) { }
 static inline void apic_wait_icr_idle(void) { }
@@ -463,7 +476,7 @@ static inline void ack_APIC_irq(void)
 	 * ack_APIC_irq() actually gets compiled as a single instruction
 	 * ... yummie.
 	 */
-	apic_write(APIC_EOI, APIC_EOI_ACK);
+	apic_eoi();
 }
 
 static inline unsigned default_get_apic_id(unsigned long x)
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 359b689..0e881c4 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -227,6 +227,7 @@ static struct apic apic_flat =  {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
@@ -386,6 +387,7 @@ static struct apic apic_physflat =  {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 634ae6c..a6e4c6e 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -181,6 +181,7 @@ struct apic apic_noop = {
 
 	.read				= noop_apic_read,
 	.write				= noop_apic_write,
+	.eoi_write			= noop_apic_write,
 	.icr_read			= noop_apic_icr_read,
 	.icr_write			= noop_apic_icr_write,
 	.wait_icr_idle			= noop_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 23e7542..6ec6d5d 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -295,6 +295,7 @@ static struct apic apic_numachip __refconst = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 0cdec70..31fbdbf 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -248,6 +248,7 @@ static struct apic apic_bigsmp = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index e42d1d3b9..db4ab1b 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -678,6 +678,7 @@ static struct apic __refdata apic_es7000_cluster = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
@@ -742,6 +743,7 @@ static struct apic __refdata apic_es7000 = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 00d2422..f00a68c 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -530,6 +530,7 @@ static struct apic __refdata apic_numaq = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index ff2c1b9..1b291da 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -142,6 +142,7 @@ static struct apic apic_default = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index fea000b..659897c 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -546,6 +546,7 @@ static struct apic apic_summit = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 48f3103..a5baa78 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -260,6 +260,7 @@ static struct apic apic_x2apic_cluster = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 991e315..8340356 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -172,6 +172,7 @@ static struct apic apic_x2apic_phys = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 87bfa69..5b0e3d0 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -404,6 +404,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
-- 
MST

