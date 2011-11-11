Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab1KKNBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:01:34 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:54386 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab1KKNBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:01:33 -0500
Message-ID: <4EBD1CC5.3030008@oracle.com>
Date: Fri, 11 Nov 2011 18:31:57 +0530
From: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Resolving inconsistency with Intel processor manual
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EBD1C75.00BA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is from Notes of section 11.5.3 of Intel processor manual
available at http://www.intel.com/Assets/PDF/manual/325384.pdf:
For the Pentium 4 and Intel Xeon processors, after the sequence of
steps given above has been executed, the cache lines containing the
code between the end of the WBINVD instruction and before the
MTRRS have actually been disabled may be retained in the cache
hierarchy. Here, to remove code from the cache completely, a second
WBINVD instruction must be executed after the MTRRs have been
disabled.

This patch provides resolution for that.
Ideally, I will like to make changes only for Pentium 4 and Xeon processors.
But, I am not finding easier way to do it.
And, extra wbinvd() instruction does not hurt much for other processors.

Signed-off-by: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
---
  arch/x86/kernel/cpu/mtrr/generic.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c 
b/arch/x86/kernel/cpu/mtrr/generic.c
index a71efcdb..4cd9919 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -693,6 +693,7 @@ static void prepare_set(void) 
__acquires(set_atomicity_lock)

         /* Disable MTRRs, and set the default type to uncached */
         mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
+       wbinvd();
  }

  static void post_set(void) __releases(set_atomicity_lock)
-- 
1.7.5.1

