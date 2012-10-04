Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2JDMov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:44:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58118 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2JDMou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:44:50 -0400
Message-ID: <506D84BD.5010000@gmail.com>
Date: Thu, 04 Oct 2012 07:44:45 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial: i.MX: evaluate linux,stdout-path property
References: <1349347191-7406-1-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1349347191-7406-1-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 05:39 AM, Sascha Hauer wrote:
> devicetrees may have the linux,stdout-path property to specify the
> console. This patch adds support to the i.MX serial driver for this.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
> 
> I was originally looking for a more generic way to handle this, but
> since a struct console has no device associated to it, it's not
> possible to match a console with a device in a generic way. So we

Could we add a device ptr to struct console?

> just call add_preferred_console from the driver and let it go down
> to a string matching in the console code.
> If anyone has a better idea how to handle this, please let me know.
> Otherwise I'm happy to see this patch applied aswell.
> 
> Thanks
>  Sascha
> 
>  drivers/tty/serial/imx.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index e309e8b..b52c4a7 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -1397,6 +1397,32 @@ static int serial_imx_resume(struct platform_device *dev)
>  
>  #ifdef CONFIG_OF
>  /*
> + * Check if this device matches the linux,stdout-path property
> + * in the chosen node. return true if yes, false otherwise
> + */
> +static int serial_imx_is_stdoutpath(struct platform_device *pdev)

Couldn't this function be generic? Just move
IS_ENABLED(CONFIG_SERIAL_IMX_CONSOLE) outside this function. Arguably,
the presence of the property or not could replace the config option all
together.

And use a struct device so this can work with devices other than
platform devices (i.e. amba).

Rob

> +{
> +	struct device_node *dn;
> +	const char *name;
> +
> +	if (!IS_ENABLED(CONFIG_SERIAL_IMX_CONSOLE))
> +		return 0;
> +
> +	name = of_get_property(of_chosen, "linux,stdout-path", NULL);
> +	if (name == NULL)
> +		return 0;
> +
> +	dn = of_find_node_by_path(name);
> +	if (!dn)
> +		return 0;
> +
> +	if (dn == pdev->dev.of_node)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/*
>   * This function returns 1 iff pdev isn't a device instatiated by dt, 0 iff it
>   * could successfully get all information from dt or a negative errno.
>   */
> @@ -1427,6 +1453,9 @@ static int serial_imx_probe_dt(struct imx_port *sport,
>  
>  	sport->devdata = of_id->data;
>  
> +	if (serial_imx_is_stdoutpath(pdev))
> +		add_preferred_console(imx_reg.cons->name, sport->port.line, 0);
> +
>  	return 0;
>  }
>  #else
> 

