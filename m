Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2KVUmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:42:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964987Ab2KVS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:50 -0500
Message-ID: <50AD4907.5040102@zytor.com>
Date: Wed, 21 Nov 2012 13:35:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Blower, Melanie" <melanie.blower@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: compilation issue, inline assembly arch/x86/kvm/emulate.c
 fails at -O0
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
In-Reply-To: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/mixed;
 boundary="------------080901020100030501060401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080901020100030501060401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/14/2012 11:45 AM, Blower, Melanie wrote:
> [1.] gcc -O0 assembly arch/x86/kvm/emulate.c gets compilation failure -- incorrect register restrictions
> [2.] Full description of the problem/report:
> I'm trying to compile this file at -O0, but gcc chokes in register allocation at the inline assembly.
> 
> In the ordinary Linux build, this file compiles with gcc at -O2, without compilation errors.
> 
> At -O0, gcc chokes with this message: 
> gcc  -w -c ./emulateE.c               // (using preprocessed file)
> ./emulateE.c: In function `em_mul_ex':
> ./emulateE.c:1918:5: error: can't find a register in class `AREG' while reloading `asm'
> ./emulateE.c:1918:5: error: `asm' operand has impossible constraints
> 
> Explanation:
> The file contains an inline asm of a kind:
> 
>     __asm__ __volatile__ ( " ..... " :
> 
>  "=m" ((ctxt)->eflags), "=&r" (_tmp), "+a" (*rax), "+d" (*rdx), "+qm"(ex) :
>  "i" (11), "m" ((ctxt)->src . val), "a" (*rax), "d" (*rdx)); 
> 
> Note that "+a" in inputs already means that eax is the return value. An then "a" is used as an output constraint too.
> 

Hi Melanie,

Can you test the attached patch?

	-hpa



--------------080901020100030501060401
Content-Type: text/x-patch;
 name="0001-x86-kvm-Remove-incorrect-redundant-assembly-constrai.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-kvm-Remove-incorrect-redundant-assembly-constrai.pa";
 filename*1="tch"

>From f8d8e2842ca05fd89788e35c087f02c6159b023a Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 21 Nov 2012 13:29:20 -0800
Subject: [PATCH] x86, kvm: Remove incorrect redundant assembly constraint

In __emulate_1op_rax_rdx, we use "+a" and "+d" which are input/output
constraints, and *then* use "a" and "d" as input constraints.  This is
incorrect, but happens to work on some versions of gcc.

However, it breaks gcc with -O0 and icc, and may break on future
versions of gcc.

Reported-by: Melanie Blower <melanie.blower@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39171cb..bba39bf 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -426,8 +426,7 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
 			_ASM_EXTABLE(1b, 3b)				\
 			: "=m" ((ctxt)->eflags), "=&r" (_tmp),		\
 			  "+a" (*rax), "+d" (*rdx), "+qm"(_ex)		\
-			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val),	\
-			  "a" (*rax), "d" (*rdx));			\
+			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val));	\
 	} while (0)
 
 /* instruction has only one source operand, destination is implicit (e.g. mul, div, imul, idiv) */
-- 
1.7.11.7


--------------080901020100030501060401--
