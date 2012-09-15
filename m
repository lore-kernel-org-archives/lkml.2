Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2IOPv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 11:51:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61405 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab2IOPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 11:51:55 -0400
Message-ID: <5054A456.80606@gmail.com>
Date: Sat, 15 Sep 2012 17:52:54 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        linux-serial@vger.kernel.org, Colin Cross <ccross@android.com>,
        kgdb-bugreport@lists.sourceforge.net, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/11] tty/serial: Add kgdb_nmi driver
References: <20120913150133.GA16238@lizard> <1347548615-18227-7-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1347548615-18227-7-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 05:03 PM, Anton Vorontsov wrote:
...
> +static int kgdb_nmi_tty_install(struct tty_driver *drv, struct tty_struct *tty)
> +{
> +	struct kgdb_nmi_tty_priv *priv;
> +	int ret;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	INIT_KFIFO(priv->fifo);
> +	tasklet_init(&priv->tlet, kgdb_nmi_tty_receiver, (unsigned long)priv);
> +	tty_port_init(&priv->port);
> +	priv->port.ops = &kgdb_nmi_tty_port_ops;
> +	tty->driver_data = priv;
> +
> +	ret = tty_port_install(&priv->port, drv, tty);
> +	if (ret) {
> +		pr_err("%s: can't nstall tty port: %d\n", __func__, ret);

s/nstall/install

...
> diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
> index 2b42a01..ed97cfd 100644
> --- a/drivers/tty/serial/kgdboc.c
> +++ b/drivers/tty/serial/kgdboc.c
> @@ -145,6 +145,8 @@ __setup("kgdboc=", kgdboc_option_setup);
>  
>  static void cleanup_kgdboc(void)
>  {
> +	if (kgdb_unregister_nmi_console())
> +		return;
>  	kgdboc_unregister_kbd();
>  	if (configured == 1)
>  		kgdb_unregister_io_module(&kgdboc_io_ops);
> @@ -198,6 +200,10 @@ do_register:
>  	if (err)
>  		goto noconfig;
>  
> +	err = kgdb_register_nmi_console();
> +	if (err)
> +		goto noconfig;

If kgdb_register_nmi_console() fails, kgdb_unregister_io_module() must
be called for proper cleanup

--
Francesco
