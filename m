Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1FPDuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:50:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1FPDuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:50:07 -0400
Message-ID: <4DF97D6C.2080900@redhat.com>
Date: Wed, 15 Jun 2011 20:50:04 -0700
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>
Subject: [PATCH x86 kvm] Fix register corruption in pvclock_scale_delta
Content-Type: multipart/mixed;
 boundary="------------000906090008070504070801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000906090008070504070801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The 128-bit multiply in pvclock.h was missing an output constraint for 
EDX which caused a register corruption to appear.  Thanks to Ulrich for 
diagnosing the EDX corruption and Avi for providing this fix (which now 
I am sending back to you Avi..)

Zach

--------------000906090008070504070801
Content-Type: text/plain;
 name="x86-kvm-pvclock-scale-delta-constraint-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86-kvm-pvclock-scale-delta-constraint-fix.patch"

>From Avi and Ulrich, fix constraints for 128-bit multiply

Signed-off-by: Zachary Amsden <zamsden@redhat.com>

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index 31d84ac..a518c0a 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -22,6 +22,8 @@ static inline u64 pvclock_scale_delta(u64 delta, u32 mul_frac, int shift)
 	u64 product;
 #ifdef __i386__
 	u32 tmp1, tmp2;
+#else
+	ulong tmp;
 #endif
 
 	if (shift < 0)
@@ -42,8 +44,11 @@ static inline u64 pvclock_scale_delta(u64 delta, u32 mul_frac, int shift)
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

--------------000906090008070504070801--
