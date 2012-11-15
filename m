Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab2KOLni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:43:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933097Ab2KOLng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:43:36 -0500
Date: Thu, 15 Nov 2012 09:43:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, hpa@linux.intel.com
Subject: Re: Wrong defaults in 3.7-rc3
Message-ID: <20121115094324.2760bc8d@redhat.com>
In-Reply-To: <20121115110620.GA3451@elf.ucw.cz>
References: <20121115110620.GA3451@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 15 Nov 2012 12:06:20 +0100
Pavel Machek <pavel@ucw.cz> escreveu:


>   DiBcom DiB0070 silicon base-band tuner (DVB_TUNER_DIB0070) [M/n/y/?]
>   (NEW) n
>   DiBcom DiB0090 silicon base-band tuner (DVB_TUNER_DIB0090) [M/n/y/?]
>   (NEW) n
> 
> M is never good config default.

Had you ever seen the Kconfig logic for tuners? They're not enabled by default.

config MEDIA_SUBDRV_AUTOSELECT
        bool "Autoselect tuners and i2c modules to build"
        depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT
        default y
        help
          By default, a media driver auto-selects all possible i2c
          devices that are used by any of the supported devices.

          This is generally the right thing to do, except when there
          are strict constraints with regards to the kernel size,
          like on embedded systems.

          Use this option with care, as deselecting ancillary drivers which
          are, in fact, necessary will result in the lack of the needed
          functionality for your device (it may not tune or may not have
          the need demodulers).

          If unsure say Y.
...

menu "Customise DVB Frontends"
        visible if !MEDIA_SUBDRV_AUTOSELECT

comment "Multistandard (satellite) frontends"
        depends on DVB_CORE

...

config DVB_TUNER_DIB0070
        tristate "DiBcom DiB0070 silicon base-band tuner"
        depends on I2C
        default m if !MEDIA_SUBDRV_AUTOSELECT
        help
          A driver for the silicon baseband tuner DiB0070 from DiBcom.
          This device is only used inside a SiP called together with a
          demodulator for now.

People should never disable MEDIA_SUBDRV_AUTOSELECT, except if they know
exactly what they're doing and they have very strict diskspace constraints,
as the DVB driver may stop working without support for the needed 
ancillary chips present at the DVB card.

The default "M" is there to prevent people to open NOT_A_BUG bugzillas
when they do stupid things like disabling MEDIA_SUBDRV_AUTOSELECT without
knowing that this can break the driver for their cards.

-- 
Regards,
Mauro
