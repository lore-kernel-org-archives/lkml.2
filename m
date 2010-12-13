Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0LMPhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:37:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab0LMPht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:37:49 -0500
Date: Mon, 13 Dec 2010 10:37:19 -0500
From: Don Zickus <dzickus@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: linux-next: Tree for December 10 (x86 nmi_watchdog)
Message-ID: <20101213153719.GD18577@redhat.com>
References: <20101210135746.0cf6cbcd.sfr@canb.auug.org.au>
 <20101210092533.4f426650.randy.dunlap@oracle.com>
 <AANLkTi=bw8EcxEffbVV6CfdAPVdM25ZMxHqAmz1yukq3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=bw8EcxEffbVV6CfdAPVdM25ZMxHqAmz1yukq3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:27:02AM +0600, Rakib Mullick wrote:
> On Fri, Dec 10, 2010 at 11:25 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Fri, 10 Dec 2010 13:57:46 +1100 Stephen Rothwell wrote:
> >
> >> Hi all,
> >>
> >> Changes since 20101209:
> >
> >
> > arch/x86/kernel/apic/hw_nmi.c:28: error: redefinition of 'touch_nmi_watchdog'
> > include/linux/nmi.h:22: note: previous definition of 'touch_nmi_watchdog' was here
> >
> Hello Randy,
> 
> Please checkout the following patch. Does it work?

This fixes the problem.  Sorry about that.  I need to remember to try more
random config options to catch these things.
----8<---

From: Don Zickus <dzickus@redhat.com>
Date: Mon, 13 Dec 2010 10:31:58 -0500
Subject: [PATCH] x86, watchdog: Compile fix when CONFIG_LOCAL_APIC not enabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When adjusting the code to handle removing the old nmi watchdog,
I forgot to consider the compile case when the local apic is not
enabled.  This small change fixes the compile warning:

arch/x86/kernel/apic/hw_nmi.c:28:6: error: redefinition of ‘touch_nmi_watchdog’

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index c558e11..93da91d 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -17,6 +17,7 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 
+#ifdef ARCH_HAS_NMI_WATCHDOG
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
 {
@@ -31,6 +32,8 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 #endif
+#endif
+
 #ifdef arch_trigger_all_cpu_backtrace
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
-- 
1.7.3.2

