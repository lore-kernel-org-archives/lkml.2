Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab1CYIbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:31:10 -0400
Received: from ch-smtp04.sth.basefarm.net ([80.76.153.5]:51647 "EHLO
	ch-smtp04.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933465Ab1CYIbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:31:05 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 25 Mar 2011 09:34:48 +0100
To: Jeff Brown <jeffbrown@android.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] input: evdev: only wake poll on EV_SYN
Message-ID: <20110325083448.GA5738@polaris.bitmath.org>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-5-git-send-email-jeffbrown@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300842244-42723-5-git-send-email-jeffbrown@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q32Pu-0003fF-DS.
X-Scan-Signature: ch-smtp04.sth.basefarm.net 1Q32Pu-0003fF-DS ddc377d4bf4d0f4d973571201ee19f0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 06:04:04PM -0700, Jeff Brown wrote:
> On SMP systems, it is possible for an evdev client blocked on poll()
> to wake up and read events from the evdev ring buffer at the same
> rate as they are enqueued.  This can result in high CPU usage,
> particularly for MT devices, because the client ends up reading
> events one at a time instead of reading complete packets.  This patch
> ensures that the client only wakes from poll() when a complete packet
> is ready to be read.
> 
> Signed-off-by: jeffbrown@android.com
> ---
>  drivers/input/evdev.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 203ed70..7b6770d 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -73,7 +73,7 @@ static void evdev_pass_event(struct evdev_client *client,
>  	}
>  	spin_unlock(&client->buffer_lock);
>  
> -	if (event->type == EV_SYN)
> +	if (event->type == EV_SYN && event->code != SYN_MT_REPORT)

It is not clear what should happen at the other SYN events.  Maybe
event->code == SYN_REPORT instead?

>  		kill_fasync(&client->fasync, SIGIO, POLL_IN);
>  }
>  
> @@ -103,7 +103,8 @@ static void evdev_event(struct input_handle *handle,
>  
>  	rcu_read_unlock();
>  
> -	wake_up_interruptible(&evdev->wait);
> +	if (type == EV_SYN && code != SYN_MT_REPORT)
> +		wake_up_interruptible(&evdev->wait);

Ah, this is a good one. Since the code depends on the same logic being
applied in evdev_pass_event as well, a boolean argument to that
function would be good.

Thanks,
Henrik
