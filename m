Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2EBKGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:06:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46624 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab2EBKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:06:20 -0400
Date: Wed, 2 May 2012 11:05:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yilu Mao <ylmao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4] ARM: cache-l2x0.c: save aux ctrl for resume in case
 l2x0 is enabled before init
Message-ID: <20120502100537.GB8492@arm.com>
References: <1335791786-32377-1-git-send-email-ylmao@marvell.com>
 <CAHkRjk51pATYdhKhmBb9sWywN+0BgeQLpW9bMfTkRgf_09wydg@mail.gmail.com>
 <4FA08B39.60300@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA08B39.60300@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 02:17:45AM +0100, Yilu Mao wrote:
> On 04/30/2012 09:34 PM, Catalin Marinas wrote:
> > On 30 April 2012 14:16, Yilu Mao<ylmao@marvell.com>  wrote:
> >> If l2x0 controller has been enabled when calling l2x0_init, the aux ctrl
> >> register will not be saved in l2x0_saved_regs. Therefore we can not use
> >> l2x0_saved_regs.aux_ctrl for resume later. This patch fixed the problem
> >> by saving aux ctrl in l2x0_saved_regs just after it's being read from
> >> the register.
> >> And in case some bits of aux ctrl register are reserved, re-read and
> >> save it properly after set it if l2x0 is disabled before init.
> >>
> >> Change-Id: I54f3002274ffe9cdc667dba81e36e08f2e121467
> >> Signed-off-by: Yilu Mao<ylmao@marvell.com>
> >> ---
> >>   arch/arm/mm/cache-l2x0.c |    9 +++++++++
> >>   1 files changed, 9 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> >> index a53fd2a..9893e58 100644
> >> --- a/arch/arm/mm/cache-l2x0.c
> >> +++ b/arch/arm/mm/cache-l2x0.c
> >> @@ -320,6 +320,13 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
> >>         cache_id = readl_relaxed(l2x0_base + L2X0_CACHE_ID);
> >>         aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
> >>
> >> +       /*
> >> +        * In case l2x controller is enabled, the aux ctrl register
> >> +        * can't be set. So the original value should be stored in
> >> +        * the l2x0_saved_regs for restoring when resume.
> >> +        */
> >> +       l2x0_saved_regs.aux_ctrl = aux;
> >
> > Why not move this
> >
> >> +
> >>         aux&= aux_mask;
> >>         aux |= aux_val;
> >>
> >> @@ -364,6 +371,8 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
> >>                 /* l2x0 controller is disabled */
> >>                 writel_relaxed(aux, l2x0_base + L2X0_AUX_CTRL);
> >>
> >> +               /* Re-read it in case some bits are reserved. */
> >> +               aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
> >
> > and this
> >
> >>                 l2x0_saved_regs.aux_ctrl = aux;
> >>
> >>                 l2x0_inv_all();
> >
> > somewhere after the if block and we only read the aux once. The
> > comment may no longer make sense though.
> 
> I want to make it clear before I provide a new patch. :)
> We can't only read once because we must read it before handle the 
> aux_val and aux_mask arguments.

I was thinking about something like this:


diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 361a628..fbd8903 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -371,14 +371,15 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 		/* l2x0 controller is disabled */
 		writel_relaxed(aux, l2x0_base + L2X0_AUX_CTRL);
 
-		l2x0_saved_regs.aux_ctrl = aux;
-
 		l2x0_inv_all();
 
 		/* enable L2X0 */
 		writel_relaxed(1, l2x0_base + L2X0_CTRL);
 	}
 
+	aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
+	l2x0_saved_regs.aux_ctrl = aux;
+
 	outer_cache.inv_range = l2x0_inv_range;
 	outer_cache.clean_range = l2x0_clean_range;
 	outer_cache.flush_range = l2x0_flush_range;


-- 
Catalin
