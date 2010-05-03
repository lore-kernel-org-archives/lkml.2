Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab0ECNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:09:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60859 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868Ab0ECNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:09:25 -0400
Date: Mon, 3 May 2010 15:07:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/5] perf inject + say no to __KERNEL__ only stuff
Message-ID: <20100503130736.GD26107@aftab>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
 <20100503062407.GB15241@elte.hu>
 <4BDE6D5A.6060407@zytor.com>
 <20100503065416.GD15241@elte.hu>
 <20100503073749.GA1694@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503073749.GA1694@elte.hu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, May 03, 2010 at 09:37:49AM +0200

> It broke half of the non-x86 architectures. For example on Sparc defconfig:
> 
> In file included from /home/mingo/tip/include/asm-generic/bitops/hweight.h:4,
>                  from /home/mingo/tip/arch/sparc/include/asm/bitops_32.h:103,
>                  from /home/mingo/tip/arch/sparc/include/asm/bitops.h:6,
>                  from /home/mingo/tip/include/linux/bitops.h:17,
>                  from /home/mingo/tip/include/linux/kernel.h:15,
>                  from /home/mingo/tip/include/linux/sched.h:54,
>                  from /home/mingo/tip/arch/sparc/kernel/asm-offsets.c:13:
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight32':
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:8: error: implicit declaration of function '__sw_hweight32'
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight16':
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:13: error: implicit declaration of function '__sw_hweight16'
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight8':
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:18: error: implicit declaration of function '__sw_hweight8'
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight64':
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:23: error: implicit declaration of function '__sw_hweight64'
> 
> (the failure on other architectures looks similar)

Right, so I could reproduce that with the crosstool on kernel.org when
compiling core/hweight. The patch below should fix those errors. x86 32-
and 64-bit are also fine with the patch.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 3 May 2010 14:57:11 +0200
Subject: [PATCH] arch, hweight: Fix compilation errors

Fix function prototypes visibility issues when cross-compiling. Tested
with crosstool (ftp://ftp.kernel.org/pub/tools/crosstool/) with alpha,
ia64 and sparc targets.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/asm-generic/bitops/arch_hweight.h |    8 ++++----
 include/linux/bitops.h                    |    5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
index 9a81c1e..6a211f4 100644
--- a/include/asm-generic/bitops/arch_hweight.h
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -3,22 +3,22 @@
 
 #include <asm/types.h>
 
-inline unsigned int __arch_hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	return __sw_hweight32(w);
 }
 
-inline unsigned int __arch_hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
 	return __sw_hweight16(w);
 }
 
-inline unsigned int __arch_hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
 	return __sw_hweight8(w);
 }
 
-inline unsigned long __arch_hweight64(__u64 w)
+static inline unsigned long __arch_hweight64(__u64 w)
 {
 	return __sw_hweight64(w);
 }
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index c55d5bc..26caa60 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -10,6 +10,11 @@
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif
 
+extern unsigned int __sw_hweight8(unsigned int w);
+extern unsigned int __sw_hweight16(unsigned int w);
+extern unsigned int __sw_hweight32(unsigned int w);
+extern unsigned long __sw_hweight64(__u64 w);
+
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
-- 
1.6.4.4


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
