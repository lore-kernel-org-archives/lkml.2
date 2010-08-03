Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0HCRr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:47:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab0HCRry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:47:54 -0400
Date: Tue, 3 Aug 2010 10:47:22 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 6/6] staging: hv: Gracefully handle SCSI resets
Message-ID: <20100803174722.GG1455@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D3C@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FD1D3C@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:31:56PM +0000, Hank Janssen wrote:
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> If we get a SCSI host bus reset we now gracefully handle it, and we take the device offline. 
> This before sometimes caused hangs.

Is this a problem for all older versions as well?  If so, should it be
backported to the -stable kernel releases?

> 
> Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
> 
> 
> ---
>  drivers/staging/hv/storvsc.c |   36 +++++++++++++++++++++++++++++++++++-
>  1 files changed, 35 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c index 6bd2ff1..5f222cf 100644
> --- a/drivers/staging/hv/storvsc.c
> +++ b/drivers/staging/hv/storvsc.c
> @@ -48,7 +48,9 @@ struct storvsc_device {
>  
>  	/* 0 indicates the device is being destroyed */
>  	atomic_t RefCount;
> -
> +	

Trailing whitespace :(

> +	int reset;

Can't this be a bool?

> +	spinlock_t lock;
>  	atomic_t NumOutstandingRequests;
>  
>  	/*
> @@ -93,6 +95,9 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
>  	atomic_cmpxchg(&storDevice->RefCount, 0, 2);
>  
>  	storDevice->Device = Device;
> +	storDevice->reset  = 0;
> +	spin_lock_init(&storDevice->lock);
> +
>  	Device->Extension = storDevice;
>  
>  	return storDevice;
> @@ -101,6 +106,7 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)  static inline void FreeStorDevice(struct storvsc_device *Device)  {
>  	/* ASSERT(atomic_read(&Device->RefCount) == 0); */
> +	/*kfree(Device->lock);*/

Why add a commented out line?  Especially one that is incorrect?  :)

>  	kfree(Device);
>  }
>  
> @@ -108,13 +114,24 @@ static inline void FreeStorDevice(struct storvsc_device *Device)  static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)  {
>  	struct storvsc_device *storDevice;
> +	unsigned long flags;
>  
>  	storDevice = (struct storvsc_device *)Device->Extension;
> +
> +	spin_lock_irqsave(&storDevice->lock, flags);
> +
> +	if (storDevice->reset == 1) {
> +		spin_unlock_irqrestore(&storDevice->lock, flags);
> +		return NULL;

Don't return here, jump to the end of the function and return there.
That way you only have one lock/unlock pair and it's much easier to
maintain and audit over time that you got everything correct.

> +	}
> +
>  	if (storDevice && atomic_read(&storDevice->RefCount) > 1)
>  		atomic_inc(&storDevice->RefCount);
>  	else
>  		storDevice = NULL;
>  
> +	spin_unlock_irqrestore(&storDevice->lock, flags);
> +
>  	return storDevice;
>  }
>  
> @@ -122,13 +139,19 @@ static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)  static inline struct storvsc_device *MustGetStorDevice(struct hv_device *Device)  {
>  	struct storvsc_device *storDevice;
> +	unsigned long flags;
>  
>  	storDevice = (struct storvsc_device *)Device->Extension;
> +
> +	spin_lock_irqsave(&storDevice->lock, flags);
> +
>  	if (storDevice && atomic_read(&storDevice->RefCount))
>  		atomic_inc(&storDevice->RefCount);
>  	else
>  		storDevice = NULL;
>  
> +	spin_unlock_irqrestore(&storDevice->lock, flags);
> +
>  	return storDevice;
>  }
>  
> @@ -614,6 +637,7 @@ int StorVscOnHostReset(struct hv_device *Device)
>  	struct storvsc_device *storDevice;
>  	struct storvsc_request_extension *request;
>  	struct vstor_packet *vstorPacket;
> +	unsigned long flags;
>  	int ret;
>  
>  	DPRINT_INFO(STORVSC, "resetting host adapter..."); @@ -625,6 +649,16 @@ int StorVscOnHostReset(struct hv_device *Device)
>  		return -1;
>  	}
>  
> +	spin_lock_irqsave(&storDevice->lock, flags);
> +	storDevice->reset = 1;
> +	spin_unlock_irqrestore(&storDevice->lock, flags);
> +
> +	/*
> +	 * Wait for traffic in transit to complete
> +	 */
> +	while (atomic_read(&storDevice->NumOutstandingRequests))
> +		udelay(1000);

What's ever going to get us out of this loop?  You need a fall-back in
case this read never succeeds.

And why an atomic value if you have a lock protecting it?  That's major
overkill and is probably not needed.

thanks,

greg k-h
