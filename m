Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2FKHPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:15:50 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55086 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2FKHPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:15:48 -0400
Date: Mon, 11 Jun 2012 09:17:13 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm via: initialize object_idr
Message-ID: <20120611071713.GA4695@phenom.ffwll.local>
Mail-Followup-To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <4FD5142B.2080809@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FD5142B.2080809@freemail.hu>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 11:39:55PM +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The field obejct_idr of struct drm_via_private was introduced with the
> commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=77ee8f3825054f23b17e9c8f728f061defd86cdc .
> In that patch idr_init(&dev->object_name_idr) was called instead of
> idr_init(&dev_priv->object_idr) by mistake, leaving the dev_priv->object_idr
> uninitialized. To be more exact, the object_idr buffer is filled with zeros
> because of kzalloc(), but the dev_priv->object_idr.lock spinlock can cause
> system freeze at lib/idr.c:move_to_free_list() when spin_lock_irqsave()
> is called on this spinlock.
> 
> The patch was tested on Clevo D4J, model D410J laptop, on the following
> hardware, without AGP kernel module loaded:
> 
>   # lspci -s 01:00.0 -n
>   01:00.0 0300: 1106:3108 (rev 01)
>   # lspci -s 01:00.0 -v
>   01:00.0 VGA compatible controller: VIA Technologies, Inc. K8M800/K8N800/K8N800A [S3 UniChrome Pro] (rev 01) (prog-if 00 [VGA controller])
>           Subsystem: CLEVO/KAPOK Computer Device 4702
>           Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
>           Memory at f0000000 (32-bit, prefetchable) [size=64M]
>           Memory at d1000000 (32-bit, non-prefetchable) [size=16M]
>           Expansion ROM at <unassigned> [disabled]
>           Capabilities: [60] Power Management version 2
>           Capabilities: [70] AGP version 3.0
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Meh, I fail, thanks for catching this. Although the drm/sis driver has the
same problem, care to write that patch, too? In any case:

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: stable@vger.kernel.org

-Daniel

> ---
> diff --git a/drivers/gpu/drm/via/via_map.c b/drivers/gpu/drm/via/via_map.c
> index 1f18225..c126182 100644
> --- a/drivers/gpu/drm/via/via_map.c
> +++ b/drivers/gpu/drm/via/via_map.c
> @@ -100,12 +100,11 @@ int via_driver_load(struct drm_device *dev, unsigned long chipset)
>  	if (dev_priv == NULL)
>  		return -ENOMEM;
> 
> +	idr_init(&dev_priv->object_idr);
>  	dev->dev_private = (void *)dev_priv;
> 
>  	dev_priv->chipset = chipset;
> 
> -	idr_init(&dev->object_name_idr);
> -
>  	pci_set_master(dev->pdev);
> 
>  	ret = drm_vblank_init(dev, 1);

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
