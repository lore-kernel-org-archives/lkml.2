Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0CUUsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:48:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0CUUsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:48:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression, post-2.6.34-rc1][PATCH] x86 / perf: Fix suspend to RAM on HP nx6325
Date: Sun, 21 Mar 2010 21:51:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <201003201507.15358.rjw@sisk.pl> <201003202148.01312.rjw@sisk.pl> <alpine.LFD.2.00.1003211029480.18017@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003211029480.18017@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003212151.51383.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 March 2010, Linus Torvalds wrote:
> 
> On Sat, 20 Mar 2010, Rafael J. Wysocki wrote:
> >
> > The appended patch fixes the breakage for me too.
> 
> Please don't use a 'goto' for something like this.
> 
> >  	raw_spin_lock(&amd_nb_lock);
> >  
> > +	if (!cpuhw->amd_nb)
> > +		goto unlock;
> > +
> >  	if (--cpuhw->amd_nb->refcnt == 0)
> >  		kfree(cpuhw->amd_nb);
> >  
> >  	cpuhw->amd_nb = NULL;
> >  
> > + unlock:
> >  	raw_spin_unlock(&amd_nb_lock);
> >  }
> 
> Just do
> 
> 	raw_spin_lock(&amd_nb_lock);
> 	if (cpuhw->amd_nb) {
> 		if (!--cpuhw->amd_nb->refcnt)
> 			kfree(cpuhw->amd_nb);
> 		cpuhw->amd_nb = NULL;
> 	}
> 	raw_spin_unlock(&amd_nb_lock);
> 
> instead. Much more readable.
> 
> Let's keep 'goto' for cases where we have error returns that we don't want 
> to nest, not trivial stuff like this.

OK

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: x86 / perf: Fix suspend to RAM on HP nx6325

Commit 3f6da3905398826d85731247e7fbcf53400c18bd
(perf: Rework and fix the arch CPU-hotplug hooks) broke suspend to
RAM on my HP nx6325 (and most likely on other AMD-based boxes too)
by allowing amd_pmu_cpu_offline() to be executed for CPUs that are
going offline as part of the suspend process.  The problem is that
cpuhw->amd_nb may be NULL already, so the function should make sure
it's not NULL before accessing the object pointed to by it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/cpu/perf_event_amd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
@@ -348,10 +348,12 @@ static void amd_pmu_cpu_offline(int cpu)
 
 	raw_spin_lock(&amd_nb_lock);
 
-	if (--cpuhw->amd_nb->refcnt == 0)
-		kfree(cpuhw->amd_nb);
+	if (cpuhw->amd_nb) {
+		if (--cpuhw->amd_nb->refcnt == 0)
+			kfree(cpuhw->amd_nb);
 
-	cpuhw->amd_nb = NULL;
+		cpuhw->amd_nb = NULL;
+	}
 
 	raw_spin_unlock(&amd_nb_lock);
 }
