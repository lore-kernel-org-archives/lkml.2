Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453Ab2EJSxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:53:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:30487 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760305Ab2EJSx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:53:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141535559"
Message-ID: <4FAC0EA7.3000100@intel.com>
Date: Thu, 10 May 2012 11:53:27 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Ko <stephen.s.ko@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [ 33/52] net: Fix issue with netdev_tx_reset_queue not resetting
 queue from XOFF state
References: <20120510173135.772550373@linuxfoundation.org>
In-Reply-To: <20120510173135.772550373@linuxfoundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 10:32 AM, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
>
> From: Alexander Duyck <alexander.h.duyck@intel.com>
>
> [ Upstream commit 5c4903549c05bbb373479e0ce2992573c120654a ]
>
> We are seeing dev_watchdog hangs on several drivers.  I suspect this is due
> to the __QUEUE_STATE_STACK_XOFF bit being set prior to a reset for link
> change, and then not being cleared by netdev_tx_reset_queue.  This change
> corrects that.
>
> In addition we were seeing dev_watchdog hangs on igb after running the
> ethtool tests.  We found this to be due to the fact that the ethtool test
> runs the same logic as ndo_start_xmit, but we were never clearing the XOFF
> flag since the loopback test in ethtool does not do byte queue accounting.
>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Tested-by: Stephen Ko <stephen.s.ko@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c |    3 ++-
>  include/linux/netdevice.h                 |    1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -2750,6 +2750,8 @@ void igb_configure_tx_ring(struct igb_ad
>  
>  	txdctl |= E1000_TXDCTL_QUEUE_ENABLE;
>  	wr32(E1000_TXDCTL(reg_idx), txdctl);
> +
> +	netdev_tx_reset_queue(txring_txq(ring));
>  }
>  
>  /**
> @@ -3242,7 +3244,6 @@ static void igb_clean_tx_ring(struct igb
>  		buffer_info = &tx_ring->tx_buffer_info[i];
>  		igb_unmap_and_free_tx_resource(tx_ring, buffer_info);
>  	}
> -	netdev_tx_reset_queue(txring_txq(tx_ring));
>  
>  	size = sizeof(struct igb_tx_buffer) * tx_ring->count;
>  	memset(tx_ring->tx_buffer_info, 0, size);
All of the changes in igb are unnecessary.  I think they can be dropped
from the patch as they have already been reverted from the latest
net-next.  The only change that is really needed is the piece in
netdevice.h below.
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1955,6 +1955,7 @@ static inline void netdev_completed_queu
>  static inline void netdev_tx_reset_queue(struct netdev_queue *q)
>  {
>  #ifdef CONFIG_BQL
> +	clear_bit(__QUEUE_STATE_STACK_XOFF, &q->state);
>  	dql_reset(&q->dql);
>  #endif
>  }
>
>
Thanks,

Alex
