Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1LEQCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:02:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35792 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932406Ab1LEQCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:02:39 -0500
Date: Mon, 5 Dec 2011 11:02:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: Chen Peter-B29397 <B29397@freescale.com>, NeilBrown <neilb@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
In-Reply-To: <CACVXFVOc45HL_qPHvNcGrkcQ7XWxBoLHikrYd1ZrRMYkiw5=ag@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1112051100150.5138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Ming Lei wrote:

> Sorry, the above is line wrapped badly, see the below:
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index d8b3d89..96b266c 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1743,8 +1743,9 @@ void device_shutdown(void)
>  		 */
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
> -		/* Disable all device's runtime power management */
> -		pm_runtime_disable(dev);
> +
> +		/* put device into active state and forbit runtime pm */
> +		pm_runtime_forbid(dev);
> 
>  		if (dev->bus && dev->bus->shutdown) {
>  			dev_dbg(dev, "shutdown\n");

We don't want to put devices into the active state when it's not 
necessary.  A better approach would be:

		/* Don't allow any more runtime suspends */
		pm_runtime_get_noresume(dev);
		pm_runtime_barrier(dev);

Alan Stern

