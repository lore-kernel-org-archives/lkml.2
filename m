Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094Ab0KQRaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:30:00 -0500
Received: from kroah.org ([198.145.64.141]:47875 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934912Ab0KQR37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:29:59 -0500
Date: Wed, 17 Nov 2010 09:19:24 -0800
From: Greg KH <greg@kroah.com>
To: Yehuda Sadeh <yehuda@hq.newdream.net>
Cc: sage@newdream.net, yehudasa@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
Message-ID: <20101117171924.GC12050@kroah.com>
References: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 04:32:09PM -0800, Yehuda Sadeh wrote:
> Hi Greg,
> 
> Following is the new rbd sysfs interface. It lists devices in their own
> subdirectories, as well as their underlying snapshots. Please let us
> know if there's any issue you think we missed or did wrong.
> 
> Thanks,
> Yehuda
> 
> ---
> 
> The new interface creates directories per mapped image
> and under each it creates a subdir per available snapshot.
> This allows keeping a cleaner interface within the sysfs
> guidelines. The ABI documentation was updated too.
> 
> Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
> ---
>  Documentation/ABI/testing/sysfs-class-rbd |   83 +++
>  drivers/block/rbd.c                       |  775 +++++++++++++++++------------
>  2 files changed, 547 insertions(+), 311 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-rbd b/Documentation/ABI/testing/sysfs-class-rbd
> new file mode 100644
> index 0000000..4d96618
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-rbd
> @@ -0,0 +1,83 @@
> +What:		/sys/class/rbd/

I thought I mentioned that you should not add new classes to the kernel.
Please don't do that, make it a bus_type instead.

Actually, that will solve some of your coding problems as well:

> @@ -193,6 +130,11 @@ struct rbd_device {
>  	int read_only;
>  
>  	struct list_head	node;
> +
> +	struct device		dev;
> +	struct kobject		snaps_kobj;
> +	struct list_head	snaps;
> +	int			kobj_ready;
>  };

Woah, that's wrong.  You can NEVER have two different reference counted
objects as part of a single structure.  Your reference counting is
guaranteed to be wrong.

You should not need a kobject at all here, just use a device and be done
with it.

Hope this helps,

greg k-h
