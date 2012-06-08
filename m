Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2FHNkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:40:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36319 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752032Ab2FHNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:40:30 -0400
Date: Fri, 8 Jun 2012 09:40:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v1)
In-Reply-To: <1339133929-30679-1-git-send-email-ming.lei@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1206080938400.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012, Ming Lei wrote:

> Firstly, .shutdown callback may touch a uninitialized hardware
> if dev->driver is set and .probe is not completed.
> 
> Secondly, device_shutdown() may dereference a null pointer to cause
> oops when dev->driver is cleared after it is checked in
> device_shutdown().
> 
> So just hold device lock and its parent lock if it has to fix the
> races.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/core.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 346be8b..cbc8bd2 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1820,6 +1820,11 @@ void device_shutdown(void)
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
>  
> +		/*hold lock[s] to avoid races with .probe/.release*/
> +		if (dev->parent)
> +			device_lock(dev->parent);
> +		device_lock(dev);

Would you prefer to use device_trylock in a loop?  I guess this comes 
down to which you prefer: a hang during shutdown, or a crash.  :-)

Alan Stern

