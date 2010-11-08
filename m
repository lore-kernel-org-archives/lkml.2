Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab0KHMNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:13:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:21099 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0KHMNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:13:21 -0500
Message-Id: <5b55a1$ijk39t@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,314,1286175600"; 
   d="scan'208";a="624561469"
Date: Mon, 08 Nov 2010 12:13:17 +0000
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [Intel-gfx] [bisected] offset display bug in i915
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1289215749.3916.401.camel@constitution.bos.jonmasters.org>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org> <b9dded$h0q3am@orsmga002.jf.intel.com> <1289213695.3916.396.camel@constitution.bos.jonmasters.org> <1289215364.3916.400.camel@constitution.bos.jonmasters.org> <1289215749.3916.401.camel@constitution.bos.jonmasters.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Nov 2010 06:29:09 -0500, Jon Masters <jonathan@jonmasters.org> wrote:
> On Mon, 2010-11-08 at 06:22 -0500, Jon Masters wrote:
> > As I mentioned on IRC, I'm familiar with how I2C works electrically, and
> > therefore EDID implementation as a concept, but I am not really a
> > graphics hacker so I wasn't aware that you prefer edid-decode :)
> > 
> > Here is a decoded version of the output:
> 
> And here is an old file I had with the output when running a broken
> kernel with the cacheing enabled:

They look to be identical. So it is not necessarily the caching that is
the issue, but that we now no longer do an essential step whilst bringing
up the lvds. Can you just check that the reported EDIDs are the same for
when it is behaving correctly and when the display is offset?

The secondary change in the commit was to use drm_get_edid() directly
during device detection which delayed setting the EDID property on the
connection until get_modes(). Does this make a difference?

diff --git a/drivers/gpu/drm/i915/intel_lvds.c
b/drivers/gpu/drm/i915/intel_lvds
index f1a6499..17bcb7d 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -940,7 +940,10 @@ void intel_lvds_init(struct drm_device *dev)
        intel_lvds->edid = drm_get_edid(connector,
                                        &dev_priv->gmbus[pin].adapter);
 
-       if (!intel_lvds->edid) {
+       if (intel_lvds->edid) {
+               drm_mode_connector_update_edid_property(connector,
+                                                       intel_lvds->edid);
+       } else {

-- 
Chris Wilson, Intel Open Source Technology Centre
