Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0KHR6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:58:41 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:39629 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0KHR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:58:39 -0500
Subject: Re: [Intel-gfx] [bisected] offset display bug in i915
From: Jon Masters <jonathan@jonmasters.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <5b55a1$ijk39t@fmsmga002.fm.intel.com>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
	 <b9dded$h0q3am@orsmga002.jf.intel.com>
	 <1289213695.3916.396.camel@constitution.bos.jonmasters.org>
	 <1289215364.3916.400.camel@constitution.bos.jonmasters.org>
	 <1289215749.3916.401.camel@constitution.bos.jonmasters.org>
	 <5b55a1$ijk39t@fmsmga002.fm.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 12:58:50 -0500
Message-ID: <1289239130.3916.417.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 12:13 +0000, Chris Wilson wrote:
> On Mon, 08 Nov 2010 06:29:09 -0500, Jon Masters <jonathan@jonmasters.org> wrote:
> > On Mon, 2010-11-08 at 06:22 -0500, Jon Masters wrote:
> > > As I mentioned on IRC, I'm familiar with how I2C works electrically, and
> > > therefore EDID implementation as a concept, but I am not really a
> > > graphics hacker so I wasn't aware that you prefer edid-decode :)
> > > 
> > > Here is a decoded version of the output:
> > 
> > And here is an old file I had with the output when running a broken
> > kernel with the cacheing enabled:
> 
> They look to be identical. So it is not necessarily the caching that is
> the issue, but that we now no longer do an essential step whilst bringing
> up the lvds. Can you just check that the reported EDIDs are the same for
> when it is behaving correctly and when the display is offset?

diff says they are the same. Here's the output from a broken kernel:

$ cat edid_broken_hexdump.txt 
0000000 ff00 ffff ffff 00ff 6422 03e9 8544 0001
0000010 141c 0301 1680 780d 860a 9426 5157 2790
0000020 4f21 0054 0000 0101 0101 0101 0101 0101
0000030 0101 0101 0101 1194 b000 5840 2019 2335
0000040 0045 81dc 0000 1900 1416 d800 5840 2026
0000050 235d 0415 81dc 0000 0000 0000 fe00 0000
0000060 0000 0000 0000 0000 0000 0000 0000 fe00
0000070 0000 0000 0000 0000 0100 0000 0000 f200
0000080

$ cat edid_broken_decode.txt
Extracted contents:
header:          00 ff ff ff ff ff ff 00
serial number:   22 64 e9 03 44 85 01 00 1c 14
version:         01 03
basic params:    80 16 0d 78 0a
chroma info:     86 26 94 57 51 90 27 21 4f 54
established:     00 00 00
standard:        01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
descriptor 1:    94 11 00 b0 40 58 19 20 35 23 45 00 dc 81 00 00 00 19
descriptor 2:    16 14 00 d8 40 58 26 20 5d 23 15 04 dc 81 00 00 00 00
descriptor 3:    00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00
descriptor 4:    00 00 00 fe 00 00 00 00 00 00 00 00 00 01 00 00 00 00
extensions:      00
checksum:        f2

Manufacturer: HSD Model 3e9 Serial Number 99652
Made week 28 of 2010
EDID version: 1.3
Digital display
Maximum image size: 22 cm x 13 cm
Gamma: 2.20
Supported color formats: RGB 4:4:4, YCrCb 4:2:2
First detailed timing is preferred timing
Established timings supported:
Standard timings supported:
Detailed mode: Clock 45.000 MHz, 220 mm x 129 mm
               1024 1077 1112 1200 hborder 0
                600  604  609  625 vborder 0
               -hsync -vsync
Detailed mode: Clock 51.420 MHz, 220 mm x 129 mm
               1024 1117 1152 1240 hborder 0
                600  617  622  638 vborder 0
               -hsync -vsync analog composite
ASCII string: ASCII string: Checksum: 0xf2
EDID block does NOT conform to EDID 1.3!
	Missing name descriptor
	Missing monitor ranges

> The secondary change in the commit was to use drm_get_edid() directly
> during device detection which delayed setting the EDID property on the
> connection until get_modes(). Does this make a difference?
> 
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c
> b/drivers/gpu/drm/i915/intel_lvds
> index f1a6499..17bcb7d 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -940,7 +940,10 @@ void intel_lvds_init(struct drm_device *dev)
>         intel_lvds->edid = drm_get_edid(connector,
>                                         &dev_priv->gmbus[pin].adapter);
>  
> -       if (!intel_lvds->edid) {
> +       if (intel_lvds->edid) {
> +               drm_mode_connector_update_edid_property(connector,
> +                                                       intel_lvds->edid);
> +       } else {

Nope. This makes no difference at all. Got anything else up your sleeve?

Jon.


