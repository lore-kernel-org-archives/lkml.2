Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2ETJw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 05:52:26 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4595 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2ETJwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 05:52:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [PATCH V6 2/5] New control class and features for FM RX
Date: Sun, 20 May 2012 11:52:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc7-durdane; KDE/4.7.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>, mchehab@redhat.com,
        Hans de Goede <hdegoede@redhat.com>
References: <1337032913-18646-1-git-send-email-manjunatha_halli@ti.com> <1337032913-18646-3-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1337032913-18646-3-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205201152.12948.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue May 15 2012 00:01:50 manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <x0130808@ti.com>
> 
> This patch creates new ctrl class for FM RX and adds new CID's for
> below FM features,
>       1) De-Emphasis filter mode
>       2) RDS Alternate Frequency switch
> 
> Also this patch adds a field for band selection in struct v4l2_hw_freq_seek
> and adds new capability flags for all below FM bands
> 	1) V4L2_TUNER_CAP_BAND_TYPE_DEFAULT -> Default Band
> 	2) V4L2_TUNER_CAP_BAND_TYPE_EUROPE_US -> Europe/US Band
> 	3) V4L2_TUNER_CAP_BAND_TYPE_JAPAN   -> Japan Band
> 	4) V4L2_TUNER_CAP_BAND_TYPE_RUSSIAN -> Russian Band
> 	5) V4L2_TUNER_CAP_BAND_TYPE_WEATHER -> Weather Band
> 
> Signed-off-by: Manjunatha Halli <x0130808@ti.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |   17 ++++++++++++++---
>  include/linux/videodev2.h        |   24 +++++++++++++++++++++++-
>  2 files changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index c9c9a46..7b3dd95 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h

...

> @@ -1819,6 +1827,12 @@ struct v4l2_modulator {
>  #define V4L2_TUNER_CAP_RDS		0x0080
>  #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
>  #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
> +#define V4L2_TUNER_CAP_BAND_TYPE_DEFAULT	0x00000000	/* Default band */
> +#define V4L2_TUNER_CAP_BAND_TYPE_EUROPE_US	0x00010000	/* Europe/US band */
> +#define V4L2_TUNER_CAP_BAND_TYPE_JAPAN		0x00020000	/* Japan band */
> +#define V4L2_TUNER_CAP_BAND_TYPE_RUSSIAN	0x00030000	/* Russian band */
> +#define V4L2_TUNER_CAP_BAND_TYPE_WEATHER	0x00040000	/* Weather band */

Argh! These capabilities are wrong: these should have been 0x10000, 0x20000,
0x40000 and 0x80000! Bits that you can OR together.

Also, I think _TYPE can be dropped here, just as we did for the V4L2_FM_BAND
defines below.

V4L2_TUNER_CAP_BAND_TYPE_DEFAULT is useless as a capability and should be
dropped.

Manju, I would recommend that you split off the frequency band handling from
the other patches. Based on an RFC from Hans de Goede regarding work on the AM
band I believe we need to postpone this part for 3.6. The other patches in this
series not related to frequency bands are fine and you can keep my Acked-by
there.

Mauro, if you intended to merge Manjunatha's patches for 3.5, then please wait
with merging them until he had a chance to split off the frequency band bits.

Regards,

	Hans

> +
>  
>  /*  Flags for the 'rxsubchans' field */
>  #define V4L2_TUNER_SUB_MONO		0x0001
> @@ -1843,13 +1857,21 @@ struct v4l2_frequency {
>  	__u32		      reserved[8];
>  };
>  
> +
> +#define V4L2_FM_BAND_DEFAULT	0
> +#define V4L2_FM_BAND_EUROPE_US	1	/* 87.5 Mhz - 108 MHz */
> +#define V4L2_FM_BAND_JAPAN	2	/* 76 MHz - 90 MHz */
> +#define V4L2_FM_BAND_RUSSIAN	3	/* 65.8 MHz - 74 MHz */
> +#define V4L2_FM_BAND_WEATHER	4	/* 162.4 MHz - 162.55 MHz */
> +
>  struct v4l2_hw_freq_seek {
>  	__u32		      tuner;
>  	enum v4l2_tuner_type  type;
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
>  	__u32		      spacing;
> -	__u32		      reserved[7];
> +	__u32		      band;
> +	__u32		      reserved[6];
>  };
>  
>  /*
> 
