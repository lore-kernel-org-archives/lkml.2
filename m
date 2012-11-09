Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab2KIIQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:16:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2KIIQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:16:02 -0500
MIME-Version: 1.0
In-Reply-To: <1352464110.15558.1620.camel@cliu38-desktop-build>
References: <1352464110.15558.1620.camel@cliu38-desktop-build>
Date: Fri, 9 Nov 2012 16:16:00 +0800
Message-ID: <CACVXFVN7RVzQB5X8h=XazQm+vwwwKzGyAm5jNhiYbdqTJeR_TQ@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: Fix the concurrent request_firmware()
 race for kref_get/put
From: Ming Lei <ming.lei@canonical.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 8:28 PM, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
>
> There is one race that both request_firmware() with the same
> firmware name.
>
> The race scenerio is as below:
> CPU1                                                  CPU2
> request_firmware() -->
> _request_firmware_load() return err                   another request_firmware() is coming -->
> _request_firmware_cleanup is called -->               _request_firmware_prepare -->
> release_firmware --->                                 fw_lookup_and_allocate_buf -->
>                                                       spin_lock(&fwc->lock)
> ...                                                   __fw_lookup_buf() return true
> fw_free_buf() will be called -->                      ...
> kref_put -->
> decrease the refcount to 0
>                                                       kref_get(&tmp->ref) ==> it will trigger warning
>                                                                               due to refcount == 0
> __fw_free_buf() -->
> ...                                                   spin_unlock(&fwc->lock)
> spin_lock(&fwc->lock)
> list_del(&buf->list)
> spin_unlock(&fwc->lock)
> kfree(buf)
>                                                       After that, the freed buf will be used.
>
> The key race is decreasing refcount to 0 and list_del is not protected together by
> fwc->lock, and it is possible another thread try to get it between refcount==0
> and list_del.
>
> Fix it here to protect it together.

Good catch, the reference count and the list operation should be atomic.

>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/base/firmware_class.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index b44ed35..7df32cd 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -246,7 +246,6 @@ static void __fw_free_buf(struct kref *ref)
>                  __func__, buf->fw_id, buf, buf->data,
>                  (unsigned int)buf->size);
>
> -       spin_lock(&fwc->lock);
>         list_del(&buf->list);
>         spin_unlock(&fwc->lock);
>
> @@ -263,7 +262,10 @@ static void __fw_free_buf(struct kref *ref)
>
>  static void fw_free_buf(struct firmware_buf *buf)
>  {
> -       kref_put(&buf->ref, __fw_free_buf);
> +       struct firmware_cache *fwc = buf->fwc;
> +       spin_lock(&fwc->lock);
> +       if(!kref_put(&buf->ref, __fw_free_buf))

$./scripts/checkpatch.pl
ERROR: space required before the open parenthesis '('
#97: FILE: drivers/base/firmware_class.c:267:
+	if(!kref_put(&buf->ref, __fw_free_buf))


> +               spin_unlock(&fwc->lock);
>  }
>
>  /* direct firmware loading support */

After fixing the patch style error, you can add my ack:

Acked-by: Ming Lei <ming.lei@canonical.com>


Thanks,
---
Ming Lei
