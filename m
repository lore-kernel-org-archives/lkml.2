Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab0DABKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:10:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46346 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169Ab0DABKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:10:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 (was: Re: Linux 2.6.34-rc3)
Date: Thu, 1 Apr 2010 03:13:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Clemens Ladisch <clemens@ladisch.de>,
       Alex Deucher <alexdeucher@gamil.com>, stable@kernel.org,
       Greg KH <gregkh@suse.de>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <201003302316.45651.rjw@sisk.pl>
In-Reply-To: <201003302316.45651.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004010313.32920.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010, Rafael J. Wysocki wrote:
> On Tuesday 30 March 2010, Linus Torvalds wrote:
> ...
> > Other than that? Random fixes and updates all over. Mostly drivers and 
> > filesystems, and mostly fairly small things. If you had PCI resource 
> > conflict problems with the early -rc's due to the _CRS window thing, for 
> > example, that should hopefully be fixed. See the appended shortlog for 
> > other details.
> 
> ...
> 
> > Clemens Ladisch (4):
> >       firewire: core: fw_iso_resource_manage: fix error handling
> >       firewire: ohci: add cycle timer quirk for the TI TSB12LV22
> >       ALSA: cmipci: work around invalid PCM pointer
> >       PCI quirk: RS780/RS880: work around missing MSI initialization
> 
> This one (commit a5ee4eb7541) broke OpenGL acceleration on my new test box
> which happens to have a RS780.
> 
> The symptom is that every operation involving the GPU is _very_ slow, so the
> window manager eventually disables compositing.  Reverting this commit makes
> things work flawlessly again.
> 
> So, please revert.
> 
> BTW, I don't think it's a -stable material.

OK, I've verified that partial revert (below) is sufficient.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: DRM / radeon: Really do not try to enable MSI on RS780 and RS880

Commit a5ee4eb75413c145334c30e43f1af9875dad6fd7
(PCI quirk: RS780/RS880: work around missing MSI initialization)
removed a quirk to disable MSI on RS780 and RS880, which still is
necessary on my Acer Ferrari One, because pci_enable_msi() attempts
to enable the MSI and apparently succeeds despite the PCI quirk
added by that commit.  Add the removed radeon quirk again.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/gpu/drm/radeon/radeon_irq_kms.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ linux-2.6/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -116,7 +116,13 @@ int radeon_irq_kms_init(struct radeon_de
 	}
 	/* enable msi */
 	rdev->msi_enabled = 0;
-	if (rdev->family >= CHIP_RV380) {
+       /* MSIs don't seem to work on my rs780;
+        * not sure about rs880 or other rs780s.
+        * Needs more investigation.
+        */
+       if ((rdev->family >= CHIP_RV380) &&
+           (rdev->family != CHIP_RS780) &&
+           (rdev->family != CHIP_RS880)) {
 		int ret = pci_enable_msi(rdev->pdev);
 		if (!ret) {
 			rdev->msi_enabled = 1;
