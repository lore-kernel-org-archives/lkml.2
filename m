Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0DANgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:36:14 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34626 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0DANgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=iKkDReFTYraAkAXxSaGAP07hVLauwgThl+lsS5snSLgGCvxghrLXg48IBu++rno1Ty
         MQivamX79LrRVsVrrMJ4BMDg5q9IylRie+ugfhZut23viqQZSp/a9vAMHNBpd4YjsvCw
         Y8xHt/GA8zVGoFaMzSijoTSQuhrcqQsXMcVDo=
From: Karsten Wiese <fzuuzf@googlemail.com>
To: Andy Lutomirski <luto@myrealbox.com>
Subject: Re: i915 lockup / extreme delay
Date: Thu, 1 Apr 2010 14:35:59 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.x86_64; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>
References: <ho2jal$oqs$1@dough.gmane.org> <bad735c81003270254i5e1cdb3dv26c1566e5d005e9f@mail.gmail.com> <4BB49B04.2000303@myrealbox.com>
In-Reply-To: <4BB49B04.2000303@myrealbox.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011535.59629.fzuuzf@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 01 April 2010 schrieb Andy Lutomirski:
> Karl Vogel wrote:
> > On Mon, Mar 22, 2010 at 4:34 PM, Eric Anholt <eric@anholt.net> wrote:
> >> On Mon, 22 Mar 2010 09:11:06 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:
> >>> On Mon, Mar 22, 2010 at 5:20 AM, Eric Anholt <eric@anholt.net> wrote:
> >>>> On Sat, 20 Mar 2010 14:41:41 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:
> >>>>> The 'effect' is that only the mouse pointer works in the X server. The
> >>>>> cpu usage on the laptop during the sluggishness is minimal. When I
> >>>>> suspend the game with winedbg, the X server slowly becomes responsive again.
> >>>>>
> >>>>> The output from latencytop seems to point to i915 being the culprit:
> >>>> If there's some code doing glFlush()es, it's probably that code at
> >>>> fault.  You don't need to do that unless you're doing frontbuffer
> >>>> rendering, and if you're doing frontbuffer rendering you should really
> >>>> be doing backbuffer rendering.  I don't see a kernel issue here.
> >>> That doesnt explain why the box completely locks up on 2.6.34-rc2
> >>> though, where only a cold reboot works.
> >> Missed that part of the message.  If there's a regression, bisect
> >> please.
> > 
> > Apparently the crash was caused by a hardware bug in the intel chipset
> > which is 8086:2a40 rev 07. While doing the bisect I got an error:
> > 
> > DRHD: handling fault status reg 2
> > DMAR:[DMA Write] Request device [00:02.0] fault addr dd69a000
> > DMAR:[fault reason 05] PTE Write access is not set
> > 
> > After some googling around, I found this bugzilla entry which explains it:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=538163#c58
> > 
> > The issue appears that the graphics chip is corrupting memory:
> > 
> > "Unfortunately, this particular chipset sometimes reads from the GTT, does the
> > translation, then writes the translated address back to the _original_ GTT
> > instead of to the shadow GTT. That's why you're seeing real physical addresses
> > where you should have 'virtual DMA addresses', and you get the faults.   "
> > 
> > Adding "intel_iommu=igfx_off" to the kernel command line resolved the issue.
> > The fedora kernel automatically disables this when it detects this particular
> > chipset revision.
> > 
> > As for the freeze/slowdown right after booting, sysprof shows that more than 77%
> > of the time is spent inside: drm_mode_getconnector
> 
> http://lists.freedesktop.org/archives/intel-gfx/2010-February/005922.html
> 
> I'm waiting for the encoder/connector stuff to get merged before I 
> either pester people about that bug again or try to fix it myself.
> 
> You can try the same hack I use (comment out the initialization of all 
> digital outputs) if you don't use them -- that completely fixes it for me.

Andy, please try this patch.
Eric, please review.

Thanks,
Karsten

[RFC PATCH] drm/i915: Don't touch PORT_HOTPLUG_EN in intel_dp_detect()
 Von: Karsten Wiese <fzuuzf@googlemail.com>
 An: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
 
PORT_HOTPLUG_EN has allready been setup in i915_driver_irq_postinstall(),
when intel_dp_detect() runs.

Delete the DP[BCD]_HOTPLUG_INT_EN defines, they are not referenced anymore.

I found this while searching for a fix for
        https://bugzilla.redhat.com/show_bug.cgi?id=528312

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
---
See also 
"drm/i915: only enable hotplug for detected outputs"
b01f2c3a4a37d09a47ad73ccbb46d554d21cfeb0

 drivers/gpu/drm/i915/i915_reg.h |    3 ---
 drivers/gpu/drm/i915/intel_dp.c |   10 ----------
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index ab1bd2d..92f440d 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -854,11 +854,8 @@
 /* Hotplug control (945+ only) */
 #define PORT_HOTPLUG_EN                0x61110
 #define   HDMIB_HOTPLUG_INT_EN                 (1 << 29)
-#define   DPB_HOTPLUG_INT_EN                   (1 << 29)
 #define   HDMIC_HOTPLUG_INT_EN                 (1 << 28)
-#define   DPC_HOTPLUG_INT_EN                   (1 << 28)
 #define   HDMID_HOTPLUG_INT_EN                 (1 << 27)
-#define   DPD_HOTPLUG_INT_EN                   (1 << 27)
 #define   SDVOB_HOTPLUG_INT_EN                 (1 << 26)
 #define   SDVOC_HOTPLUG_INT_EN                 (1 << 25)
 #define   TV_HOTPLUG_INT_EN                    (1 << 18)
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 439506c..7a3b5c8 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1179,16 +1179,6 @@ intel_dp_detect(struct drm_connector *connector)
        if (IS_IRONLAKE(dev))
                return ironlake_dp_detect(connector);

-       temp = I915_READ(PORT_HOTPLUG_EN);
-
-       I915_WRITE(PORT_HOTPLUG_EN,
-              temp |
-              DPB_HOTPLUG_INT_EN |
-              DPC_HOTPLUG_INT_EN |
-              DPD_HOTPLUG_INT_EN);
-
-       POSTING_READ(PORT_HOTPLUG_EN);
-
        switch (dp_priv->output_reg) {
        case DP_B:
                bit = DPB_HOTPLUG_INT_STATUS;
--
