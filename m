Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0CaIPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:15:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:52082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab0CaIPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:15:36 -0400
Date: Wed, 31 Mar 2010 10:15:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: [PATCH][RFC] x86: remove SMP check/taint for AMD K7 (was Re: KVM
 warning about uncertified CPU for SMP for AMD model 2, stepping 3)
In-Reply-To: <20100331024213.GV20695@one.firstfloor.org>
Message-ID: <alpine.LNX.2.00.1003311008270.24576@pobox.suse.cz>
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz> <20100331024213.GV20695@one.firstfloor.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Andi Kleen wrote:

> > booting 32bit guest on 32bit host on AMD system gives me the following 
> > warning when KVM is instructed to boot as SMP:
> 
> I guess these warnings could be just disabled. With nearly everyone
> using multi-core these days they are kind of obsolete anyways.

Why is it there for K7 only anyway? Was that the only product line which 
had instances which were explicitly marked as unsuitable for SMP by AMD?


From: Jiri Kosina <jkosina@suse.cz>
Subject: x86: remove SMP check/taint for AMD K7

Remove code checking of AMD K7 CPU models and warning/tainting kernel if 
it doesn't suit given criteria.

The code has been there originally in order to detect systems which were 
doing SMP with CPUs that were not oficially cerified by AMD as SMP-safe. 

It's not clear whether the checks are either proper or complete. Quoting 
Andi Kleen: "I guess these warnings could be just disabled. With nearly 
everyone using multi-core these days they are kind of obsolete anyways."

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 
 arch/x86/kernel/cpu/amd.c |   51 ---------------------------------------------
 1 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e485825..6510fe5 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -144,55 +144,6 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	/* calling is from identify_secondary_cpu() ? */
-	if (c->cpu_index == boot_cpu_id)
-		return;
-
-	/*
-	 * Certain Athlons might work (for various values of 'work') in SMP
-	 * but they are not certified as MP capable.
-	 */
-	/* Athlon 660/661 is valid. */
-	if ((c->x86_model == 6) && ((c->x86_mask == 0) ||
-	    (c->x86_mask == 1)))
-		goto valid_k7;
-
-	/* Duron 670 is valid */
-	if ((c->x86_model == 7) && (c->x86_mask == 0))
-		goto valid_k7;
-
-	/*
-	 * Athlon 662, Duron 671, and Athlon >model 7 have capability
-	 * bit. It's worth noting that the A5 stepping (662) of some
-	 * Athlon XP's have the MP bit set.
-	 * See http://www.heise.de/newsticker/data/jow-18.10.01-000 for
-	 * more.
-	 */
-	if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||
-	    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
-	     (c->x86_model > 7))
-		if (cpu_has_mp)
-			goto valid_k7;
-
-	/* If we get here, not a certified SMP capable AMD system. */
-
-	/*
-	 * Don't taint if we are running SMP kernel on a single non-MP
-	 * approved Athlon
-	 */
-	WARN_ONCE(1, "WARNING: This combination of AMD"
-		" processors is not suitable for SMP.\n");
-	if (!test_taint(TAINT_UNSAFE_SMP))
-		add_taint(TAINT_UNSAFE_SMP);
-
-valid_k7:
-	;
-#endif
-}
-
 static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
@@ -228,8 +179,6 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 	}
 
 	set_cpu_cap(c, X86_FEATURE_K7);
-
-	amd_k7_smp_check(c);
 }
 #endif
 
