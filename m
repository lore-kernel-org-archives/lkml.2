Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0J0K4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:56:18 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:55940 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab0J0K4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:56:15 -0400
Message-ID: <4CC804FF.9050908@ge.com>
Date: Wed, 27 Oct 2010 11:54:55 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 09/30] staging/vme: fill in struct device's .release,
 even if it's a NOOP
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-10-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-10-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 10:56:13.0612 (UTC) FILETIME=[9271A6C0:01CB75C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:10, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> Without it we get 32 warnings, one per device being released, when
> removing a bridge module.
> 
> After applying this patch, bridge modules can at last be removed
> without any apparent hiccup.
> 
> [Note: tested only on the tsi148, it's the only bridge I've got]
> 

I guess this is an artifact of the current lack of refcounting?

This is definitely an issue, however I don't think masking it by adding
an empty function is the correct way to go.

Martyn

> Signed-off-by: Emilio G. Cota <cota@braap.org>
> ---
>  drivers/staging/vme/vme.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index afd2dbd..59650dd 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1352,6 +1352,11 @@ static void vme_free_bus_num(int bus)
>  	mutex_unlock(&vme_bus_num_mtx);
>  }
>  
> +/* Note: device_release(dev) throws a warning if dev->release isn't filled in */
> +static void vme_dev_release(struct device *dev)
> +{
> +}
> +
>  int vme_register_bridge(struct vme_bridge *bridge)
>  {
>  	struct device *dev;
> @@ -1372,6 +1377,7 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  
>  		dev->parent = bridge->parent;
>  		dev->bus = &vme_bus_type;
> +		dev->release = vme_dev_release;
>  		/*
>  		 * We save a pointer to the bridge in platform_data so that we
>  		 * can get to it later. We keep driver_data for use by the


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
