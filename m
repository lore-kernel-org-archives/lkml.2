Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab2C2C0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:26:47 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55691 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2C2C0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:26:40 -0400
Message-ID: <1332987941.1870.176.camel@aeonflux>
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
From: Marcel Holtmann <marcel@holtmann.org>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>
Date: Thu, 29 Mar 2012 04:25:41 +0200
In-Reply-To: <1332983958-2734-1-git-send-email-keithp@keithp.com>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

> This reverts commit 4b95a24ce12c4545fd7d2e3075841dc3119d1d71.
> 
> My USB bluetooth device does not show up with this patch in place.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
> 
> This patch seems so innocuous, but when added to the kernel, it keeps
> my USB bluetooth device from appearing to user mode at all. With the
> mgmt interface enabled:
> 
> 	$ hcitool dev
> 	Devices:
> 
> With this patch reverted:
> 
> 	$ hcitool dev
> 	Devices:
> 		hci0	04:0C:CE:DF:7B:C9

so this is seriously strange and I don't have an explanation for it
right now. Something breaking on this level means that Bluetooth devices
are not even registered. And that would be an obvious bug to detect.

Can you check with hciconfig -a if the device is actually there, but
might have some weird flags set.

> I bisected to this revision, and then reverted it on top of version
> 
> 	v3.3-6972-ge22057c	e22057c8599373e5caef0bc42bdb95d2a361ab0d
> 
> (which is where I'm trying to move drm-intel-fixes to)
> 
> I think this is the third consecutive merge window that has broken my
> bluetooth interface in some way? At least I know enough to check
> now...
> 
>  net/bluetooth/hci_sock.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index 63afd23..d8b16cf 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -50,6 +50,8 @@
>  #include <net/bluetooth/hci_core.h>
>  #include <net/bluetooth/hci_mon.h>
>  
> +static bool enable_mgmt;
> +
>  static atomic_t monitor_promisc = ATOMIC_INIT(0);
>  
>  /* ----- HCI socket interface ----- */
> @@ -649,7 +651,7 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr, int addr_le
>  		break;
>  
>  	case HCI_CHANNEL_CONTROL:
> -		if (haddr.hci_dev != HCI_DEV_NONE) {
> +		if (haddr.hci_dev != HCI_DEV_NONE || !enable_mgmt) {
>  			err = -EINVAL;
>  			goto done;
>  		}

I have no idea on how this can break anything for you. Since tools like
hcitool and hciconfig use HCI_CHANNEL_RAW. This must be a nasty side
effect somewhere if this is really fix it for you.

Can you start your bluetoothd with -P mgmtops to check if this might be
causing some side effects.

Regards

Marcel


