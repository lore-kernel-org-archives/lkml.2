Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2KVSaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:30:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:3207 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab2KVSaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:30:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="223035333"
Date: Thu, 22 Nov 2012 11:06:40 +0000
From: Alan Cox <alan@linux.intel.com>
To: chao bi <chao.bi@intel.com>
Cc: richardx.r.gorby@intel.com, jun.d.chen@intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial:ifx6x60:Delete SPI timer when shut down port
Message-ID: <20121122110640.3fd5ef9b@bob.linux.org.uk>
In-Reply-To: <1353573787.22077.8.camel@bichao>
References: <1353573787.22077.8.camel@bichao>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 16:43:07 +0800
chao bi <chao.bi@intel.com> wrote:

> 
> When shut down SPI port, it's possible that MRDY has been asserted
> and a SPI timer was activated waiting for SRDY assert, in the case,
> it needs to delete this timer.
> 
> Signed-off-by: Chen Jun <jun.d.chen@intel.com>
> Signed-off-by: channing <chao.bi@intel.com>
> ---
>  drivers/tty/serial/ifx6x60.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/ifx6x60.c
> b/drivers/tty/serial/ifx6x60.c index 5b9bc19..467020b 100644
> --- a/drivers/tty/serial/ifx6x60.c
> +++ b/drivers/tty/serial/ifx6x60.c
> @@ -552,7 +552,10 @@ static void ifx_port_shutdown(struct tty_port
> *port) container_of(port, struct ifx_spi_device, tty_port);
>  
>  	mrdy_set_low(ifx_dev);
> -	clear_bit(IFX_SPI_STATE_TIMER_PENDING, &ifx_dev->flags);
> +	if (test_and_clear_bit(IFX_SPI_STATE_TIMER_PENDING,
> +		&ifx_dev->flags)) {
> +		del_timer(&ifx_dev->spi_timer);
> +	}

You don't actually need the test here as far as I can see. Providing a
timer has been initialised (init_timer) then running del_timer is safe
even if the timer is not currently queued or has completed.

Alan
