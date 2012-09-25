Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2IYIWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:22:09 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:37738 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679Ab2IYIWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
Date: Tue, 25 Sep 2012 13:52:03 +0530
Message-ID: <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not suspended.
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, tony@atomide.com, khilman@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, balbi@ti.com, paul@pwsan.com,
        Sourav Poddar <sourav.poddar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Ping on this?

On Tue, Sep 18, 2012 at 6:10 PM, Sourav Poddar <sourav.poddar@ti.com> wrote:
> Greg's tty-next is not booting on 2420 based N800. The failure is
> observed at serial init itself. The reason might be that n800 tries to
> resume even though it is not suspended before.
>
> Reported-by: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
> This patch is developed on top of greg's tty-next branch
> CommitId: e740d8f tty: serial: Samsung: Fix return value +
> the following patch which I have already posted to the mailing list.
> http://comments.gmane.org/gmane.linux.ports.arm.omap/84729
>
>  drivers/tty/serial/omap-serial.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 3c05c5e..bc355f2 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -110,6 +110,7 @@ struct uart_omap_port {
>         u32                     calc_latency;
>         struct work_struct      qos_work;
>         struct pinctrl          *pins;
> +       unsigned int            suspended:1;
>  };
>
>  #define to_uart_omap_port(p)   ((container_of((p), struct uart_omap_port, port)))
> @@ -1545,14 +1546,20 @@ static int serial_omap_runtime_suspend(struct device *dev)
>         up->latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
>         schedule_work(&up->qos_work);
>
> +       up->suspended = true;
> +
>         return 0;
>  }
>
>  static int serial_omap_runtime_resume(struct device *dev)
>  {
>         struct uart_omap_port *up = dev_get_drvdata(dev);
> +       u32 loss_cnt;
> +
> +       if (!up->suspended)
> +               return 0;
>
> -       u32 loss_cnt = serial_omap_get_context_loss_count(up);
> +       loss_cnt = serial_omap_get_context_loss_count(up);
>
>         if (up->context_loss_cnt != loss_cnt)
>                 serial_omap_restore_context(up);
> @@ -1560,6 +1567,8 @@ static int serial_omap_runtime_resume(struct device *dev)
>         up->latency = up->calc_latency;
>         schedule_work(&up->qos_work);
>
> +       up->suspended = false;
> +
>         return 0;
>  }
>  #endif
> --
> 1.7.1
>

~Sourav
