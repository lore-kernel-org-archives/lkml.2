Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1CGOo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:44:29 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39450 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1CGOo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nRIaA4Cq19urAgJbfhNF/bZK0IDMLfXaw9ucRpfRBTEq43uoqeD5ObVwms2NCigxnR
         vZJQxjS0azZXRYHG4aO8wWIhhdeiD7nmcwrg/6VSPNu4ygzp8kJLsXy1KK1mW051z4KL
         REvC5koNjO/tqDkMa5Qs9HHca3VfT9SI9rWhU=
MIME-Version: 1.0
In-Reply-To: <4D748070.1030502@localhost>
References: <4D71668F.9050201@windriver.com>
	<4D748070.1030502@localhost>
Date: Mon, 7 Mar 2011 09:44:25 -0500
Message-ID: <AANLkTikkGA6MUUm6yzHPcc7xktsyJzGmimQ0mbNQJ9vK@mail.gmail.com>
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org, lwn@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 1:51 AM, Fernando Lopez-Lezcano
<nando@ccrma.stanford.edu> wrote:
> On 03/04/2011 02:24 PM, Paul Gortmaker wrote:
>>
>> As a value add to the 2.6.34 long term release, I'm happy to also
>> announce the availability of 2.6.34-RT.
>>
>> You can find it in the v2.6.34-rt branch at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git
>
> Great! Many thanks... Actually, impressive work.
>
> I'm trying to integrate/build it into my Fedora based rt packages for Planet
> CCRMA. Warning: I'm doing this on top of the 2.6.34.8-68 fc13 koji build, so
> rt is patched on top of the additional Fedora patches for that build (with a
> few trivial tweaks to patch cleanly). So I don't know if the following
> issues are due to that - I will investigate:

Thanks - I'm not surprised to see some fallout in new/updated drivers,
since they change so much per release and I didn't attempt to build every
driver under the sun - my core focus was on getting it stable with the main
defconfigs I could easily test.   I'll have a look and integrate accordingly.

P.

>
> I found a couple of extra argument cases for __netif_tx_lock:
>
> --- a/drivers/net/qlcnic/qlcnic_main.c  2010-05-16 17:17:36.000000000 -0400
> +++ b/drivers/net/qlcnic/qlcnic_main.c  2011-03-06 20:08:16.000000000 -0500
> @@ -1881,7 +1881,7 @@
>                smp_mb();
>
>                if (netif_queue_stopped(netdev) && netif_carrier_ok(netdev))
> {
> -                       __netif_tx_lock(tx_ring->txq, smp_processor_id());
> +                       __netif_tx_lock(tx_ring->txq);
>                        if (qlcnic_tx_avail(tx_ring) > TX_STOP_THRESH) {
>                                netif_wake_queue(netdev);
>                                adapter->tx_timeo_cnt = 0;
> --- a/drivers/net/bnx2x_main.c  2010-05-16 17:17:36.000000000 -0400
> +++ b/drivers/net/bnx2x_main.c  2011-03-06 19:58:45.000000000 -0500
> @@ -976,7 +976,7 @@
>                 * stops the queue
>                 */
>
> -               __netif_tx_lock(txq, smp_processor_id());
> +               __netif_tx_lock(txq);
>
>                if ((netif_tx_queue_stopped(txq)) &&
>                    (bp->state == BNX2X_STATE_OPEN) &&
> ----
>
> a missing include (incomplete type errors for semaphores):
>
> --- a/drivers/net/mlx4/mlx4.h   2010-05-16 17:17:36.000000000 -0400
> +++ b/drivers/net/mlx4/mlx4.h   2011-03-06 20:07:05.000000000 -0500
> @@ -37,6 +37,7 @@
>  #ifndef MLX4_H
>  #define MLX4_H
>
> +#include <linux/semaphore.h>
>  #include <linux/mutex.h>
>  #include <linux/radix-tree.h>
>  #include <linux/timer.h>
> ----
>
> and this (found compilation fix here:
> http://groups.google.com/group/linux.kernel/browse_thread/thread/c4f0fd1ca9298c45/18316184209e6e84?show_docid=18316184209e6e84&fwc=1):
>
> --- a/drivers/net/wireless/ath/ar9170/usb.c     2011-03-06
> 19:13:12.000000000 -0500
> +++ b/drivers/net/wireless/ath/ar9170/usb.c     2011-03-06
> 20:13:06.000000000 -0500
> @@ -741,10 +741,10 @@
>
>        /* unbind anything failed */
>        if (parent)
> -               down(&parent->sem);
> +               device_lock(parent);
>        device_release_driver(&aru->udev->dev);
>        if (parent)
> -               up(&parent->sem);
> +               device_unlock(parent);
>
>        usb_put_dev(aru->udev);
>  }
> ----
>
> I'll let you know how it goes (light testing probably tomorrow, still
> building).
>
> -- Fernando "patiently waiting for 2.6.37-rtx"
> :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
