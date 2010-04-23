Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0DWU4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:56:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:50477 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753664Ab0DWU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:56:52 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/WnUQEGSTWLZk4S61zMzMubEPysr7AOAcNIyPF2z
	yNaIk/A0a94kk2
Message-ID: <4BD2098E.70601@gmx.de>
Date: Fri, 23 Apr 2010 22:56:46 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 09/11] viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
References: <1271614873-5952-1-git-send-email-corbet@lwn.net> <1271614873-5952-10-git-send-email-corbet@lwn.net>
In-Reply-To: <1271614873-5952-10-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

I fear your analysis that the #ifdef's are not needed is wrong. At least 
with this patch applied I get:

drivers/video/via/hw.c: In function 'init_tmds_chip_info':
drivers/video/via/hw.c:2043: error: implicit declaration of function 
'machine_is_olpc'

drivers/video/via/lcd.c: In function 'viafb_lvds_trasmitter_identify':
drivers/video/via/lcd.c:179: error: implicit declaration of function 
'machine_is_olpc'

So I vote for taking the original patch but in the series that also adds 
the relevant config option.


Thanks,

Florian Tobias Schandinat

Jonathan Corbet schrieb:
> From: Chris Ball <cjb@laptop.org>
> 
> The i2c transactions involved in detecting LVDS (9 seconds) and TMDS
> (16 seconds) add an extra 25 seconds to viafb load time on the XO-1.5.
> 
> [jc: minor merge conflict fixed, removed ifdefs]
> Signed-off-by: Chris Ball <cjb@laptop.org>
> ---
>  drivers/video/via/hw.c  |    7 +++++++
>  drivers/video/via/lcd.c |    7 +++++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
> index 4aff0f7..bd5d5ce 100644
> --- a/drivers/video/via/hw.c
> +++ b/drivers/video/via/hw.c
> @@ -2037,6 +2037,13 @@ static void init_gfx_chip_info(struct pci_dev *pdev,
>  
>  static void init_tmds_chip_info(void)
>  {
> +	/*
> +	 * OLPC XO 1.5 systems are wired differently, so there is
> +	 * no point in them here.
> +	 */
> +	if (machine_is_olpc())
> +		return;
> +
>  	viafb_tmds_trasmitter_identify();
>  
>  	if (INTERFACE_NONE == viaparinfo->chip_info->tmds_chip_info.
> diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
> index b656e59..ce3f4b6 100644
> --- a/drivers/video/via/lcd.c
> +++ b/drivers/video/via/lcd.c
> @@ -173,6 +173,13 @@ static bool lvds_identify_integratedlvds(void)
>  
>  int viafb_lvds_trasmitter_identify(void)
>  {
> +	/*
> +	 * OLPC XO 1.5 systems are wired differently, so there is
> +	 * no point in them here.
> +	 */
> +	if (machine_is_olpc())
> +		return FAIL;
> +
>  	viaparinfo->shared->i2c_stuff.i2c_port = I2CPORTINDEX;
>  	if (viafb_lvds_identify_vt1636()) {
>  		viaparinfo->chip_info->lvds_chip_info.i2c_port = I2CPORTINDEX;

