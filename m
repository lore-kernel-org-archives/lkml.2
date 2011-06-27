Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1F0TFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:05:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43125 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1F0TDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 15:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110627185505.19423.64214.stgit@ponder>
References: <20110627185505.19423.64214.stgit@ponder>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 27 Jun 2011 13:02:45 -0600
X-Google-Sender-Auth: dtljhSDAQNvRVr1qdTJpQKTB1Yk
Message-ID: <BANLkTi=6zxPUwGZ5JHhRGRHHaEgvNgiaHQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: Allow i2c_add_numbered_adapter() to assign a bus id.
To: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Bonesio <bones@secretlab.ca>, Stephen Warren <SWarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 12:55 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> Currently, if an i2c bus driver supports both static and dynamic bus
> ids, it needs to choose between calling i2c_add_numbered_adapter() and
> i2c_add_adapter().  This patch makes i2c_add_numbered_adapter()
> redirect to i2c_add_adapter() if the requested bus id is -1.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Oops, forgot to edit the email before sending the patch.

This patch is as-yet untested other than build testing, but I want to
get feedback.  With the move to DT on ARM, there are going to be a lot
more i2c bus drivers that need to support both static and dynamically
allocated busses, and it is very likely that it will be needed in the
v3.1 merge window.

Ben/Jean, *IF* this patch tests out okay, and *IF* I get an ack from
you, it will probably need to have this commit in my devicetree/next
branch.  If so, then I'll either need to commit it myself, or have it
put into a separate topic branch that both of us can merge into our
trees.  What is your preference.

John: this is the patch that I asked you to write earlier today, but I
think one of the TI folks will run into the same issue, so I wanted to
get it drafted and onto the list ASAP.

g.

> ---
>  drivers/i2c/busses/i2c-cpm.c   |    7 ++-----
>  drivers/i2c/busses/i2c-pxa.c   |    7 ++-----
>  drivers/i2c/busses/i2c-s6000.c |    5 +----
>  drivers/i2c/i2c-core.c         |    5 +++++
>  4 files changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
> index 3a20961..b1d9cd2 100644
> --- a/drivers/i2c/busses/i2c-cpm.c
> +++ b/drivers/i2c/busses/i2c-cpm.c
> @@ -662,11 +662,8 @@ static int __devinit cpm_i2c_probe(struct platform_device *ofdev)
>        /* register new adapter to i2c module... */
>
>        data = of_get_property(ofdev->dev.of_node, "linux,i2c-index", &len);
> -       if (data && len == 4) {
> -               cpm->adap.nr = *data;
> -               result = i2c_add_numbered_adapter(&cpm->adap);
> -       } else
> -               result = i2c_add_adapter(&cpm->adap);
> +       cpm->adap.nr = (data && len == 4) ? be32_to_cpup(data) : -1;
> +       result = i2c_add_numbered_adapter(&cpm->adap);
>
>        if (result < 0) {
>                dev_err(&ofdev->dev, "Unable to register with I2C\n");
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index f59224a..d603646 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1079,7 +1079,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
>         * The reason to do so is to avoid sysfs names that only make
>         * sense when there are multiple adapters.
>         */
> -       i2c->adap.nr = dev->id != -1 ? dev->id : 0;
> +       i2c->adap.nr = dev->id;
>        snprintf(i2c->adap.name, sizeof(i2c->adap.name), "pxa_i2c-i2c.%u",
>                 i2c->adap.nr);
>
> @@ -1142,10 +1142,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
>        i2c->adap.dev.of_node = dev->dev.of_node;
>  #endif
>
> -       if (i2c_type == REGS_CE4100)
> -               ret = i2c_add_adapter(&i2c->adap);
> -       else
> -               ret = i2c_add_numbered_adapter(&i2c->adap);
> +       ret = i2c_add_numbered_adapter(&i2c->adap);
>        if (ret < 0) {
>                printk(KERN_INFO "I2C: Failed to add bus\n");
>                goto eadapt;
> diff --git a/drivers/i2c/busses/i2c-s6000.c b/drivers/i2c/busses/i2c-s6000.c
> index cb5d01e..c64ba73 100644
> --- a/drivers/i2c/busses/i2c-s6000.c
> +++ b/drivers/i2c/busses/i2c-s6000.c
> @@ -341,10 +341,7 @@ static int __devinit s6i2c_probe(struct platform_device *dev)
>        i2c_wr16(iface, S6_I2C_TXTL, 0);
>
>        platform_set_drvdata(dev, iface);
> -       if (bus_num < 0)
> -               rc = i2c_add_adapter(p_adap);
> -       else
> -               rc = i2c_add_numbered_adapter(p_adap);
> +       rc = i2c_add_numbered_adapter(p_adap);
>        if (rc)
>                goto err_irq_free;
>        return 0;
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 9a58994..131079a 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -925,6 +925,9 @@ EXPORT_SYMBOL(i2c_add_adapter);
>  * or otherwise built in to the system's mainboard, and where i2c_board_info
>  * is used to properly configure I2C devices.
>  *
> + * If the requested bus number is set to -1, then this function will behave
> + * identically to i2c_add_adapter, and will dynamically assign a bus number.
> + *
>  * If no devices have pre-been declared for this bus, then be sure to
>  * register the adapter before any dynamically allocated ones.  Otherwise
>  * the required bus ID may not be available.
> @@ -940,6 +943,8 @@ int i2c_add_numbered_adapter(struct i2c_adapter *adap)
>        int     id;
>        int     status;
>
> +       if (adap->nr == -1) /* -1 means dynamically assign bus id */
> +               return i2c_add_adapter(adap);
>        if (adap->nr & ~MAX_ID_MASK)
>                return -EINVAL;
>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
