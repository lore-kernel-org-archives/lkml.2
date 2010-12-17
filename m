Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0LQDV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:21:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:64200 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab0LQDV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:21:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,358,1288594800"; 
   d="scan'208";a="688040131"
Subject: Re: [BUG]x86: relocatable doesn't work with new binutils
From: Shaohua Li <shaohua.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <4D0AD1F9.7030704@zytor.com>
References: <1292553726.2323.482.camel@sli10-conroe>
	 <4D0AD1F9.7030704@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 11:21:54 +0800
Message-ID: <1292556114.2323.484.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 10:59 +0800, H. Peter Anvin wrote:
> On 12/16/2010 06:42 PM, Shaohua Li wrote:
> > We can easily workaround this issue by moving jiffies to a section or at
> > least warn people if such binutils are using. what should we do?
> 
> I think we should do the workaround, but still get distros to update the
> broken binutils.
Here is my workaround.
The problem is a lot of kernel versions are affected by this, fix all?



The CONFIG_RELOCATABLE is broken with new binutils, which will make boot
panic. According to Lu Hongjiu, the affected binutils are from
2.20.51.0.12 to 2.21.51.0.3, which are release since Oct 22 this year.
At least ubuntu 10.10 is using such binutils. see:
http://sourceware.org/bugzilla/show_bug.cgi?id=12327
The reason of boot panic is we have 'jiffies = jiffies_64;' in
vmlinux.lds.S. The jiffies isn't in any section. In kernel build, there
is warning saying jiffies is an absolute address and can't be
relocatable. At runtime, jiffies will have virtual address 0.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>

---
 arch/x86/kernel/vmlinux.lds.S |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86/kernel/vmlinux.lds.S	2010-12-16 09:18:05.000000000 +0800
+++ linux/arch/x86/kernel/vmlinux.lds.S	2010-12-17 11:13:14.000000000 +0800
@@ -34,11 +34,9 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONF
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
@@ -138,6 +136,11 @@ SECTIONS
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
+#ifdef CONFIG_X86_32
+		jiffies = jiffies_64;
+#else
+		jiffies_64 = jiffies;
+#endif
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */


