Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2LTGh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:37:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:64494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2LTGhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:37:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="260024315"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "perex@perex.cz" <perex@perex.cz>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
Thread-Topic: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
Thread-Index: AQHN3cjeRPGUDRLeCE+nx4ke5XXEeZghNNwg
Date: Thu, 20 Dec 2012 06:37:26 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1F3CA7@SHSMSX101.ccr.corp.intel.com>
References: <1355913397.17896.10.camel@cliu38-desktop-build>
 <20121219091127.GL4985@opensource.wolfsonmicro.com>
In-Reply-To: <20121219091127.GL4985@opensource.wolfsonmicro.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, December 19, 2012 5:11 PM
> To: Liu, Chuansheng
> Cc: lrg@ti.com; perex@perex.cz; tiwai@suse.de; alsa-devel@alsa-project.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
> 
> On Wed, Dec 19, 2012 at 06:36:37PM +0800, Chuansheng Liu wrote:
> 
> > But some devices has been set to STANDY bias directly during device probing,
> > such as cs42l73_probe():
> > cs42l73_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
> 
> > Then it will cause runtime_get() not be called but laterly runtime_put() will
> > be called. Also found some other uppaired cases.
> 
> This is just a bug in the driver, if it's idle_bias_off then it really
> should be starting in _OFF or at the very least starting actually in
> _STANDBY (including taking the runtime reference) rather than partially
> in _STANDBY.
Thanks your pointing out. You are totally right.
Rechecked the related driver code, there is one place which starting from _STANDBY with idle_bias_off.
It should be the main reason of bringing unpaired issue.

Meanwhile, is it useful to add one warning there for that case?
After all, in probing, set the bias to _STANDBY even idle_bias_off == 1, and calling get_runtime_sync(), it
will let the code more obscure. So giving a warning there to indicate the driver:
it is not suggested that in probing, set the bias to _STANDBY even idle_bias_off == 1.

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 9c768bc..d6adaec 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1102,6 +1102,8 @@ static int soc_probe_codec(struct snd_soc_card *card,
 
        if (driver->probe) {
                ret = driver->probe(codec);
+               WARN_ON(codec->dapm.idle_bias_off &&
+                       codec->dapm.bias_level != SND_SOC_BIAS_OFF);
                if (ret < 0) {
                        dev_err(codec->dev,
                                "ASoC: failed to probe CODEC %d\n", ret);
