Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1ARSLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:11:15 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1065 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751564Ab1ARSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:11:14 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 21938
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] asm-generic/io.h: Fix io{read,write}{16,32}be for big endian systems
Date: Tue, 18 Jan 2011 19:11:01 +0100
Message-Id: <1295374261-19609-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently io{read,write}{16,32} expand to
	*addr = cpu_to_leXX(cpu_to_beXX(val))
and
	val = beXX_to_cpu(leXX_to_cpu(*addr))

While it should rather be:
	*addr = cpu_to_be{16,32}(val)
and
	val = be{16,32}_to_cpu(*addr)

The current implementation works on litte-endian targets(where cpu_to_leXX is a
noop), but breaks on on big-endian targets, this patch fixes it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/asm-generic/io.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 4644c9a..5d93735 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -244,15 +244,15 @@ static inline void writesb(const void __iomem *addr, const void *buf, int len)
 #ifndef CONFIG_GENERIC_IOMAP
 #define ioread8(addr)		readb(addr)
 #define ioread16(addr)		readw(addr)
-#define ioread16be(addr)	be16_to_cpu(ioread16(addr))
+#define ioread16be(addr)	be16_to_cpu(__raw_readw(addr))
 #define ioread32(addr)		readl(addr)
-#define ioread32be(addr)	be32_to_cpu(ioread32(addr))
+#define ioread32be(addr)	be32_to_cpu(__raw_readl(addr))
 
 #define iowrite8(v, addr)	writeb((v), (addr))
 #define iowrite16(v, addr)	writew((v), (addr))
-#define iowrite16be(v, addr)	iowrite16(be16_to_cpu(v), (addr))
+#define iowrite16be(v, addr)	__raw_writew(be16_to_cpu(v), (addr))
 #define iowrite32(v, addr)	writel((v), (addr))
-#define iowrite32be(v, addr)	iowrite32(be32_to_cpu(v), (addr))
+#define iowrite32be(v, addr)	__raw_writel(be32_to_cpu(v), (addr))
 
 #define ioread8_rep(p, dst, count) \
 	insb((unsigned long) (p), (dst), (count))
-- 
1.7.2.3

