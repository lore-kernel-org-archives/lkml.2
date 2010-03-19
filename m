Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0CSCQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:16:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:36521 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751251Ab0CSCQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:16:34 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18RCTIyX3gRYVTUgW1/y/EwfEC4wHar46t79sOQEF
	/Y212PdclY3Olv
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch b43-workaround-circular-locking-in-hw-tkip-key-update-callback.patch added to 2.6.33-stable tree
Date: Fri, 19 Mar 2010 03:16:22 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-1.slh.1-sidux-686; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net,
       johannes@sipsolutions.net, linville@tuxdriver.com, mb@bu3sch.de,
       stable@kernel.org
References: <12689584343638@kroah.org>
In-Reply-To: <12689584343638@kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003190316.28515.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 19 March 2010, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: b43: Workaround circular locking in hw-tkip key update callback
> 
> to the 2.6.33-stable tree.  Its filename is
[...]
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Wed, 10 Mar 2010 22:10:32 -0600
> Subject: b43: Workaround circular locking in hw-tkip key update callback
> To: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Michael Buesch <mb@bu3sch.de>
> Message-ID: <4b986d38.aOKVIPS3U9/aYsOP%Larry.Finger@lwfinger.net>
> 
> From: Michael Buesch <mb@bu3sch.de>
> 
> commit 96869a39399269a776a94812e9fff3d38b47d838 upstream
> 
> The TKIP key update callback is called from the RX path, where the driver
> mutex is already locked. This results in a circular locking bug.
> Avoid this by removing the lock.
>     
> Johannes noted that there is a separate bug: The callback still breaks on SDIO
> hardware, because SDIO hardware access needs to sleep, but we are not allowed
> to sleep in the callback due to mac80211's RCU locking.
[...]

This patch breaks compiling 2.6.33.1 + the current stable queue (and likely 
queue-2.6.32 as well):

  CC [M]  drivers/net/wireless/b43/main.o
drivers/net/wireless/b43/main.c: In function 'b43_op_update_tkip_key':
drivers/net/wireless/b43/main.c:868: error: 'sta' undeclared (first use in this function)
drivers/net/wireless/b43/main.c:868: error: (Each undeclared identifier is reported only once
drivers/net/wireless/b43/main.c:868: error: for each function it appears in.)

as it is based on the mac80211 API change of 

Gitweb:     http://git.kernel.org/linus/b3fbdcf49f940d0703c356441e0daf045e64e076
Commit:     b3fbdcf49f940d0703c356441e0daf045e64e076
Parent:     e4fca007b06165900d0e44e8d5e251376819bf5d
Author:     Johannes Berg <johannes@sipsolutions.net>
AuthorDate: Thu Jan 21 11:40:47 2010 +0100
Committer:  John W. Linville <linville@tuxdriver.com>
CommitDate: Fri Jan 22 16:08:55 2010 -0500

    mac80211: pass vif and station to update_tkip_key
    
    When a TKIP key is updated, we should pass the station
    pointer instead of just the address, since drivers can
    use that to store their own data. We also need to pass
    the virtual interface pointer.

which also touches, besides the API mac80211 tkip handling, iwl-agn as well
as b43.

Regards
	Stefan Lippers-Hollmann

-- 
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -852,19 +852,19 @@ static void b43_op_update_tkip_key(struc
>  	if (B43_WARN_ON(!modparam_hwtkip))
>  		return;
>  
> -	mutex_lock(&wl->mutex);
> -
> +	/* This is only called from the RX path through mac80211, where
> +	 * our mutex is already locked. */
> +	B43_WARN_ON(!mutex_is_locked(&wl->mutex));
>  	dev = wl->current_dev;
> -	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
> -		goto out_unlock;
> +	B43_WARN_ON(!dev || b43_status(dev) < B43_STAT_INITIALIZED);
>  
>  	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
>  
>  	rx_tkip_phase1_write(dev, index, iv32, phase1key);
> +	/* only pairwise TKIP keys are supported right now */
> +	if (WARN_ON(!sta))
> +		return;
>  	keymac_write(dev, index, addr);
> -
> -out_unlock:
> -	mutex_unlock(&wl->mutex);
>  }
>  
>  static void do_key_write(struct b43_wldev *dev,
