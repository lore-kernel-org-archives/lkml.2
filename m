Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1HYQyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:54:39 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:54844 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1HYQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:54:37 -0400
Message-ID: <4E567E41.90605@linux.vnet.ibm.com>
Date: Thu, 25 Aug 2011 13:54:25 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
CC: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jsm: remove remaining flip buffer code
References: <1314202043-12039-1-git-send-email-cascardo@linux.vnet.ibm.com>
In-Reply-To: <1314202043-12039-1-git-send-email-cascardo@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 11082516-2362-0000-0000-0000049D0930
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Thadeu. The patches are fine. Please, update the driver version 
due these modifications.

On 08/24/2011 01:07 PM, Thadeu Lima de Souza Cascardo wrote:
> The flip buffer is not used anymore. Remove its allocation and
> declaration in the board structure.
>
> Signed-off-by: Thadeu Lima de Souza Cascardo<cascardo@linux.vnet.ibm.com>
> ---
>   drivers/tty/serial/jsm/jsm.h        |    3 ---
>   drivers/tty/serial/jsm/jsm_driver.c |   18 ------------------
>   2 files changed, 0 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/tty/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
> index b704c8c..cd53bdd 100644
> --- a/drivers/tty/serial/jsm/jsm.h
> +++ b/drivers/tty/serial/jsm/jsm.h
> @@ -88,7 +88,6 @@ enum {
>
>   /* 4 extra for alignment play space */
>   #define WRITEBUFLEN	((4096) + 4)
> -#define MYFLIPLEN	N_TTY_BUF_SIZE
>
>   #define JSM_VERSION	"jsm: 1.2-1-INKERNEL"
>   #define JSM_PARTNUM	"40002438_A-INKERNEL"
> @@ -150,7 +149,6 @@ struct jsm_board
>   	u32		bd_uart_offset;	/* Space between each UART */
>
>   	struct jsm_channel *channels[MAXPORTS]; /* array of pointers to our channels. */
> -	char		*flipbuf;	/* Our flip buffer, alloced if board is found */
>
>   	u32		bd_dividend;	/* Board/UARTs specific dividend */
>
> @@ -177,7 +175,6 @@ struct jsm_board
>   #define CH_TX_FIFO_LWM	0x0800		/* TX Fifo is below Low Water	*/
>   #define CH_BREAK_SENDING 0x1000		/* Break is being sent		*/
>   #define CH_LOOPBACK 0x2000		/* Channel is in lookback mode	*/
> -#define CH_FLIPBUF_IN_USE 0x4000	/* Channel's flipbuf is in use	*/
>   #define CH_BAUD0	0x08000		/* Used for checking B0 transitions */
>
>   /* Our Read/Error/Write queue sizes */
> diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
> index 96da178..1cc8cf6 100644
> --- a/drivers/tty/serial/jsm/jsm_driver.c
> +++ b/drivers/tty/serial/jsm/jsm_driver.c
> @@ -160,27 +160,10 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
>   	dev_info(&pdev->dev, "board %d: Digi Neo (rev %d), irq %d\n",
>   			adapter_count, brd->rev, brd->irq);
>
> -	/*
> -	 * allocate flip buffer for board.
> -	 *
> -	 * Okay to malloc with GFP_KERNEL, we are not at interrupt
> -	 * context, and there are no locks held.
> -	 */
> -	brd->flipbuf = kzalloc(MYFLIPLEN, GFP_KERNEL);
> -	if (!brd->flipbuf) {
> -		/* XXX: leaking all resources from jsm_tty_init and
> -		 	jsm_uart_port_init here! */
> -		dev_err(&pdev->dev, "memory allocation for flipbuf failed\n");
> -		rc = -ENOMEM;
> -		goto out_free_uart;
> -	}
> -
>   	pci_set_drvdata(pdev, brd);
>   	pci_save_state(pdev);
>
>   	return 0;
> - out_free_uart:
> -	jsm_remove_uart_port(brd);
>    out_free_irq:
>   	jsm_remove_uart_port(brd);
>   	free_irq(brd->irq, brd);
> @@ -218,7 +201,6 @@ static void __devexit jsm_remove_one(struct pci_dev *pdev)
>
>   	pci_release_regions(pdev);
>   	pci_disable_device(pdev);
> -	kfree(brd->flipbuf);
>   	kfree(brd);
>   }
>


-- 
Breno Leitão
Advisory Software Engineer
Linux Technology Center
Phone: +55 16 8115-3915
E-Mail: brenohl@br.ibm.com

