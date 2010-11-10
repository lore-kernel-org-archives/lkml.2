Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0KJM71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:59:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:50129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab0KJM71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:59:27 -0500
Subject: Re: 2.6.37-rc1 build failure
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: randrianasulu@gmail.com, Lin Ming <lin@ming.vg>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101103213439.01d2062d.randy.dunlap@oracle.com>
References: <201011030532.09986.randrianasulu@gmail.com>
	 <AANLkTi=NYWGQB_O78dn=opzPYFngeBnJ2qrF7k5Le_ma@mail.gmail.com>
	 <201011040334.16833.randrianasulu@gmail.com>
	 <20101103213439.01d2062d.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 13:59:34 +0100
Message-ID: <1289393974.2191.115.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 21:34 -0700, Randy Dunlap wrote:
> The build fails for me with the given .config file.
> It's due to selects and depends, finally comes down to HAVE_PERF_EVENTS not being
> enabled for M386 or M486.  Do you actually have a processor of that vintage?

FWIW this .config generates a _TON_ of Kconfig dep warnings..

Urgh, Kconfig hell.

config PERF_EVENTS
        bool "Kernel performance events and counters"
        default y if (PROFILING || PERF_COUNTERS)
        depends on HAVE_PERF_EVENTS
        select ANON_INODES
        select IRQ_WORK


# grep PERF_EVENTS borken-build/.config
CONFIG_PERF_EVENTS=y
CONFIG_HAVE_PERF_EVENTS_NMI=y



So we managed to get PERF_EVENTS=y even though its dependency
HAVE_PERF_EVENTS=n.


I bet that's because of:

config X86
        select HAVE_PERF_EVENTS if (!M386 && !M486)
        select PERF_EVENTS 


Ingo, should we simply do something like the below patch?

---
Subject: x86: Remove M[34]86 conditional on HAVE_PERF_EVENTS

x86 requires PERF_EVENTS because of the hardware breakpoint mess,
so don't make it conditional on M[34]86.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..e330da2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -21,7 +21,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_PERF_EVENTS if (!M386 && !M486)
+	select HAVE_PERF_EVENTS
 	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES

