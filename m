Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1EPVDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:03:31 -0400
Received: from smtp16.mail.ru ([94.100.176.153]:42158 "EHLO smtp16.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1EPVD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:03:29 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Eric Miao <eric.y.miao@gmail.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] ASoC: add support for audio on iPaq hx4700
Date: Tue, 17 May 2011 01:03:22 +0400
Message-Id: <1305579805-15617-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.4.rc3
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here's patches adding audio support for good ole iPAQ hx4700: ak4641
codec, hx4700 machine sound driver and some glue platform code.
It took quite longer to make v2 than I expected, but it's finally here.
Sorry for such late submission in this release cycle, but if it's not ready
yet, no big deal - it certainly can wait for 2.6.41.

v1 of these patches can be found here:
http://lkml.org/lkml/2010/11/20/50

Current patchset is based on next-20110513 (it also can be applied to
2.6.39-rc7 after slight adjustment of Kconfig/Makefile chunks)

Latest version of these patches were only slightly tested on top of 2.6.39-rc7
(-next is tested compile-only, as it doesn't boot due to some unrelated bugs),
but all basic operations like playback, recording, EQ, Speaker, Mic Sidetone
seem to work.

Changes from v1:

AK4641 codec:

* '-codec' is removed from 'ak4641-codec' platform device name
* SNDRV_PCM_RATE_8000_48000 macro now used instead of explicit freqs listing
* Unneeded ifdef's on CONFIG_I2C are removed
* Missing "Volume" added to names of volume controls, ditto for switches
* TLV information is added to various volume controls
* Enum control doesn't use indexed array of strings anymore
* Enum controls like 'Mic Boost +20dB/0dB' are turned into volume controls
* Deemphasis control is converted from enum to switch with automatic
  detection of optimal deemphasis value depending on current playback frequency
* Check for wrong fs value is added to hw_params for HiFi DAI
  (that actually uncovered bug in hx4700 machine driver - it never set
  sysclk for the codec. Sound worked properly this way due to strange
  coincidence: both default fs in codec driver and divider in PXA i2s hardware
  were equal 256)
* empty hw_params() function for Voice DAI is removed. Looks like that
  samplerate of Voice ADC/DAC can't be controlled by software at all, only
  format of samples. This Voice DAC/ADC are designed to be connected to
  Bluetooth chip, so I suspect codec gets sampling frequency directly
  from it.
* Names of mic sidetone controls are adjusted
* 'Left/Right Out Enable' DAPM controls are turned into ordinary ones
* Mute code readability is slightly improved (based on Axel Lin's patch
  for ak4535 - commit cca67a3668)
* My copyright is added to file, so people won't blame Harald for all the
  bugs I added during multicomponent conversion and other cleanup :)
* Power/reset GPIOs are now handled in set_bias_level(), so codec is
  powered only when needed.

HX4700 sound:

* Setting of codec's sysclk is added to hw_params()

HX4700 platform:

* No changes


Dmitry Artamonow (2):
  ASoC: Asahi Kasei AK4641 codec driver
  ASoC: add iPAQ hx4700 machine driver

Philipp Zabel (1):
  pxa/hx4700: add I2C board info for AK4641 codec

 arch/arm/mach-pxa/hx4700.c              |   18 +
 arch/arm/mach-pxa/include/mach/hx4700.h |    4 +-
 include/sound/ak4641.h                  |   26 ++
 sound/soc/codecs/Kconfig                |    4 +
 sound/soc/codecs/Makefile               |    2 +
 sound/soc/codecs/ak4641.c               |  687 +++++++++++++++++++++++++++++++
 sound/soc/codecs/ak4641.h               |   47 +++
 sound/soc/pxa/Kconfig                   |    9 +
 sound/soc/pxa/Makefile                  |    2 +
 sound/soc/pxa/hx4700.c                  |  260 ++++++++++++
 10 files changed, 1057 insertions(+), 2 deletions(-)
 create mode 100644 include/sound/ak4641.h
 create mode 100644 sound/soc/codecs/ak4641.c
 create mode 100644 sound/soc/codecs/ak4641.h
 create mode 100644 sound/soc/pxa/hx4700.c

-- 
1.7.4.rc1

