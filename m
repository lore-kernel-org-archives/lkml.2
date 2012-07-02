Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab2GBH1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:27:33 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:38002 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2GBH1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:27:30 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvFPAOpM8U9V5qg+PGdsb2JhbAA8CYoVrEUZAQEBAR4ZDSeCGAEBBAEnExwjBQsIAw44FCUKGhOIBgm7LxSLOIUpYAOVM4VmjH8
X-IronPort-AV: E=Sophos;i="4.77,508,1336341600"; 
   d="scan'208";a="73152124"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 2 Jul 2012 09:27:40 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: synaptics - print firmware ID and board
 number at init
Message-ID: <20120702072740.GA624@polaris.bitmath.org>
References: <1340859117-19654-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340859117-19654-1-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Read the Firmware ID and Board Number from a synaptics device at init
> and display them in the system log.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/mouse/synaptics.c |   38 ++++++++++++++++++++++++++++++++++++--
>  drivers/input/mouse/synaptics.h |    3 +++
>  2 files changed, 39 insertions(+), 2 deletions(-)

Is there a specific usecase for this, except the nice-to-have?

> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index c778f27..81685c1 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -139,6 +139,35 @@ static int synaptics_model_id(struct psmouse *psmouse)
>  }
>  
>  /*
> + * Read the board id from the touchpad
> + * The board id is encoded in the "QUERY MODES" response
> + */
> +static int synaptics_board_id(struct psmouse *psmouse)
> +{
> +	struct synaptics_data *priv = psmouse->private;
> +	unsigned char bid[3];
> +
> +	if (synaptics_send_cmd(psmouse, SYN_QUE_MODES, bid))
> +		return -1;
> +	priv->board_id = (((unsigned)bid[0] & 0xfc) << 6) | (unsigned)bid[1];

The type cast is not necessary.

> +	return 0;
> +}
> +
> +/*
> + * Read the firmware id from the touchpad
> + */
> +static int synaptics_firmware_id(struct psmouse *psmouse)
> +{
> +	struct synaptics_data *priv = psmouse->private;
> +	unsigned char fwid[3];
> +
> +	if (synaptics_send_cmd(psmouse, SYN_QUE_FIRMWARE_ID, fwid))
> +		return -1;
> +	priv->firmware_id = (fwid[0] << 16) | (fwid[1] << 8) | fwid[2];
> +	return 0;
> +}
> +
> +/*
>   * Read the capability-bits from the touchpad
>   * see also the SYN_CAP_* macros
>   */
> @@ -261,6 +290,10 @@ static int synaptics_query_hardware(struct psmouse *psmouse)
>  		return -1;
>  	if (synaptics_model_id(psmouse))
>  		return -1;
> +	if (synaptics_firmware_id(psmouse))
> +		return -1;
> +	if (synaptics_board_id(psmouse))
> +		return -1;
>  	if (synaptics_capability(psmouse))
>  		return -1;
>  	if (synaptics_resolution(psmouse))
> @@ -1434,11 +1467,12 @@ static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
>  	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
>  
>  	psmouse_info(psmouse,
> -		     "Touchpad model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
> +		     "Touchpad model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx, board id: %lu, fw id: %lu\n",
>  		     SYN_ID_MODEL(priv->identity),
>  		     SYN_ID_MAJOR(priv->identity), SYN_ID_MINOR(priv->identity),
>  		     priv->model_id,
> -		     priv->capabilities, priv->ext_cap, priv->ext_cap_0c);
> +		     priv->capabilities, priv->ext_cap, priv->ext_cap_0c,
> +		     priv->board_id, priv->firmware_id);
>  
>  	set_input_params(psmouse->dev, priv);
>  
> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
> index fd26ccc..e594af0 100644
> --- a/drivers/input/mouse/synaptics.h
> +++ b/drivers/input/mouse/synaptics.h
> @@ -18,6 +18,7 @@
>  #define SYN_QUE_SERIAL_NUMBER_SUFFIX	0x07
>  #define SYN_QUE_RESOLUTION		0x08
>  #define SYN_QUE_EXT_CAPAB		0x09
> +#define SYN_QUE_FIRMWARE_ID		0x0a
>  #define SYN_QUE_EXT_CAPAB_0C		0x0c
>  #define SYN_QUE_EXT_MAX_COORDS		0x0d
>  #define SYN_QUE_EXT_MIN_COORDS		0x0f
> @@ -148,6 +149,8 @@ struct synaptics_hw_state {
>  struct synaptics_data {
>  	/* Data read from the touchpad */
>  	unsigned long int model_id;		/* Model-ID */
> +	unsigned long int firmware_id;		/* Firmware-ID */
> +	unsigned long int board_id;		/* Board-ID */
>  	unsigned long int capabilities;		/* Capabilities */
>  	unsigned long int ext_cap;		/* Extended Capabilities */
>  	unsigned long int ext_cap_0c;		/* Ext Caps from 0x0c query */
> -- 
> 1.7.7.3
> 

Thanks,
Henrik
