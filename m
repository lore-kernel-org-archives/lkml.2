Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1ARA5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 19:57:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:40914 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab1ARA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 19:57:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,336,1291622400"; 
   d="scan'208";a="878297876"
Subject: Re: [PATCH]x86: make relocatable kernel work with new binutils
 -resend
From: Shaohua Li <shaohua.li@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <20110117101756.GB26819@elte.hu>
References: <1295232361.1949.675.camel@sli10-conroe>
	 <20110117101756.GB26819@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 08:57:49 +0800
Message-ID: <1295312269.1949.725.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 18:17 +0800, Ingo Molnar wrote:
> * Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > @@ -142,6 +140,11 @@ SECTIONS
> >  		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
> >  
> >  		DATA_DATA
> > +#ifdef CONFIG_X86_32
> > +		jiffies = jiffies_64;
> > +#else
> > +		jiffies_64 = jiffies;
> > +#endif
> 
> I suspect this needs a comment, as to the unsuspecting reader it looks like black 
> magic :-)
does this one look better?


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
 arch/x86/kernel/vmlinux.lds.S |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86/kernel/vmlinux.lds.S	2011-01-18 08:32:22.000000000 +0800
+++ linux/arch/x86/kernel/vmlinux.lds.S	2011-01-18 08:57:09.000000000 +0800
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
@@ -142,6 +140,15 @@ SECTIONS
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
+		/*
+		 * Workaround a binutils (2.20.51.0.12 to 2.21.51.0.3) bug.
+		 * This makes jiffies relocatable in such binutils
+		 */
+#ifdef CONFIG_X86_32
+		jiffies = jiffies_64;
+#else
+		jiffies_64 = jiffies;
+#endif
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */


