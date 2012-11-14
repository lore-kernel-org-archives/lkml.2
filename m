Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab2KNCrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:47:55 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65149 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2KNCrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:47:53 -0500
MIME-Version: 1.0
In-Reply-To: <1352675000-29627-1-git-send-email-jon.mason@intel.com>
References: <1352675000-29627-1-git-send-email-jon.mason@intel.com>
Date: Wed, 14 Nov 2012 08:17:53 +0530
X-Google-Sender-Auth: UyQ81G6jF9NcTeb6nMyNF-lE9QA
Message-ID: <CAOh2x=niXPCeg1dWtmjDjms_8ndYD7pzGY37k36e8=D8Km7gqQ@mail.gmail.com>
Subject: Re: [PATCH v2] dmatest: Fix NULL pointer dereference on ioat
From: viresh kumar <viresh.kumar@linaro.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 4:33 AM, Jon Mason <jon.mason@intel.com> wrote:
> device_control is an optional and not implemented in all DMA drivers.
> Any calls to these will result in a NULL pointer dereference.  dmatest
> makes two of these calls when completing the kernel thread and removing
> the module.  These are corrected by calling the dmaengine_device_control
> wrapper and checking for a non-existant device_control function pointer
> there.
>
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> CC: Vinod Koul <vinod.koul@intel.com>
> CC: Dan Williams <djbw@fb.com>
> ---
>  drivers/dma/dmatest.c     |    4 ++--
>  include/linux/dmaengine.h |    5 ++++-
>  2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 24225f0..6ef9465 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -499,7 +499,7 @@ err_srcs:
>                         thread_name, total_tests, failed_tests, ret);
>
>         /* terminate all transfers on specified channels */
> -       chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
> +       dmaengine_terminate_all(chan);
>         if (iterations > 0)
>                 while (!kthread_should_stop()) {
>                         DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
> @@ -524,7 +524,7 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
>         }
>
>         /* terminate all transfers on specified channels */
> -       dtc->chan->device->device_control(dtc->chan, DMA_TERMINATE_ALL, 0);
> +       dmaengine_terminate_all(dtc->chan);
>
>         kfree(dtc);
>  }
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index d3201e4..cf94e5f 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -608,7 +608,10 @@ static inline int dmaengine_device_control(struct dma_chan *chan,
>                                            enum dma_ctrl_cmd cmd,
>                                            unsigned long arg)
>  {
> -       return chan->device->device_control(chan, cmd, arg);
> +       if (chan->device->device_control)
> +               return chan->device->device_control(chan, cmd, arg);
> +       else
> +               return -ENOSYS;
>  }

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
