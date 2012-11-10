Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2KJDaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 22:30:19 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54066 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KJDaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 22:30:16 -0500
MIME-Version: 1.0
In-Reply-To: <1352494660-6650-1-git-send-email-jon.mason@intel.com>
References: <1352494660-6650-1-git-send-email-jon.mason@intel.com>
Date: Sat, 10 Nov 2012 09:00:15 +0530
X-Google-Sender-Auth: wUrDevKSjWZV8Cvnc7Ugh5g75AY
Message-ID: <CAOh2x=mE8d1YtRy_Efqbtc+24SCgEYuKwVpFHrFZBTpt2CB08w@mail.gmail.com>
Subject: Re: [PATCH] dmatest: Fix NULL pointer dereference on ioat
From: viresh kumar <viresh.kumar@linaro.org>
To: Jon Mason <jon.mason@intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 2:27 AM, Jon Mason <jon.mason@intel.com> wrote:
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

> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index d3201e4..e0004fb 100644
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
> +               return -EINVAL;

-ENOTSUPP or -ENOSYS ??

@Dan: I believe i don't have to send another version now. Correct??

--
viresh
