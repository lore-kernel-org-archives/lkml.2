Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0L2UQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 15:16:11 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:45415 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751018Ab0L2UQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 15:16:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=grIFZQ3MnS1q/0ROQW+bzmt1nOWlR5mH95lc5vdSd5VyKDd/VrtqRFPJdoSdyVNgCZmK8oDq7SBdr/6wUaFOB+PF2wysxdc5MWA3DbXfUsA5Qmin0WBCQnJ/0P8BMmut;
Date: Wed, 29 Dec 2010 12:16:01 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>,
        Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-ID: <20101229121601.179983b7@jbarnes-desktop>
In-Reply-To: <AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 11:40:04 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Dec 29, 2010 at 10:21 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > The only significant difference that I can see in the kernel message log
> > is this:
> 
> Hmm. I suspect that difference should have gone away with commit
> 92971021c6328 (Revert "drm: Don't try and disable an encoder that was
> never enabled"), but clearly that didn't fix your blank screen.
> 
> Does reverting commit 448f53a1ede54eb854d036abf54573281412d650
> ("drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks") fix it for
> you? It does for some people..
> 
> Chris - why did that lvds_ssc_freq thing suddenly start mattering? Can
> we please just disable spread-spectrum entirely? Or perhaps only if we
> notice that it was enabled already? Or something?

Randy, Jeff and Alex, does the below help at all?  If so, it may be the
minimal fix we want for 2.6.37.

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios
index 2b20786..d27d016 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -263,6 +263,9 @@ parse_general_features(struct drm_i915_private *dev_priv,
                dev_priv->int_tv_support = general->int_tv_support;
                dev_priv->int_crt_support = general->int_crt_support;
                dev_priv->lvds_use_ssc = general->enable_ssc;
+               /* force disable until we can parse this correctly */
+               if (IS_GEN5(dev) || IS_GEN6(dev))
+                       dev_priv->lvds_use_ssc = 0;
 
                if (dev_priv->lvds_use_ssc) {
                        if (IS_I85X(dev))


-- 
Jesse Barnes, Intel Open Source Technology Center
