Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1A0Vsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:48:35 -0500
Received: from smtp-out.google.com ([74.125.121.67]:19833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1A0Vsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:48:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=O283fgvEpJUhPtF+dxqSDabn1ye9YYOCRsTgsZQ2fIhnADYHKUka+nLi3E0ZgSYk1E
         nnZIia1JtNFNOoz7FGMA==
Date: Thu, 27 Jan 2011 13:48:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch v2 4/4] x86: allow CONFIG_ISA_DMA_API to be disabled
In-Reply-To: <201101270923.37476.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1101271345410.8425@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com> <alpine.DEB.2.00.1101261914060.7809@chino.kir.corp.google.com> <201101270923.37476.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Arnd Bergmann wrote:

> But the x86_64 machines can also run 32 bit kernel, and I would expect
> that they don't need ISA DMA in that configuration either.
> 
> I think it would make sense to let the CONFIG_EXPERT user disable
> DMA for 32 bit as well.
> 

Hmm, ok, I originally thought that allowing it to be disabled for 32-bit 
would cause people to regret it later when using pnp, for instance, and 
finding they need to require ISA-style DMA support for their devices.  I 
agree, though, that allowing CONFIG_EXPERT to disable it even for 32-bit 
sounds appropriate since they ultimately know what devices they're 
limiting their kernel from using.  Thanks!


x86: allow CONFIG_ISA_DMA_API to be disabled

Not all 64-bit systems require ISA-style DMA, so allow it to be
configurable.  x86 utilizes the generic ISA DMA allocator from
kernel/dma.c, so require it only when CONFIG_ISA_DMA_API is enabled.

64-bit systems may compile a 32-bit kernel, so allow disabling it for
i386 as well.

Disabling CONFIG_ISA_DMA_API is dependent on CONFIG_EXPERT as required by
H. Peter Anvin.

When disabled, this also avoids declaring claim_dma_lock(),
release_dma_lock(), request_dma(), and free_dma() since those interfaces
will no longer be provided.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/Kconfig           |   10 +++++++---
 arch/x86/include/asm/dma.h |    6 +++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -119,7 +119,7 @@ config NEED_SG_DMA_LENGTH
 	def_bool y
 
 config GENERIC_ISA_DMA
-	def_bool y
+	def_bool ISA_DMA_API
 
 config GENERIC_IOMAP
 	def_bool y
@@ -2000,9 +2000,13 @@ source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
 
-# x86_64 have no ISA slots, but do have ISA-style DMA.
+# x86_64 have no ISA slots, but can have ISA-style DMA.
 config ISA_DMA_API
-	def_bool y
+	bool "ISA-style DMA support" if EXPERT
+	default y
+	help
+	  Enables ISA-style DMA support for devices requiring such controllers.
+	  If unsure, say Y.
 
 if X86_32
 
diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -151,6 +151,7 @@
 #define DMA_AUTOINIT		0x10
 
 
+#ifdef CONFIG_ISA_DMA_API
 extern spinlock_t  dma_spin_lock;
 
 static inline unsigned long claim_dma_lock(void)
@@ -164,6 +165,7 @@ static inline void release_dma_lock(unsigned long flags)
 {
 	spin_unlock_irqrestore(&dma_spin_lock, flags);
 }
+#endif /* CONFIG_ISA_DMA_API */
 
 /* enable/disable a specific DMA channel */
 static inline void enable_dma(unsigned int dmanr)
@@ -303,9 +305,11 @@ static inline int get_dma_residue(unsigned int dmanr)
 }
 
 
-/* These are in kernel/dma.c: */
+/* These are in kernel/dma.c because x86 uses CONFIG_GENERIC_ISA_DMA */
+#ifdef CONFIG_ISA_DMA_API
 extern int request_dma(unsigned int dmanr, const char *device_id);
 extern void free_dma(unsigned int dmanr);
+#endif
 
 /* From PCI */
 
