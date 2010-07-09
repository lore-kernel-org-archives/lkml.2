Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0GIUPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:15:35 -0400
Received: from mail.tpi.com ([70.99.223.143]:4347 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab0GIUPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:15:33 -0400
Message-ID: <4C37835E.7010704@canonical.com>
Date: Fri, 09 Jul 2010 14:15:26 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Woody Suwalski <terraluna977@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Yet another 2.6.35 regression (AGP)? (resend)
References: <4C37399D.3070604@gmail.com>
In-Reply-To: <4C37399D.3070604@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090804070004090004000302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090804070004090004000302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/09/2010 09:00 AM, Woody Suwalski wrote:
> I have found one system, where 2.6.35 does not work (as tested with rc3
> and rc4)
> That Intel system has no problems in 2.6.33.x nor 2.6.34.0.
>
> The problem seems to be in AGP - I can boot if I specify "agp=off" - but
> of course only in text mode...
> There seems to be a hard lock-up, so the only way to show the crash is
> by picture 8-)
>
> Since I do not build kernel on that machine, I did not do any bisect
> tests, however if someone is interested in digging deeper, I can try...
> Preferably a patch to try out ;-)
>
> This bug seems to be different then
> https://bugzilla.kernel.org/show_bug.cgi?id=16179
>
> Should it be blamed on BIOS (the conflict indicated just before the crash)?
>
> Thanks, Woody
>
> PS. Resending, as original post cc'd
> drivers_video-dri-intel@kernel-bugs.osdl.org, what seems to be bad...
>

How about this patch? I'm waiting confirmation from another user, but 
your problem looks quite similar.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------090804070004090004000302
Content-Type: text/x-patch;
 name="0001-UBUNTU-Upstream-i915-Use-the-correct-mask-to-detect-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-UBUNTU-Upstream-i915-Use-the-correct-mask-to-detect-.pa";
 filename*1="tch"

>From 684925d4ba303f9e23b428831c2386f0203d6622 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Fri, 9 Jul 2010 11:14:41 -0600
Subject: [PATCH] i915: Use the correct mask to detect i830 aperture size.

BugLink: https://bugs.launchpad.net/bugs/597075

commit f1befe71fa7a79ab733011b045639d8d809924ad introduced a regression when
detecting aperture size of some i915 adapters, e.g., those on the
Intel Q35 shipset.

The original report: https://bugzilla.kernel.org/show_bug.cgi?id=15733
The regression report: https://bugzilla.kernel.org/show_bug.cgi?id=16294

According to the specification found at http://intellinuxgraphics.org/VOL_1_graphics_core.pdf,
the PCI config space register I830_GMCH_CTRL is a mirror of GMCH Graphics Control. The correct
macro for isolating the aperture size bits is therefore I830_GMCH_GMS_MASK along with the
attendant changes to the case statement.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Eric Anholt <eric@anholt.net>
---
 drivers/char/agp/intel-gtt.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 9344216..a754715 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1216,17 +1216,20 @@ static int intel_i915_get_gtt_size(void)
 
 		/* G33's GTT size defined in gmch_ctrl */
 		pci_read_config_word(agp_bridge->dev, I830_GMCH_CTRL, &gmch_ctrl);
-		switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
-		case G33_PGETBL_SIZE_1M:
+		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
+		case I830_GMCH_GMS_STOLEN_512:
+			size = 512;
+			break;
+		case I830_GMCH_GMS_STOLEN_1024:
 			size = 1024;
 			break;
-		case G33_PGETBL_SIZE_2M:
-			size = 2048;
+		case I830_GMCH_GMS_STOLEN_8192:
+			size = 8*1024;
 			break;
 		default:
 			dev_info(&agp_bridge->dev->dev,
 				 "unknown page table size 0x%x, assuming 512KB\n",
-				(gmch_ctrl & G33_PGETBL_SIZE_MASK));
+				(gmch_ctrl & I830_GMCH_GMS_MASK));
 			size = 512;
 		}
 	} else {
-- 
1.7.0.4


--------------090804070004090004000302--
