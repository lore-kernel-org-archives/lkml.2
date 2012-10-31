Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422783Ab2JaLYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:24:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54919 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422769Ab2JaLYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <1351680060-27151-1-git-send-email-xtfeng@gmail.com>
References: <1351680060-27151-1-git-send-email-xtfeng@gmail.com>
Date: Wed, 31 Oct 2012 19:24:32 +0800
Message-ID: <CAJn8CcHJHQ60v1sfhXXok50K2f5fiWQmUcCoScX-gZuSaTjfXQ@mail.gmail.com>
Subject: Re: [PATCH] dma: ioat: use tasklet_kill in device remove/release process
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 6:41 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> Some driver uses tasklet_disable in device remove/release process,
> tasklet_disable will inc tasklet->count and return. If the tasklet
> is not handled yet under some softirq pressure, the tasklet will be
> placed on the tasklet_vec, never have a chance to be excuted. This might
> lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, but
> tasklet is disabled. tasklet_kill should be used in this case.
>
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>

Please ignore this one, I made a mistake here.

> ---
>  drivers/dma/ioat/dma.c    |    2 +-
>  drivers/dma/ioat/dma_v2.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
> index 73b2b65..8bec4a2 100644
> --- a/drivers/dma/ioat/dma.c
> +++ b/drivers/dma/ioat/dma.c
> @@ -379,7 +379,7 @@ static void ioat1_dma_free_chan_resources(struct dma_chan *c)
>         if (ioat->desccount == 0)
>                 return;
>
> -       tasklet_disable(&chan->cleanup_task);
> +       tasklet_kill(&chan->cleanup_task);
>         del_timer_sync(&chan->timer);
>         ioat1_cleanup(ioat);
>
> diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
> index b9d6678..df3ccb0 100644
> --- a/drivers/dma/ioat/dma_v2.c
> +++ b/drivers/dma/ioat/dma_v2.c
> @@ -794,7 +794,7 @@ void ioat2_free_chan_resources(struct dma_chan *c)
>         if (!ioat->ring)
>                 return;
>
> -       tasklet_disable(&chan->cleanup_task);
> +       tasklet_kill(&chan->cleanup_task);
>         del_timer_sync(&chan->timer);
>         device->cleanup_fn((unsigned long) c);
>         device->reset_hw(chan);
> --
> 1.7.9.5
>
