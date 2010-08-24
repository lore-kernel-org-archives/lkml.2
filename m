Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0HXJAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:00:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:57361 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab0HXJAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:00:51 -0400
Message-Id: <89kc63$hrqoho@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,262,1280732400"; 
   d="scan'208";a="599614008"
Date: Tue, 24 Aug 2010 10:00:47 +0100
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [REGRESSION, i915]: Periodic stalls with 2.6.36-rc2
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
References: <20100823233551.GA31920@sucs.org> <89kc63$hrmse5@fmsmga002.fm.intel.com> <20100824075741.GA11000@sucs.org> <8u3s8d$jcg467@orsmga001.jf.intel.com> <20100824084902.GA27569@sucs.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100824084902.GA27569@sucs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 09:49:02 +0100, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Tue, Aug 24, 2010 at 09:16:50AM +0100, Chris Wilson wrote:
> > 
> > Ok, I'm a little happier that the hangcheck could be just another symptom
> > of the problem...
> > 
> > I think it is safe to assume that the bug is in i915, so restricting the
> > bisect to just drm seems plausible:
> > 
> > git bisect start drivers/gpu/drm
> > git bisect good 2.6.36-rc1
> > git bisect bad 2.6.36-rc2
> 
> I should mention that I ran a similar bisect yesterday but it led to a dead
> end:
[snip]
> All the bad kernels above boot EXTREMELY slowly and it's not clear why. Using
> the results above to run your tests produced the following:

I was hoping that git would be more intelligent than that. Is there a way
to simply bisect down one side of a merge?

The slow boot is probably fixed by 4936a3b90d79dd8775c6ac23c2cf2dcebe29abde.
A trivial patch you can apply on each step is:

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 33dbcc4..88f3b6c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -837,7 +837,7 @@ static int hpet_clocksource_register(void)
         * cyc/sec = FSEC_PER_SEC/hpet_period(fsec/cyc)
         * cyc/sec = (FSEC_PER_NSEC * NSEC_PER_SEC)/hpet_period
         */
-       hpet_freq = FSEC_PER_NSEC * NSEC_PER_SEC;
+       hpet_freq = (u64) FSEC_PER_NSEC * NSEC_PER_SEC;
        do_div(hpet_freq, hpet_period);
        clocksource_register_hz(&clocksource_hpet, (u32)hpet_freq);

-- 
Chris Wilson, Intel Open Source Technology Centre
