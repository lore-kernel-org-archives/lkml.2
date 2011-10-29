Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1J2Tct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 15:32:49 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:56097 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1J2Tcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 15:32:48 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] s3c2410: remove __ioaddrc()
Date: Sat, 29 Oct 2011 17:32:29 -0200
Message-Id: <1319916749-14899-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at s3c2410's mach/io.h, I noticed the #define for
__ioaddr() looked wrong. While the #defines above it called the "c"
suffixed variant when __builtin_constant_p() was true, the one for
__ioaddr() called the "c" suffixed variant (__ioaddrc()) when
__builtin_constant_p() was *false*.

Looking further, I noticed that __ioaddr() and __ioaddrc() were
identical, the only difference being that __ioaddr() is an inline
function and __ioaddrc() is a macro.

__ioaddrc() is not used anywhere else. There were similar constructs,
also reversed from what I'd expect, in both mach-clps7500 (removed from
the kernel in 2.6.29) and mach-rpc. The copy in mach-rpc was removed in
commit 6de2c31d3dad7384b3efa03674bd6ed479d58cb2 (rpc: remove obsolete IO
accessors).

Since __ioaddrc() is both redundant and useless, has no other uses, and
has already been removed in mach-rpc, remove it also in mach-s3c2410.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 arch/arm/mach-s3c2410/include/mach/io.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-s3c2410/include/mach/io.h b/arch/arm/mach-s3c2410/include/mach/io.h
index 118749f..5843974 100644
--- a/arch/arm/mach-s3c2410/include/mach/io.h
+++ b/arch/arm/mach-s3c2410/include/mach/io.h
@@ -190,15 +190,12 @@ DECLARE_IO(int,l,"")
 	result;								\
 })
 
-#define __ioaddrc(port)	((__PORT_PCIO(port) ? PCIO_BASE + (port) : (void __iomem *)(port)))
-
 #define inb(p)		(__builtin_constant_p((p)) ? __inbc(p)	   : __inb(p))
 #define inw(p)		(__builtin_constant_p((p)) ? __inwc(p)	   : __inw(p))
 #define inl(p)		(__builtin_constant_p((p)) ? __inlc(p)	   : __inl(p))
 #define outb(v,p)	(__builtin_constant_p((p)) ? __outbc(v,p) : __outb(v,p))
 #define outw(v,p)	(__builtin_constant_p((p)) ? __outwc(v,p) : __outw(v,p))
 #define outl(v,p)	(__builtin_constant_p((p)) ? __outlc(v,p) : __outl(v,p))
-#define __ioaddr(p)	(__builtin_constant_p((p)) ? __ioaddr(p)  : __ioaddrc(p))
 
 #define insb(p,d,l)	__raw_readsb(__ioaddr(p),d,l)
 #define insw(p,d,l)	__raw_readsw(__ioaddr(p),d,l)
-- 
1.7.6.4

