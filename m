Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1GHFGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:06:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab1GHFGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:06:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:03 2011
Message-Id: <20110708001703.008895869@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Zachary Amsden <zamsden@redhat.com>
Subject: [106/107] KVM: Fix register corruption in pvclock_scale_delta
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zachary Amsden <zamsden@redhat.com>

(cherry picked from commit de2d1a524e94a79078d9fe22c57c0c6009237547)

The 128-bit multiply in pvclock.h was missing an output constraint for
EDX which caused a register corruption to appear.  Thanks to Ulrich for
diagnosing the EDX corruption and Avi for providing this fix.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/pvclock.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -22,6 +22,8 @@ static inline u64 pvclock_scale_delta(u6
 	u64 product;
 #ifdef __i386__
 	u32 tmp1, tmp2;
+#else
+	ulong tmp;
 #endif
 
 	if (shift < 0)
@@ -42,8 +44,11 @@ static inline u64 pvclock_scale_delta(u6
 		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
 #elif defined(__x86_64__)
 	__asm__ (
-		"mul %%rdx ; shrd $32,%%rdx,%%rax"
-		: "=a" (product) : "0" (delta), "d" ((u64)mul_frac) );
+		"mul %[mul_frac] ; shrd $32, %[hi], %[lo]"
+		: [lo]"=a"(product),
+		  [hi]"=d"(tmp)
+		: "0"(delta),
+		  [mul_frac]"rm"((u64)mul_frac));
 #else
 #error implement me!
 #endif


