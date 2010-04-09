Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0DIDUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:20:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:56971 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752731Ab0DIDUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:20:34 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18V8fUf3ygV2WpqkJb64MH3sh8lIByhe1Iq5F+xCm
	IeNiA3mGbRf6mL
Message-ID: <4BBE9CFC.2020804@gmx.de>
Date: Fri, 09 Apr 2010 05:20:28 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/16] viafb: Determine type of 2D engine and store it
 in chip_info
References: <1270746946-12467-1-git-send-email-corbet@lwn.net> <1270746946-12467-6-git-send-email-corbet@lwn.net>
In-Reply-To: <1270746946-12467-6-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> From: Harald Welte <laforge@gnumonks.org>
> 
> This will help us for the upcoming support for 2D acceleration using
> the M1 engine.
> 
> [jc: fixed merge conflicts]
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>

That's probably a good idea (although most things are already done in 
the separate blitting functions).
Just a minor nit:
Could we change the default so that if someone adds support for a new 
IGP (and misses this function) we default to either the newest or 
preferably to none? I've just seen too much poorly maintained code in 
this driver and defaulting to the oldest is hence a bad idea.
Otherwise it's fine.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/via/chip.h |    8 ++++++++
>  drivers/video/via/hw.c   |   15 +++++++++++++++
>  2 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
> index 474f428..f799e2c 100644
> --- a/drivers/video/via/chip.h
> +++ b/drivers/video/via/chip.h
> @@ -122,9 +122,17 @@ struct lvds_chip_information {
>  	int i2c_port;
>  };
>  
> +/* The type of 2D engine */
> +enum via_2d_engine {
> +	VIA_2D_ENG_H2,
> +	VIA_2D_ENG_H5,
> +	VIA_2D_ENG_M1,
> +};
> +
>  struct chip_information {
>  	int gfx_chip_name;
>  	int gfx_chip_revision;
> +	enum via_2d_engine twod_engine;
>  	struct tmds_chip_information tmds_chip_info;
>  	struct lvds_chip_information lvds_chip_info;
>  	struct lvds_chip_information lvds_chip_info2;
> diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
> index f2e4bda..963704e 100644
> --- a/drivers/video/via/hw.c
> +++ b/drivers/video/via/hw.c
> @@ -2034,6 +2034,21 @@ static void init_gfx_chip_info(struct pci_dev *pdev,
>  				CX700_REVISION_700;
>  		}
>  	}
> +
> +	/* Determine which 2D engine we have */
> +	switch (viaparinfo->chip_info->gfx_chip_name) {
> +	case UNICHROME_VX800:
> +	case UNICHROME_VX855:
> +		viaparinfo->chip_info->twod_engine = VIA_2D_ENG_M1;
> +		break;
> +	case UNICHROME_K8M890:
> +	case UNICHROME_P4M900:
> +		viaparinfo->chip_info->twod_engine = VIA_2D_ENG_H5;
> +		break;
> +	default:
> +		viaparinfo->chip_info->twod_engine = VIA_2D_ENG_H2;
> +		break;
> +	}
>  }
>  
>  static void init_tmds_chip_info(void)

