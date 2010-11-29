Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0K2P1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:27:36 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:41455 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0K2P1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:27:35 -0500
Date: Mon, 29 Nov 2010 16:27:30 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] HPET: Fix HPET readout for small deltas
Message-ID: <20101129152730.GA2287@gentoo.trippelsdorf.de>
References: <20101129150941.GB1170@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129150941.GB1170@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.11.29 at 16:09 +0100, Borislav Petkov wrote:
> 
> Some HPET implementations might require longer delay when accessing the
> HPET than what 995bd3bb5c78f3ff71339803c0b8337ed36d64fb established (8
> cycles). Generally, the proper value should be programmed by BIOS and
> written into the ACPI HPET table as the main counter minimum tick in
> periodic mode (offset 53).
> 
> We assume that value as the minimum value a delta can be in order to
> reprogram the HPET successfully. For BIOSen which contain crap, we fall
> back to a default value of 128 cycles which should be sensible on all
> more or less sane HPET implementations.
> 
> LKML-Reference: <20101026112052.GA1672@arch.trippelsdorf.de>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
> 
> As noted before, this patch fixes the sluggishness issue on Markus' and
> my machine. And we definitely need some kind of fix for .37.

Yes. Just a minor note, the comment in hpet.c should also be updated:

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a0b790a..cfbbc94 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -403,9 +403,9 @@ static int hpet_next_event(unsigned long delta,
 	 * move us behind that point easily. Now instead of reading
 	 * the compare register back several times, we make the ETIME
 	 * decision based on the following: Return ETIME if the
-	 * counter value after the write is less than 8 HPET cycles
-	 * away from the event or if the counter is already ahead of
-	 * the event.
+	 * counter value after the write is less than hpet_min_tick
+	 * HPET cycles away from the event or if the counter is already
+	 * ahead of the event.
 	 */
 	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 

-- 
Markus
