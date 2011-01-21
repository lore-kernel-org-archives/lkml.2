Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1AUHTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:19:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:8997 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1AUHTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:19:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,356,1291622400"; 
   d="scan'208";a="879580329"
Subject: RE: Linux 2.6.38-rc1 doesn't boot
From: Shaohua Li <shaohua.li@intel.com>
To: "Anvin, H Peter" <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <ADDEBCD9C145E542A8688C29F1FBDCB9C915F59E@orsmsx502.amr.corp.intel.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	 <20110119073905.GA1652@gentoo.trippels.de>
	 <20110119074902.GA1670@gentoo.trippels.de>
	 <1295424766.1949.879.camel@sli10-conroe> <4D36A759.60704@intel.com>
	 <20110119090904.GA4927@elte.hu> <1295489286.1949.882.camel@sli10-conroe>
	 <20110120112541.GA23661@elte.hu>
	 <ADDEBCD9C145E542A8688C29F1FBDCB9C915F59E@orsmsx502.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 15:18:59 +0800
Message-ID: <1295594339.1949.936.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 23:08 +0800, Anvin, H Peter wrote:
> (The patch will need to be paired with removing the hacks in the linker script.)
> 
> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu] 
> Sent: Thursday, January 20, 2011 3:26 AM
> To: Li, Shaohua
> Cc: Anvin, H Peter; Markus Trippelsdorf; Lu, Hongjiu; Linus Torvalds; Linux Kernel Mailing List; Sam Ravnborg
> Subject: Re: Linux 2.6.38-rc1 doesn't boot
> 
> 
> * Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > it's not a build failure, without it, my i386 kernel can't boot
> > actually.
> 
> Please try hpa's patch in this thread on top of very latest (today's) -git or latest 
> -tip:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> Does that result in a booting system? That way we can avoid most of the linker 
> script madness.
Need some changes to make it compile and work on both 32 and 64 bit
kernel. below one is working for me:

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..d8f1c6d 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -34,11 +34,9 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 #ifdef CONFIG_X86_32
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
-jiffies = jiffies_64;
 #else
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
 #endif
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
@@ -203,6 +201,7 @@ SECTIONS
 		*(.jiffies)
 	}
 	jiffies = VVIRT(.jiffies);
+	jiffies_64 = jiffies;
 
 	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
 		*(.vsyscall_3)
diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..36cb5e3 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -41,6 +41,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
+#include <asm/byteorder.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/div64.h>
@@ -53,6 +54,11 @@
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
+#if defined(__LITTLE_ENDIAN) || (BITS_PER_LONG >= 64)
+asm(".global jiffies; jiffies = jiffies_64");
+#else
+asm(".global jiffies; jiffies = jiffies_64 + 4");
+#endif
 
 /*
  * per-CPU timer vector definitions:


