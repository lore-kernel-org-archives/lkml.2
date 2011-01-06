Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1AFRuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:50:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:1193 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab1AFRuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:50:12 -0500
Message-Id: <1bdc18$j6a1ns@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,284,1291622400"; 
   d="scan'208";a="644155132"
Date: Thu, 06 Jan 2011 17:49:48 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: Linux 2.6.37
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com> <20110106104816.GA4026@tiehlicka.suse.cz> <AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 08:29:22 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Thu, Jan 6, 2011 at 2:48 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > It seems that there is still a regression for intel graphic cards
> > backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
> > I can reproduce the problem easily by:
> > xset dpms force standby; sleep 3s; xset dpms force on
> >
> > backlight doesn't get up (there is really dark picture though which
> > doesn't get brighter by function keys which work normally) after dpms on
> > until I close and open lid.
> 
> Hmm. That commit no longer reverts cleanly, so it's not trivial to
> test whether all those things are exactly the same issue. It's been
> bisected in the bugzilla entry, but it would be good to verify that
> yes, reverting it really does fix the issue, and your issue is the
> exact same one.
> 
> Chris, any ideas?

My fear is that some machines have a dependency between the backlight
and panel power status. The patch in question changed the timing between
turning on the panel and adjusting the backlight which would be restore
with:

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index aa23070..0b40b4f 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -106,6 +106,12 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
 	I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
 	POSTING_READ(lvds_reg);
 
+	{
+		u32 reg = HAS_PCH_SPLIT(dev) ? PCH_PP_STATUS : PPS_STATUS;
+		if (wait_for(I915_READ(reg) & PP_ON, 1000))
+			DRM_ERROR("timed out waiting for panel to power up\n");
+	}
+
 	intel_panel_set_backlight(dev, dev_priv->backlight_level);
 }

-- 
Chris Wilson, Intel Open Source Technology Centre
