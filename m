Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1H3JIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:08:24 -0400
Received: from smtp1.u-psud.fr ([129.175.33.41]:63132 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab1H3JHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:07:50 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Aug 2011 05:07:50 EDT
Message-ID: <4E5CA62E.8060304@free.fr>
Date: Tue, 30 Aug 2011 10:58:22 +0200
From: Duncan Sands <baldrick@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110826 Thunderbird/7.0
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH x86 kvm] Fix register corruption in pvclock_scale_delta
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zachary, this patch can cause a compile failure if the compiler chooses to
use a memory location for mul_frac rather than a register (as allowed by the
"m" in the constraints):

   pvclock.s:229: Error: no instruction mnemonic suffix given and no register 
operands; can't size instruction

In this example the assembler is:

         #APP
         mul -48(%rbp) ; shrd $32, %rdx, %rax
         #NO_APP

A simple solution is to use mulq, as in the following patch:

Signed-off-by: Duncan Sands <baldrick@free.fr>

--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -44,7 +44,7 @@ static inline u64 pvclock_scale_delta(u64 delta, u32 mul_frac, 
int shift)
                 : "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
  #elif defined(__x86_64__)
         __asm__ (
-               "mul %[mul_frac] ; shrd $32, %[hi], %[lo]"
+               "mulq %[mul_frac] ; shrd $32, %[hi], %[lo]"
                 : [lo]"=a"(product),
                   [hi]"=d"(tmp)
                 : "0"(delta),
