Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab1HPIQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 04:16:48 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:38231 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1HPIQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 04:16:44 -0400
Message-ID: <4E4A2768.7090503@ge.com>
Date: Tue, 16 Aug 2011 09:16:40 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging: vme: keep track of registered buses
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch> <1313145051-13397-3-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1313145051-13397-3-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Aug 2011 08:13:14.0930 (UTC) FILETIME=[58EDF120:01CC5BEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/11 11:30, Manohar Vanga wrote:
> This patch adds a list which keeps track of all registered VME
> buses. This is required for adding refcounting later to bridge
> modules, something that is not currently implemented.
> 
> This is based on the changes introduced by Emilio G. Cota in the
> patch:
> 
>     https://lkml.org/lkml/2010/10/25/486
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.c        |   38 +++++++++++++++++++++++---------------
>  drivers/staging/vme/vme_bridge.h |    1 +
>  2 files changed, 24 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index d243a4a..feb2d00 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -34,9 +34,10 @@
>  #include "vme.h"
>  #include "vme_bridge.h"
>  
> -/* Bitmask and mutex to keep track of bridge numbers */
> +/* Bitmask and list of registered buses both protected by common mutex */
>  static unsigned int vme_bus_numbers;
> -static DEFINE_MUTEX(vme_bus_num_mtx);
> +static LIST_HEAD(vme_bus_list);
> +static DEFINE_MUTEX(vme_buses_lock);
>  
>  static void __exit vme_exit(void);
>  static int __init vme_init(void);
> @@ -1309,27 +1310,32 @@ EXPORT_SYMBOL(vme_slot_get);
>  
>  /* - Bridge Registration --------------------------------------------------- */
>  
> -static int vme_alloc_bus_num(void)
> +static int vme_add_bus(struct vme_bridge *bridge)
>  {
>  	int i;
> +	int ret = -1;
>  
> -	mutex_lock(&vme_bus_num_mtx);
> +	mutex_lock(&vme_buses_lock);
>  	for (i = 0; i < sizeof(vme_bus_numbers) * 8; i++) {
> -		if (((vme_bus_numbers >> i) & 0x1) == 0) {
> -			vme_bus_numbers |= (0x1 << i);
> +		if ((vme_bus_numbers & (1 << i)) == 0) {
> +			vme_bus_numbers |= (1 << i);
> +			bridge->num = i;
> +			list_add_tail(&bridge->bus_list, &vme_bus_list);
> +			ret = 0;
>  			break;
>  		}
>  	}
> -	mutex_unlock(&vme_bus_num_mtx);
> +	mutex_unlock(&vme_buses_lock);
>  
> -	return i;
> +	return ret;
>  }
>  
> -static void vme_free_bus_num(int bus)
> +static void vme_remove_bus(struct vme_bridge *bridge)
>  {
> -	mutex_lock(&vme_bus_num_mtx);
> -	vme_bus_numbers &= ~(0x1 << bus);
> -	mutex_unlock(&vme_bus_num_mtx);
> +	mutex_lock(&vme_buses_lock);
> +	vme_bus_numbers &= ~(1 << bridge->num);
> +	list_del(&bridge->bus_list);
> +	mutex_unlock(&vme_buses_lock);
>  }
>  
>  int vme_register_bridge(struct vme_bridge *bridge)
> @@ -1338,7 +1344,9 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  	int retval;
>  	int i;
>  
> -	bridge->num = vme_alloc_bus_num();
> +	retval = vme_add_bus(bridge);
> +	if (retval)
> +		return retval;
>  
>  	/* This creates 32 vme "slot" devices. This equates to a slot for each
>  	 * ID available in a system conforming to the ANSI/VITA 1-1994
> @@ -1370,7 +1378,7 @@ err_reg:
>  		dev = &bridge->dev[i];
>  		device_unregister(dev);
>  	}
> -	vme_free_bus_num(bridge->num);
> +	vme_remove_bus(bridge);
>  	return retval;
>  }
>  EXPORT_SYMBOL(vme_register_bridge);
> @@ -1385,7 +1393,7 @@ void vme_unregister_bridge(struct vme_bridge *bridge)
>  		dev = &bridge->dev[i];
>  		device_unregister(dev);
>  	}
> -	vme_free_bus_num(bridge->num);
> +	vme_remove_bus(bridge);
>  }
>  EXPORT_SYMBOL(vme_unregister_bridge);
>  
> diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
> index a9084f0..8959670 100644
> --- a/drivers/staging/vme/vme_bridge.h
> +++ b/drivers/staging/vme/vme_bridge.h
> @@ -112,6 +112,7 @@ struct vme_bridge {
>  	/* Bridge Info - XXX Move to private structure? */
>  	struct device *parent;	/* Parent device (eg. pdev->dev for PCI) */
>  	void *driver_priv;	/* Private pointer for the bridge driver */
> +	struct list_head bus_list; /* list of VME buses */
>  
>  	struct device dev[VME_SLOTS_MAX];	/* Device registered with
>  						 * device model on VME bus


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
