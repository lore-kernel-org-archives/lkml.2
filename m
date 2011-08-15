Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1HOWtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 18:49:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1HOWtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 18:49:10 -0400
Subject: Re: [PATCH v2] libertas: prioritize usb8388_olpc.bin firmware on
 OLPC machines
From: Dan Williams <dcbw@redhat.com>
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, libertas-dev@lists.infradead.org,
        dsd@laptop.org, cjb@laptop.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Aug 2011 17:51:18 -0500
In-Reply-To: <20110804160652.2c87efef@debxo>
References: <20110804160652.2c87efef@debxo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1313448679.6103.13.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 16:06 -0700, Andres Salomon wrote:
> Normally, the v9 firmware will be loaded if it's available.  However, on
> OLPC XO-1 machines, the olpc-specific firmware supports extra functionality.
> This makes the libertas driver attempt to load the custom firmware first
> if the machine is an OLPC machine; if that fails (or it's not an OLPC
> machine), fall back to attempting to load the other firmwares.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Signed-off-by: Dan Williams <dcbw@redhat.com>

works for me...

> ---
>  drivers/net/wireless/libertas/if_usb.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index b5acc39..527cb11 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -973,6 +973,23 @@ static const struct {
>  	{ MODEL_8682, "libertas/usb8682.bin" }
>  };
>  
> +#ifdef CONFIG_OLPC
> +
> +static int try_olpc_fw(struct if_usb_card *cardp)
> +{
> +	int retval = -ENOENT;
> +
> +	/* try the OLPC firmware first; fall back to fw_table list */
> +	if (machine_is_olpc() && cardp->model == MODEL_8388)
> +		retval = request_firmware(&cardp->fw, "usb8388_olpc.bin",
> +				&cardp->udev->dev);
> +	return retval;
> +}
> +
> +#else
> +static int try_olpc_fw(struct if_usb_card *cardp) { return -ENOENT; }
> +#endif /* !CONFIG_OLPC */
> +
>  static int get_fw(struct if_usb_card *cardp, const char *fwname)
>  {
>  	int i;
> @@ -981,6 +998,10 @@ static int get_fw(struct if_usb_card *cardp, const char *fwname)
>  	if (fwname)
>  		return request_firmware(&cardp->fw, fwname, &cardp->udev->dev);
>  
> +	/* Handle OLPC firmware */
> +	if (try_olpc_fw(cardp) == 0)
> +		return 0;
> +
>  	/* Otherwise search for firmware to use */
>  	for (i = 0; i < ARRAY_SIZE(fw_table); i++) {
>  		if (fw_table[i].model != cardp->model)


