Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1BCPEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:04:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab1BCPEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:04:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: ARM unaligned MMIO access with attribute((packed))
Date: Thu, 3 Feb 2011 16:03:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Peter Maydell <peter.maydell@linaro.org>, gcc@gcc.gnu.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
References: <201102021700.20683.arnd@arndb.de> <20110202163702.GA23240@n2100.arm.linux.org.uk>
In-Reply-To: <20110202163702.GA23240@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102031603.51628.arnd@arndb.de>
X-Provags-ID: V02:K0:gdMZvlWY0/J5nH4SLIsCaPeSX8q1Wnok8mXKKeOEOJD
 kINr1yyWhuWeyA4C0G/UquV+ZmqVrmEm3xUeEJVu+ibfNTm5UO
 bJldvuj3Gkk2W5Ylea7+aBFu/PcZCzpPPy7O8lHbYP5Fye49hW
 L/erWtkygRIfpzNCXXPKodAU8+lipdWImbxc++I6qp01jx595X
 2VaSxqzFZ2xu2WPFzU+hQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 February 2011, Russell King - ARM Linux wrote:
> On Wed, Feb 02, 2011 at 05:00:20PM +0100, Arnd Bergmann wrote:
> > I would suggest fixing this by:
> >
> > 2. Changing the ARM MMIO functions to use inline assembly instead of
> > direct pointer dereference.
>
> We used to use inline assembly at one point, but that got chucked out.
> The problem is that using asm() for this causes GCC to generate horrid
> code.

Here is an alternative suggestion, would that work?

8<-----------
arm: avoid unaligned arguments to MMIO functions

The readw/writew/readl/writel functions require aligned naturally arguments
which are accessed only using atomic load and store instructions, never
using byte or read-modify-write write accesses.

At least one driver (ehci-hcd) annotates its MMIO registers as
__attribute__((packed)), which causes some versions of gcc to generate
byte accesses due to an undefined behavior when casting a packed u32
to an aligned u32 variable.

There does not seem to be an efficient way to force gcc to do word
accesses, but we can detect the problem and refuse to build broken
code: This adds a check in these functions to ensure that their arguments
are either naturally aligned or they are void pointers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 20e0f7c..b98f0bc 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -180,17 +180,36 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
  * IO port primitives for more information.
  */
 #ifdef __mem_pci
+
+/*
+ * Ensure natural alignment of arguments:
+ * It is not allowed to pass a pointer to a packed variable into
+ * the readl/writel family of functions, because gcc may decide
+ * to create byte accesses that are illegal on multi-byte MMIO
+ * registers.
+ * A lot of code uses void pointers, which is fine.
+ */
+#define __checkalign(p) BUILD_BUG_ON(				\
+	!__builtin_types_compatible_p(__typeof__(p), void *) &&	\
+	(__alignof__ (*(p)) < sizeof (*(p))))
+
 #define readb_relaxed(c) ({ u8  __v = __raw_readb(__mem_pci(c)); __v; })
-#define readw_relaxed(c) ({ u16 __v = le16_to_cpu((__force __le16) \
-					__raw_readw(__mem_pci(c))); __v; })
-#define readl_relaxed(c) ({ u32 __v = le32_to_cpu((__force __le32) \
-					__raw_readl(__mem_pci(c))); __v; })
+#define readw_relaxed(c) ({ u16 __v = le16_to_cpu((__force __le16)    \
+					__raw_readw(__mem_pci(c)));   \
+					__checkalign(c); __v; })
+#define readl_relaxed(c) ({ u32 __v = le32_to_cpu((__force __le32)    \
+					__raw_readl(__mem_pci(c)));   \
+					__checkalign(c); __v; })
 
 #define writeb_relaxed(v,c)	((void)__raw_writeb(v,__mem_pci(c)))
-#define writew_relaxed(v,c)	((void)__raw_writew((__force u16) \
-					cpu_to_le16(v),__mem_pci(c)))
-#define writel_relaxed(v,c)	((void)__raw_writel((__force u32) \
-					cpu_to_le32(v),__mem_pci(c)))
+#define writew_relaxed(v,c)	do { (void)__raw_writew((__force u16) \
+					cpu_to_le16(v),__mem_pci(c)); \
+					 __checkalign(c);	      \
+				} while (0);
+#define writel_relaxed(v,c)	do { (void)__raw_writel((__force u32) \
+					cpu_to_le32(v),__mem_pci(c)); \
+					__checkalign(c);	      \
+				} while (0);
 
 #ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
 #define __iormb()		rmb()
