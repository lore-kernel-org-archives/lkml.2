Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab1ILPfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:35:15 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:44140 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab1ILPfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:35:13 -0400
Date: Mon, 12 Sep 2011 12:35:08 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Cc: Breno Leitao <leitao@linux.vnet.ibm.com>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jsm: Fixed EEH recovery error
Message-ID: <20110912153508.GA8851@oc1711230544.ibm.com>
References: <1315834565-9280-1-git-send-email-lucaskt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315834565-9280-1-git-send-email-lucaskt@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 10:36:05AM -0300, Lucas Kannebley Tavares wrote:
> There was an error on the jsm driver that would cause it to be unable to
> recover after a second error is detected.
> 
> At the first error, the device recovers properly:
> 
> [72521.485691] EEH: Detected PCI bus error on device 0003:02:00.0
> [72521.485695] EEH: This PCI device has failed 1 times in the last hour:
> ...
> [72532.035693] ttyn3 at MMIO 0x0 (irq = 49) is a jsm
> [72532.105689] jsm: Port 3 added
> 
> However, at the second error, it cascades until EEH disables the device:
> 
> [72631.229549] Call Trace:
> ...
> [72641.725687] jsm: Port 3 added
> [72641.725695] EEH: Detected PCI bus error on device 0003:02:00.0
> [72641.725698] EEH: This PCI device has failed 3 times in the last hour:
> 
> It was caused because the PCI state was not being saved after the first
> restore. Therefore, at the second recovery the PCI state would not be
> restored.
> 
> Signed-off-by: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

> ---
>  drivers/tty/serial/jsm/jsm_driver.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
> index 96da178..8941b15 100644
> --- a/drivers/tty/serial/jsm/jsm_driver.c
> +++ b/drivers/tty/serial/jsm/jsm_driver.c
> @@ -270,6 +270,7 @@ static void jsm_io_resume(struct pci_dev *pdev)
>  	struct jsm_board *brd = pci_get_drvdata(pdev);
> 
>  	pci_restore_state(pdev);
> +	pci_save_state(pdev);
> 
>  	jsm_uart_port_init(brd);
>  }
> -- 
> 1.7.4.4
> 
