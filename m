Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2DATZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:25:36 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3886 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2DATZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:25:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tracey Dent <tdent48227@gmail.com>
Subject: Re: [PATCH 1/1] Drivers/media/radio: Fix build error
Date: Sun, 1 Apr 2012 21:24:48 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc1-durdane; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, shea@shealevy.com,
        torvalds@linux-foundation.org, mchehab@infradead.org,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org
References: <1333307374-25848-1-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1333307374-25848-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204012124.48701.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 01, 2012 21:09:34 Tracey Dent wrote:
> radio-maxiradio depends on SND_FM801_TEA575X_BOOL to build or will
> result in an build error such as:
> 
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> ERROR: "snd_tea575x_init" [drivers/media/radio/radio-maxiradio.ko] undefined!
> ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-maxiradio.ko] undefined!
> WARNING: modpost: Found 6 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Select CONFIG_SND_TEA575X to fixes problem and enable
> the driver to be built as desired.
> 
> v2:
> instead of selecting CONFIG_SND_FM801_TEA575X_BOOL, select
> CONFIG_SND_TEA575X, which in turns selects CONFIG_SND_FM801_TEA575X_BOOL
> and any other dependencies for it to build.

No, this is the correct patch:

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 8816804..5ca0939 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -2,8 +2,8 @@
 
 config SND_TEA575X
 	tristate
-	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2
-	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2
+	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO
+	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO
 
 menuconfig SND_PCI
 	bool "PCI sound devices"

RADIO_MAXIRADIO should be treated just like RADIO_SF16FMR2, I just didn't
realize at the time that it had to be added as a SND_TEA575X dependency.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

(Sorry for the late reply, I didn't have access to my cisco email for the last
few days).

Regards,

	Hans

> 
> Reported-by: Shea Levy <shea@shealevy.com>
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/media/radio/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 8db2d7f..b518ce5 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -44,6 +44,7 @@ config USB_DSBR
>  config RADIO_MAXIRADIO
>  	tristate "Guillemot MAXI Radio FM 2000 radio"
>  	depends on VIDEO_V4L2 && PCI && SND
> +	select SND_TEA575X
>  	---help---
>  	  Choose Y here if you have this radio card.  This card may also be
>  	  found as Gemtek PCI FM.
> 
