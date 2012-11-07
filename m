Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2KGKjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:39:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52066 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2KGKjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <1352306744.15558.1608.camel@cliu38-desktop-build>
References: <1352306744.15558.1608.camel@cliu38-desktop-build>
Date: Wed, 7 Nov 2012 18:39:45 +0800
Message-ID: <CACVXFVOtbY8FX1GTsBR4R0W_R8UjHjjmGTTcKfqvNY5tX7h6OQ@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: Fix the race FW_STATUS_DONE is followed
 by class_timeout
From: Ming Lei <ming.lei@canonical.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 12:45 AM, Chuansheng Liu
<chuansheng.liu@intel.com> wrote:
>
> There is a race condition as below when calling request_firmware():
>
> CPU1                                    CPU2
> write 0 > loading
> mutex_lock(&fw_lock);
> ...
> set_bit FW_STATUS_DONE                  class_timeout is coming
>                                         set_bit FW_STATUS_ABORT
> complete_all &completion
> ...
> mutex_unlock(&fw_lock)

Good catch, but your fix isn't correct.

>
> In this time, the bit FW_STATUS_DONE and FW_STATUS_ABORT are set,
> and request_firmware() will return failure due to condition in
> _request_firmware_load():
>
>         if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
>                 retval = -ENOENT;
>
> But from the above scenerio, it should be a succcessful requesting.
> So we need judge if the FW_STATUS_DONE is set before calling abort
> in timeout function firmware_class_timeout().
>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/base/firmware_class.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 8945f4e..35fffd8 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -671,6 +671,13 @@ static void firmware_class_timeout(u_long data)
>  {
>         struct firmware_priv *fw_priv = (struct firmware_priv *) data;
>
> +       mutex_lock(&fw_lock);

mutex can't be used in interrupt context, so one candidate fix is
to convert the timeout timer into delayed work, and hold the
'fw_lock' during the work function.

> +       if (test_bit(FW_STATUS_DONE, &(fw_priv->buf->status))) {
> +               mutex_unlock(&fw_lock);
> +               return;
> +       }
> +       mutex_unlock(&fw_lock);
> +
>         fw_load_abort(fw_priv);
>  }

Also the lock of 'fw_lock' should be held when setting 'FW_STATUS_DONE'
in _request_firmware_load().

Could you send out a new patch to fix the race?

Thanks,
--
Ming Lei
