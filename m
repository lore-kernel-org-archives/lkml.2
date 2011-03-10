Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1CJI7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:59:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52089 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1CJI7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:59:09 -0500
Date: Thu, 10 Mar 2011 09:59:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: x86: kill binutils 2.16.x?
Message-ID: <20110310085900.GA25318@elte.hu>
References: <4D6E8932.1010405@zytor.com>
 <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
 <4D6EB07C.5040004@zytor.com>
 <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
 <4D6ECBDB.6090307@zytor.com>
 <20110303083035.GB14854@elte.hu>
 <4D7890CE.60800@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7890CE.60800@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Marek <mmarek@suse.cz> wrote:

> On 3.3.2011 09:30, Ingo Molnar wrote:
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> >> kbuild people: is there a way to test for a specific assembler version
> >> in Kbuild (and error out the build for it?)
> > 
> > Could we add a testcase for one of the more egregious breakages and bail out then? 
> > That way we don't have to get the version information right - broken prereleases 
> > would be covered as well.
> > 
> > For example this sequence:
> > 
> > .irp idx,0,1,2
> > .if 0 > \idx
> > .endif
> > .endr
> >
> > Will break on 2.16, right? It builds fine on 2.20.
> 
> This seems to work for me with the binutils version from sles10 (even
> with a vanilla build of binutils):
> $ as -v <<EOF; echo $?
> > .irp idx,0,1,2
> > .if 0 > \idx
> > .endif
> > .endr
> > EOF
> GNU assembler version 2.16.91.0.5 (i586-suse-linux) using BFD version
> 2.16.91.0.5 20051219
> 0
> $
> 
> So either the bug is fixed in that version already or you picked a wrong
> example (or I did not understand what should fail here). But don't get
> me wrong, I'm all for checking for actual bugs instead of innocent
> version strings.

I cited an incorrect testcase most likely. Note that Jan was able to work around the 
limitations in 2.16 after all - see the workaround commit that i have queued up in 
x86/mm, attached below.

Thanks,

	Ingo

--------------->
>From d04c579f971bf7d995db1ef7a7161c0143068859 Mon Sep 17 00:00:00 2001
From: Jan Beulich <JBeulich@novell.com>
Date: Thu, 3 Mar 2011 10:55:29 +0000
Subject: [PATCH] x86: Work around old gas bug

Add extra parentheses around a couple of definitions introduced
by "x86: Cleanup vector usage" and used in assembly macro
arguments, and remove spaces. Without that old (2.16.1) gas
would see more macro arguments than were actually specified.

Reported-and-tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <4D6F81B10200007800034B0B@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq_vectors.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 4980f48..6e976ee 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -126,14 +126,14 @@
 
 /* up to 32 vectors used for spreading out TLB flushes: */
 #if NR_CPUS <= 32
-# define NUM_INVALIDATE_TLB_VECTORS NR_CPUS
+# define NUM_INVALIDATE_TLB_VECTORS	(NR_CPUS)
 #else
-# define NUM_INVALIDATE_TLB_VECTORS 32
+# define NUM_INVALIDATE_TLB_VECTORS	(32)
 #endif
 
-#define INVALIDATE_TLB_VECTOR_END	0xee
+#define INVALIDATE_TLB_VECTOR_END	(0xee)
 #define INVALIDATE_TLB_VECTOR_START	\
-	(INVALIDATE_TLB_VECTOR_END - NUM_INVALIDATE_TLB_VECTORS + 1)
+	(INVALIDATE_TLB_VECTOR_END-NUM_INVALIDATE_TLB_VECTORS+1)
 
 #define NR_VECTORS			 256
 
