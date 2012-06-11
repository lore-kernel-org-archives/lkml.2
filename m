Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab2FKOQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:16:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50476 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754645Ab2FKOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:16:18 -0400
Date: Mon, 11 Jun 2012 10:16:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
In-Reply-To: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1206111014010.1607-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, Ming Lei wrote:

> @@ -1820,6 +1833,18 @@ void device_shutdown(void)
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
>  
> +		/* hold lock to avoid race with .probe/.release */
> +		if (dev->parent && !__try_lock(dev->parent))
> +			nonlocked = 2;
> +		else if (!__try_lock(dev))
> +			nonlocked = 1;
> +		else
> +			nonlocked = 0;
> +
> +		if (nonlocked)
> +			dev_err(dev, "can't hold %slock for shutdown\n",
> +					nonlocked == 1 ? "" : "parent ");

Even if the parent can't be locked, you should still try to lock the 
device.

Alan Stern

