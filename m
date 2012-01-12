Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2ALMNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 07:13:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59364 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2ALMNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 07:13:32 -0500
Message-ID: <4F0ECE29.3060109@mvista.com>
Date: Thu, 12 Jan 2012 16:12:25 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/6 v2] usb/gadget/pch_udc: Fix disconnect issue
References: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
In-Reply-To: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-01-2012 6:27, Tomoya MORINAGA wrote:

> ISSUE:
> When the driver notifies a gadget of a disconnect event, a system rarely freezes.

> CAUSE:
> When the driver calls dev->driver->disconnect(), it is not calling spinlock().

    spin_unlock(), you mean?

> Signed-off-by: Tomoya MORINAGA<tomoya.rohm@gmail.com>
> ---
> V2: Divide into 6 patches
> ---
>   drivers/usb/gadget/pch_udc.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)

> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> index f222659..a4f8b08 100644
> --- a/drivers/usb/gadget/pch_udc.c
> +++ b/drivers/usb/gadget/pch_udc.c
> @@ -2340,8 +2340,11 @@ static void pch_udc_svc_ur_interrupt(struct pch_udc_dev *dev)
>   		/* Complete request queue */
>   		empty_req_queue(ep);
>   	}
> -	if (dev->driver&&  dev->driver->disconnect)
> +	if (dev->driver&&  dev->driver->disconnect) {
> +		spin_unlock(&dev->lock);
>   		dev->driver->disconnect(&dev->gadget);
> +		spin_lock(&dev->lock);
> +	}

WBR, Sergei
