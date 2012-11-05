Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab2KEQNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:13:00 -0500
Received: from mxout1.idt.com ([157.165.5.25]:38195 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab2KEQMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:12:54 -0500
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Xiaotian Feng <xtfeng@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Xiaotian Feng <dannyfeng@tencent.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCH] rapidio/tsi721: use tasklet_kill in device
 remove/release process
Thread-Topic: [PATCH] rapidio/tsi721: use tasklet_kill in device
 remove/release process
Thread-Index: AQHNt1oyKBA0kBHm8UKtHzr2wNWnqJfbbmDA
Date: Mon, 5 Nov 2012 16:11:40 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BC03AFB@corpmail1.na.ads.idt.com>
References: <1351680769-27306-1-git-send-email-xtfeng@gmail.com>
In-Reply-To: <1351680769-27306-1-git-send-email-xtfeng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, October 31, 2012 6:53 AM
Xiaotian Feng <xtfeng@gmail.com> wrote:
> 
> Some driver uses tasklet_disable in device remove/release process,
> tasklet_disable will inc tasklet->count and return. If the tasklet
> is not handled yet under some softirq pressure, the tasklet will be
> placed on the tasklet_vec, never have a chance to be excuted. This
> might
> lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, but
> tasklet is disabled. tasklet_kill should be used in this case.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/rapidio/devices/tsi721_dma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rapidio/devices/tsi721_dma.c
> b/drivers/rapidio/devices/tsi721_dma.c
> index 92e06a5..a098fbc 100644
> --- a/drivers/rapidio/devices/tsi721_dma.c
> +++ b/drivers/rapidio/devices/tsi721_dma.c
> @@ -589,7 +589,7 @@ static void tsi721_free_chan_resources(struct
> dma_chan *dchan)
>  	BUG_ON(!list_empty(&bdma_chan->active_list));
>  	BUG_ON(!list_empty(&bdma_chan->queue));
> 
> -	tasklet_disable(&bdma_chan->tasklet);
> +	tasklet_kill(&bdma_chan->tasklet);
> 
>  	spin_lock_bh(&bdma_chan->lock);
>  	list_splice_init(&bdma_chan->free_list, &list);
> --
> 1.7.9.5

I agree with reported issue.
Switching to tasklet_kill() also requires to disable interrupts first.
I will update that part and post a new patch.

    
