Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1EWKKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:10:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58029 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1EWKKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:10:49 -0400
Date: Mon, 23 May 2011 12:10:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: Resume Issues :Exec of NX page, Synaptics Botchup
Message-ID: <20110523101036.GC28562@elte.hu>
References: <alpine.DEB.2.02.1105221720040.2065@natty-nar>
 <BANLkTik9ZmQz1A0PBC4P-9XF-hB6Ywr3uQ@mail.gmail.com>
 <alpine.DEB.2.02.1105221817100.1868@natty-nar>
 <BANLkTimt0ozTCSarTVwkOpvgLoW-pizMvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimt0ozTCSarTVwkOpvgLoW-pizMvA@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, May 22, 2011 at 3:22 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> >
> > Now I get a different call trace for the same NX error. (And Synaptics is
> > completely dead this time - not attributable to the patch, it was dumb
> > luck perhaps that it wored last time.)
> 
> Just because I'm crazy, can you double-check that you applied my patch
> and booted the right kernel?
> 
> Because that NX error *really* looks like the call to setup_smep(),
> and the eip still very much looks like something jumped to the
> "__init" region, not the "__cpuinit" region.
> 
> That backtrace really still looks like the same thing.
> 
> Oh, and you should do
> 
> -static int disable_smep __initdata;
> +static int disable_smep __cpuinitdata;
> 
> too, I guess. Not that it should matter for this particular oops.

We have a fix for this queued up in x86/urgent:

 1d487624fcc1: x86, SMEP: Fix section mismatch warnings

which got delayed by weekend latency ... will send these fixes in a couple of 
minutes.

Thanks,

	Ingo

-------------->
>From 1d487624fcc17a40aa67acaa9e8f3815fb7cd0f0 Mon Sep 17 00:00:00 2001
From: Fenghua Yu <fenghua.yu@intel.com>
Date: Fri, 20 May 2011 15:33:17 -0700
Subject: [PATCH] x86, SMEP: Fix section mismatch warnings

Fix these kernel compilation warnings:

 WARNING: arch/x86/built-in.o(.cpuinit.text+0x1e07): Section mismatch ...
 WARNING: arch/x86/built-in.o(.cpuinit.text+0x1b10): Section mismatch ...

introduced by:

  de5397ad5b9a: x86, cpu: Enable/disable Supervisor Mode Execution Protection

Change disable_smep from __initdata to __cpuinitdata.
Change setup_smep() from __init to __cpuinit.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: Asit K Mallick <asit.k.mallick@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1305930797-11409-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cbc70a2..c8b4162 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -254,7 +254,7 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
-static int disable_smep __initdata;
+static int disable_smep __cpuinitdata;
 static __init int setup_disable_smep(char *arg)
 {
 	disable_smep = 1;
@@ -262,7 +262,7 @@ static __init int setup_disable_smep(char *arg)
 }
 __setup("nosmep", setup_disable_smep);
 
-static __init void setup_smep(struct cpuinfo_x86 *c)
+static __cpuinit void setup_smep(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SMEP)) {
 		if (unlikely(disable_smep)) {
