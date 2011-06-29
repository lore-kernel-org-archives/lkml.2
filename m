Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1F2JuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:50:25 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:33045 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab1F2JuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:50:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: achew@nvidia.com
Subject: Re: [PATCH 3/6 v3] [media] ov9740: Fixed some settings
Date: Wed, 29 Jun 2011 11:50:38 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        g.liakhovetski@gmx.de, mchehab@redhat.com, olof@lixom.net
References: <1308871184-6307-1-git-send-email-achew@nvidia.com> <1308871184-6307-3-git-send-email-achew@nvidia.com>
In-Reply-To: <1308871184-6307-3-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291150.39091.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Friday 24 June 2011 01:19:41 achew@nvidia.com wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> Based on vendor feedback, should issue a software reset at start of day.
> 
> Also, OV9740_ANALOG_CTRL15 needs to be changed so the sensor does not begin
> streaming until it is ready (otherwise, results in a nonsense frame for the
> initial frame).
> 
> Added a comment on using discontinuous clock.
> 
> Finally, OV9740_ISP_CTRL19 needs to be changed to really use YUYV ordering
> (the previous value was for VYUY).

I've never liked those magic values. Fixing the whole driver to document 
everything in one go might be too much work, but what about documenting new 
registers, and especially their contents, as you add support for them ?

> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  drivers/media/video/ov9740.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
> index d5c9061..72c6ac1d 100644
> --- a/drivers/media/video/ov9740.c
> +++ b/drivers/media/video/ov9740.c
> @@ -68,6 +68,7 @@
>  #define OV9740_ANALOG_CTRL04		0x3604
>  #define OV9740_ANALOG_CTRL10		0x3610
>  #define OV9740_ANALOG_CTRL12		0x3612
> +#define OV9740_ANALOG_CTRL15		0x3615
>  #define OV9740_ANALOG_CTRL20		0x3620
>  #define OV9740_ANALOG_CTRL21		0x3621
>  #define OV9740_ANALOG_CTRL22		0x3622
> @@ -222,6 +223,9 @@ struct ov9740_priv {
>  };
> 
>  static const struct ov9740_reg ov9740_defaults[] = {
> +	/* Software Reset */
> +	{ OV9740_SOFTWARE_RESET,	0x01 },
> +
>  	/* Banding Filter */
>  	{ OV9740_AEC_B50_STEP_HI,	0x00 },
>  	{ OV9740_AEC_B50_STEP_LO,	0xe8 },
> @@ -333,6 +337,7 @@ static const struct ov9740_reg ov9740_defaults[] = {
>  	{ OV9740_ANALOG_CTRL10,		0xa1 },
>  	{ OV9740_ANALOG_CTRL12,		0x24 },
>  	{ OV9740_ANALOG_CTRL22,		0x9f },
> +	{ OV9740_ANALOG_CTRL15,		0xf0 },
> 
>  	/* Sensor Control */
>  	{ OV9740_SENSOR_CTRL03,		0x42 },
> @@ -385,7 +390,7 @@ static const struct ov9740_reg ov9740_defaults[] = {
>  	{ OV9740_LN_LENGTH_PCK_LO,	0x62 },
> 
>  	/* MIPI Control */
> -	{ OV9740_MIPI_CTRL00,		0x44 },
> +	{ OV9740_MIPI_CTRL00,		0x44 }, /* 0x64 for discontinuous clk */

You should instead add

#define OV9740_MIPI_CTRL00_DISC_CLK		0x20

just below the OV9740_MIPI_CTRL00 definition, with a comment to explain what 
it's for (and rename CTRL00 to something more meaningful if possible). Same 
for the other registers you modify.

>  	{ OV9740_MIPI_3837,		0x01 },
>  	{ OV9740_MIPI_CTRL01,		0x0f },
>  	{ OV9740_MIPI_CTRL03,		0x05 },
> @@ -393,6 +398,9 @@ static const struct ov9740_reg ov9740_defaults[] = {
>  	{ OV9740_VFIFO_RD_CTRL,		0x16 },
>  	{ OV9740_MIPI_CTRL_3012,	0x70 },
>  	{ OV9740_SC_CMMM_MIPI_CTR,	0x01 },
> +
> +	/* YUYV order */
> +	{ OV9740_ISP_CTRL19,		0x02 },
>  };
> 
>  static const struct ov9740_reg ov9740_regs_vga[] = {

-- 
Regards,

Laurent Pinchart
