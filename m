Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2ITKIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:08:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37333 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab2ITKIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:08:43 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.118.250]
In-Reply-To: <1348072769-17314-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1348072769-17314-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 20 Sep 2012 13:08:20 +0300
Message-ID: <CAK=WgbYt1mtDSyTQzOxO+mcp320A3MQrgXuL=AY7h9FixSg=hg@mail.gmail.com>
Subject: Re: [PATCHv3] remoteproc: Add STE modem driver for remoteproc
To: sjur.brandeland@stericsson.com
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, Sep 19, 2012 at 7:39 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Add support for the STE modem shared memory driver.
> This driver hooks into the remoteproc framework
> in order to manage configuration and the virtio
> devices.
>
> This driver adds custom firmware handlers, because
> STE modem uses a custom firmware layout.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> cc: Linus Walleij <linus.walleij@linaro.org>
> cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
> Changes since v3:

Looks good, thanks.

I have just one comment/question:

> +/* STE modem device is unregistered */
> +static int sproc_drv_remove(struct platform_device *pdev)
> +{
> +       struct ste_modem_device *mdev =
> +               container_of(pdev, struct ste_modem_device, pdev);
> +       struct sproc *sproc = mdev->drv_data;
> +
> +       sproc_dbg(sproc, "remove ste-modem\n");
> +
> +       /* Unregister as remoteproc device */
> +       rproc_del(sproc->rproc);
> +       rproc_put(sproc->rproc);
> +
> +       mdev->drv_data = NULL;
> +       mdev->drv_ops = NULL;
> +       return 0;
> +}
> +
> +struct ste_modem_drv_ops sproc_drv_ops = {
> +       .kick = sproc_kick_callback
> +};
> +
> +/* Handle probe of a modem device */
> +static int sproc_probe(struct platform_device *pdev)
> +{
...
> +       mdev->drv_data = sproc;
> +
> +       /* Provide callbacks to modem device */
> +       mdev->drv_ops = &sproc_drv_ops;

Implicitly providing the modem with drv_ops and drv_data in this
manner feels racy and somewhat error prone.

E.g., on remove these members are set to NULL, under the assumption
that the modem won't invoke sproc_kick_callback or access sproc
anymore, but this doesn't feel safe.

Any chance you can add an explicit registration method to
ste_modem_dev_ops, with which you'll be able to explicitly set/unset
sproc_kick_callback and sproc ?

Thanks,
Ohad.
