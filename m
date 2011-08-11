Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1HKIEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:04:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55248 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1HKIDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <1312256727-13906-1-git-send-email-sonic.adi@gmail.com>
References: <1312256727-13906-1-git-send-email-sonic.adi@gmail.com>
Date: Thu, 11 Aug 2011 16:03:52 +0800
Message-ID: <CAJxxZ0Ob6MddPM17B_yhx47ZCCfxa38g0j+bUD4gTbH_GfFhQQ@mail.gmail.com>
Subject: Re: [PATCH v2] serial:bfin_uart: Put TX IRQ in individual platform resource.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Any comments?

Sonic Zhang

On Tue, Aug 2, 2011 at 11:45 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Serial TX IRQ is not RX IRQ plus 1 in some blackfin chips.
> Give individual platform resources to both TX and RX irqs.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/tty/serial/bfin_uart.c |   35 +++++++++++++++++++++--------------
>  1 files changed, 21 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
> index e08bc04..881c6e7 100644
> --- a/drivers/tty/serial/bfin_uart.c
> +++ b/drivers/tty/serial/bfin_uart.c
> @@ -667,17 +667,17 @@ static int bfin_serial_startup(struct uart_port *port)
>                kgdboc_break_enabled = 0;
>        else {
>  # endif
> -       if (request_irq(uart->port.irq, bfin_serial_rx_int, IRQF_DISABLED,
> +       if (request_irq(uart->rx_irq, bfin_serial_rx_int, IRQF_DISABLED,
>             "BFIN_UART_RX", uart)) {
>                printk(KERN_NOTICE "Unable to attach BlackFin UART RX interrupt\n");
>                return -EBUSY;
>        }
>
>        if (request_irq
> -           (uart->port.irq+1, bfin_serial_tx_int, IRQF_DISABLED,
> +           (uart->tx_irq, bfin_serial_tx_int, IRQF_DISABLED,
>             "BFIN_UART_TX", uart)) {
>                printk(KERN_NOTICE "Unable to attach BlackFin UART TX interrupt\n");
> -               free_irq(uart->port.irq, uart);
> +               free_irq(uart->rx_irq, uart);
>                return -EBUSY;
>        }
>
> @@ -692,7 +692,7 @@ static int bfin_serial_startup(struct uart_port *port)
>                 */
>                unsigned uart_dma_ch_rx, uart_dma_ch_tx;
>
> -               switch (uart->port.irq) {
> +               switch (uart->rx_irq) {
>                case IRQ_UART3_RX:
>                        uart_dma_ch_rx = CH_UART3_RX;
>                        uart_dma_ch_tx = CH_UART3_TX;
> @@ -709,16 +709,16 @@ static int bfin_serial_startup(struct uart_port *port)
>                if (uart_dma_ch_rx &&
>                        request_dma(uart_dma_ch_rx, "BFIN_UART_RX") < 0) {
>                        printk(KERN_NOTICE"Fail to attach UART interrupt\n");
> -                       free_irq(uart->port.irq, uart);
> -                       free_irq(uart->port.irq + 1, uart);
> +                       free_irq(uart->rx_irq, uart);
> +                       free_irq(uart->tx_irq, uart);
>                        return -EBUSY;
>                }
>                if (uart_dma_ch_tx &&
>                        request_dma(uart_dma_ch_tx, "BFIN_UART_TX") < 0) {
>                        printk(KERN_NOTICE "Fail to attach UART interrupt\n");
>                        free_dma(uart_dma_ch_rx);
> -                       free_irq(uart->port.irq, uart);
> -                       free_irq(uart->port.irq + 1, uart);
> +                       free_irq(uart->rx_irq, uart);
> +                       free_irq(uart->tx_irq, uart);
>                        return -EBUSY;
>                }
>        }
> @@ -785,8 +785,8 @@ static void bfin_serial_shutdown(struct uart_port *port)
>                break;
>        };
>  #endif
> -       free_irq(uart->port.irq, uart);
> -       free_irq(uart->port.irq+1, uart);
> +       free_irq(uart->rx_irq, uart);
> +       free_irq(uart->tx_irq, uart);
>  #endif
>
>  #ifdef CONFIG_SERIAL_BFIN_CTSRTS
> @@ -1319,14 +1319,21 @@ static int bfin_serial_probe(struct platform_device *pdev)
>                }
>                uart->port.mapbase = res->start;
>
> -               uart->port.irq = platform_get_irq(pdev, 0);
> -               if (uart->port.irq < 0) {
> -                       dev_err(&pdev->dev, "No uart RX/TX IRQ specified\n");
> +               uart->tx_irq = platform_get_irq(pdev, 0);
> +               if (uart->tx_irq < 0) {
> +                       dev_err(&pdev->dev, "No uart TX IRQ specified\n");
>                        ret = -ENOENT;
>                        goto out_error_unmap;
>                }
>
> -               uart->status_irq = platform_get_irq(pdev, 1);
> +               uart->rx_irq = platform_get_irq(pdev, 1);
> +               if (uart->rx_irq < 0) {
> +                       dev_err(&pdev->dev, "No uart RX IRQ specified\n");
> +                       ret = -ENOENT;
> +                       goto out_error_unmap;
> +               }
> +
> +               uart->status_irq = platform_get_irq(pdev, 2);
>                if (uart->status_irq < 0) {
>                        dev_err(&pdev->dev, "No uart status IRQ specified\n");
>                        ret = -ENOENT;
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
